/**
© Copyright 2019, The Great Rift Valley Software Company

LICENSE:

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/

import Foundation

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Vendor_OBD_Parser -
/* ###################################################################################################################################### */
/**
 This struct acts as an OBD response parser, accepting a near-complete transaction, parsing the response, then storing the complete transaction.
 */
internal struct RVS_BTDriver_Vendor_OBD_Parser {
    /* ################################################################## */
    /**
     This is per [this SO answer](https://stackoverflow.com/a/60043419/879365).
     What is happening here, is that each interpreter type has a "factory" static funtion that will create (or not create) an instance of the interpreter, based on the input data.
     We can add each type to our Array, so that we can have a dynamic assignment.
     */
    static let interpreterClasses: [RVS_BTDriver_OBD_Command_Service_Command_Interpreter_Internal.Type] = [
        RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter.self,
        RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter.self,
        RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature.self,
        RVS_BTDriver_OBD_Command_Service_03.self
    ]
    
    /* ################################################################## */
    /**
     Searching placeholder always begins with this
     */
    static internal let searchingString = "SEARCHING"
    
    /* ################################################################## */
    /**
     If the command returns no data, this will be the string.
     */
    static internal let noDataString = "NO DATA"
    
    /* ################################################################## */
    /**
     The first two characters in an AT response (echoing the command).
     */
    static internal let atHeader = "AT"

    /* ################################################################## */
    /**
     This will hold the transaction we are parsing.
     */
    internal let transaction: RVS_BTDriver_OBD_Device_TransactionStruct!
    
    /* ################################################################## */
    /**
     - returns: The Transaction interpreter (if any). May be nil.
     */
    public var interpreter: RVS_BTDriver_OBD_Command_Service_Command_Interpreter! {
        return transaction?.interpreter
    }

    /* ################################################################## */
    /**
     This static function will parse a response string from an AT command.
     
     - parameter inResponseString: The transaction response.
     
     - returns: A String, containing the transaction response. Nil, if the packet could not be parsed.
     */
    internal static func parseATResponse(_ inResponseStrings: [String]) -> String! {
        #if DEBUG
            print("Parsing AT Response: \"\(inResponseStrings)\".")
        #endif
        return inResponseStrings.joined(separator: "\r")
    }
    
    /* ################################################################## */
    /**
     This static function will parse a response string from an OBD command.
     
     - parameter inResponseString: The transaction response.
     
     - returns: A String, containing the transaction response. Nil, if the packet could not be parsed.
     */
    internal static func parseOBDResponse(_ inResponseStrings: [String]) -> String! {
        #if DEBUG
            print("Parsing OBD Response: \"\(inResponseStrings)\".")
        #endif
        
        let ret = inResponseStrings.joined(separator: "\n")
        
        #if DEBUG
            print("AS ASCII: \"\(String(describing: ret.hex2UTF8))\".")
        #endif
        
        return ret
    }

    /* ################################################################## */
    /**
     This static function will parse the transaction response, and return it to be added to the transaction.
     
     - parameter inPacketData: The transaction response.
     
     - returns: A String, containing the transaction response. Nil, if the packet could not be parsed.
     */
    internal static func parseOBDPacket(_ inPacketData: String) -> String! {
        #if DEBUG
            print("Parsing: \"\(inPacketData)\".")
        #endif
        
        var stringComponents = inPacketData.split(separator: "\n").compactMap { $0.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r"])) }
        
        if  1 < stringComponents.count {
            #if DEBUG
                print("Split Components: \"\(stringComponents)\".")
            #endif
            
            // Get rid of the echoed command. Keep it, for examination.
            let commandEcho = stringComponents.removeFirst()
            
            // If we have a "SEARCHING...", we get rid of that, too.
            if stringComponents[0].starts(with: searchingString) {
                stringComponents.removeFirst()
            }
            
            // Get rid of any empty lines.
            let stringComponents = stringComponents.filter { !$0.isEmpty }
            
            if 0 < stringComponents.count {
                // See if we need to treat it as an AT command response.
                if commandEcho.starts(with: atHeader) {
                    return parseATResponse(stringComponents)
                } else if Self.noDataString == stringComponents[0] {
                    #if DEBUG
                        print("NO DATA")
                    #endif
                } else {    // If neither of the above, we
                    return parseOBDResponse(stringComponents)
                }
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     The initializer actually does the parsing.
     
     Upon instantiation, the transaction property woill contain the parsed and complete transaction.
     
     - parameter transaction: The transaction to be parsed.
     */
    internal init(transaction inTransaction: RVS_BTDriver_OBD_Device_TransactionStruct) {
        if  let responseData = inTransaction.responseData,
            let trimmedResponse = String(data: responseData, encoding: .ascii)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
            #if DEBUG
                print("Trimming \"\(trimmedResponse)\".")
            #endif
            
            if let trimmedResponse2 = Self.parseOBDPacket(trimmedResponse.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r"]))) {
                #if DEBUG
                    print("Cleaned Response: \"\(trimmedResponse2)\".")
                #endif

                // We will cycle through our list of interpreters. There should only be one.
                let interpreters: [RVS_BTDriver_OBD_Command_Service_Command_Interpreter] = Self.interpreterClasses.compactMap {
                    if  let command = inTransaction.rawCommand {    // First, we should get the "raw" command, as we will be using that to determine the PID and service.
                        let testTrimmed = trimmedResponse2.hexOnly  // Strip down to just the hex components. This removes spaces and ancillary characters.
                        let serviceStr = String(command[..<command.index(command.startIndex, offsetBy: 2)])  // We start by getting just the reflected service from the front of the returned String.
                        // The PID is the next two characters.
                        let pid = String(command[command.index(command.startIndex, offsetBy: 2)..<command.index(command.startIndex, offsetBy: 4)])
                        if  let service = Int(serviceStr, radix: 16),   // Make sure that we got a valid service
                            let pidInt = Int(pid, radix: 16) {          // Same with the PID
                            let pidLookupString = String(format: "%02X%02X", service, pidInt)   // Make a test String that is constructed of the two Ints.
                            if $0.pidCommands.contains(pidLookupString) {   // The interpreter should list the PID/Service in its Array of supported PIDs.
                                var dataString = ""
                                // Compare this string to the front of the response, to see if we have a "short" response.
                                let compString = String(format: "4%X%02X", service, pidInt) // Short strings start with a 4-digit hex string that always has "4" as its first character.
                                if compString == String(testTrimmed[..<testTrimmed.index(testTrimmed.startIndex, offsetBy: 4)]) {
                                    dataString = String(testTrimmed[testTrimmed.index(testTrimmed.startIndex, offsetBy: 4)...]) // This is easy. We just use the "filtered" hex string.
                                } else {
                                    dataString = trimmedResponse2  // Otherwise, we just send it all in, unfiltered.
                                }
                                // Once we have our groomed data, it's time to try establishing an interpreter.
                                let ret = $0.init(contents: dataString, service: service)
                                
                                if ret.valid {  // This flag will only be set if the interpreter successfully handled the data.
                                    return ret
                                }
                            }
                        }
                    }
                    
                    return nil
                }
                
                // If we had one or more (there should only be one) interpreter, then we have a valid transaction.
                if 0 < interpreters.count {
                    assert(1 == interpreters.count, "There Can Be Only One. -Connor MacLeod")
                    transaction = RVS_BTDriver_OBD_Device_TransactionStruct(device: inTransaction.device, rawCommand: inTransaction.rawCommand, completeCommand: inTransaction.completeCommand, responseData: inTransaction.responseData, responseDataAsString: trimmedResponse2, error: nil, interpreter: interpreters[0])
                    return
                }
            }
        }
        
        transaction = inTransaction
    }
}
