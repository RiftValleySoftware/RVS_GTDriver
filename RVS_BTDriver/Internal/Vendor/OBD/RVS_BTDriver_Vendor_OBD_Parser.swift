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

    internal let transaction: RVS_BTDriver_OBD_Device_TransactionStruct!
    
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
        
        let ret = inResponseStrings.joined(separator: "\r")
        
        #if DEBUG
            print("AS ASCII: \"\(ret.hex2ASCII)\".")
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
        
        var stringComponents = inPacketData.split(separator: "\r").compactMap { $0.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r"])) }
        
        if 1 < stringComponents.count {
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
        if let trimmedResponse = String(data: inTransaction.responseData, encoding: .ascii)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
            #if DEBUG
                print("Trimming \"\(trimmedResponse)\".")
            #endif
            
            if let trimmedResponse2 = Self.parseOBDPacket(trimmedResponse.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r"]))) {
                #if DEBUG
                    print("Cleaned Response: \"\(trimmedResponse2)\".")
                #endif

                transaction = RVS_BTDriver_OBD_Device_TransactionStruct(device: inTransaction.device, rawCommand: inTransaction.rawCommand, completeCommand: inTransaction.completeCommand, responseData: inTransaction.responseData, responseDataAsString: trimmedResponse2, error: nil)
                return
            }
        }
        
        transaction = inTransaction
    }
}
