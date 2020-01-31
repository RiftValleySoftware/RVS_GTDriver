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
// MARK: - RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMask Protocol -
/* ###################################################################################################################################### */
/**
 This is the base protocol for command interpreters. It defines an Array of String, which is used to match the interpreter with the PID it is applied to.
 */
public protocol RVS_BTDriver_OBD_Command_Service_Command_Interpreter {
    /* ################################################################## */
    /**
     This returns an Array of Strings, reflecting which PIDs will return data to be decoded by this mask set.
     */
    static var pidCommands: [String] { get }
    
    /* ################################################################## */
    /**
     This return an Int, with the service being handled by this interpreter.
     */
    var service: Int { get }
    
    /* ################################################################## */
    /**
     This will read in the data, and save the header (a UInt8 bitmask), and the data (4 UInt16).
     
     - parameter contents: The contents, as a String of 2-character hex numbers, space-separated.
     - parameter service: The service to which this interpreter applies.
     */
    init(contents inContents: String, service inService: Int)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Device_TransactionStruct Struct -
/* ###################################################################################################################################### */
/**
 This struct will contain a transaction for an OBD device.
 OBD transactions are atomic and single-threaded. There can only be one going to a device at a time.
 */
public struct RVS_BTDriver_OBD_Device_TransactionStruct {
    /* ################################################################## */
    /**
     This is the OBD device instance, running the transaction.
     */
    public let device: RVS_BTDriver_OBD_DeviceProtocol!
    
    /* ################################################################## */
    /**
     This is the raw String value of the command being sent (it may be a format string).
     */
    public let rawCommand: String!

    /* ################################################################## */
    /**
     This is the command, filled out (it may be the same as the rawCommand, but a format will have values substituted).
     */
    public var completeCommand: String!
    
    /* ################################################################## */
    /**
     This is any data that was returned from the OBD adapter.
     */
    public var responseData: Data!
    
    /* ################################################################## */
    /**
     This is the response, "cleaned," and converted to a String (if possible).
     
     Upon being set, we execute the parser.
     */
    public var parsedData: String! {
       didSet {
           parseCommand()
       }
    }

    /* ################################################################## */
    /**
     Any error that may have occurred.
     */
    public var error: RVS_BTDriver.Errors!
    
    /* ################################################################## */
    /**
     This is any data that was returned from the OBD adapter.
     */
    public var interpreters: [RVS_BTDriver_OBD_Command_Service_Command_Interpreter] = []

    /* ################################################################## */
    /**
     */
    mutating internal func parseCommand() {
        if nil != parsedData,
            !parsedData.isEmpty {
            
        }
    }
    
    /* ################################################################## */
    /**
     Initializer, with most fields optional.
     
     - parameters:
        - device: Required. The device that is running the transaction. It can be nil for testing purposes, but should not be nil, otherwise.
        - rawCommand: Required. This is the raw String value of the command being sent (it may be a format string).
        - completeCommand: Required. This is the command, filled out (it may be the same as the rawCommand, but a format will have values substituted).
        - responseData: Optional. This is any data that was returned from the OBD adapter.
        - responseDataAsString: Optional. If the command can be represented as a String, that is set here.
        - error: Optional. Any error that may have occurred.
     */
    public init(device inDevice: RVS_BTDriver_OBD_DeviceProtocol!, rawCommand inRawCommand: String, completeCommand inCompleteCommand: String, responseData inResponseData: Data! = nil, responseDataAsString inResponseDataAsString: String! = nil, error inError: RVS_BTDriver.Errors! = nil) {
        precondition((nil != inDevice) || RVS_DebugTools.isRunningUnitTests, "The device cannot be nil!")
        precondition(!inRawCommand.isEmpty, "The raw command cannot be empty.")
        precondition(!inCompleteCommand.isEmpty, "The complete command cannot be empty.")
        device = inDevice
        rawCommand = inRawCommand
        completeCommand = inCompleteCommand
        responseData = inResponseData
        error = inError
        parsedData = inResponseDataAsString
    }
    
    /* ################################################################## */
    /**
     Readable text description.
     */
    public var description: String {
        var ret = "Transaction:"
        
        if let device = device {
            ret += "\n\tDevice: \(String(describing: device))"
        }
        
        if let rawCommand = rawCommand {
            ret += "\n\tRaw Command: \"\(rawCommand)\""
        }
        
        if let completeCommand = completeCommand {
            ret += "\n\tComplete Command: \"\(completeCommand)\""
        }
        
        if  let responseData = responseData,
            let stringResponse = String(data: responseData, encoding: .ascii) {
            ret += "\n\tResponse: \"\(stringResponse)\""
        }
        
        if  let responseDataAsString = parsedData {
            ret += "\n\tResponse As A String: \"\(responseDataAsString)\""
        }
        
        if let error = error {
            ret += "\n\tError: \(String(describing: error))"
        }
        
        return ret + "\n"
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_DeviceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This protocol is for delegates for OBD devices.
 */
public protocol RVS_BTDriver_OBD_DeviceDelegate: class {
    /* ################################################################## */
    /**
     REQUIRED: Error reporting method.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func device(_ device: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError: RVS_BTDriver.Errors)
    
    /* ################################################################## */
    /**
     REQUIRED: This is called when an OBD device updates its transaction.
     
     - parameter updatedTransaction: The transaction that was updated.
     */
    func deviceUpdatedTransaction(_ updatedTransaction: RVS_BTDriver_OBD_Device_TransactionStruct)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_DeviceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_OBD_DeviceProtocol: RVS_BTDriver_DeviceProtocol {
    /* ################################################################## */
    /**
     This will be a weak reference to the instance delegate.
     */
    var delegate: RVS_BTDriver_OBD_DeviceDelegate! {get set }
    
    /* ################################################################## */
    /**
     This property is one that the OBD unit uses to return responses to the driver.
     */
    var readProperty: RVS_BTDriver_PropertyProtocol! { get }
    
    /* ################################################################## */
    /**
     This property is one that the driver uses to send commands to the OBD unit.
     */
    var writeProperty: RVS_BTDriver_PropertyProtocol! { get }

    /* ################################################################## */
    /**
     REQUIRED: This method will send an AT command to the OBD unit. Responses will arrive in the readProperty.
     
     - parameter commandString: The String for the command.
     - parameter rawCommand: The command String, without data or the appended CRLF.
     */
    func sendCommand(_ commandString: String, rawCommand: String)
    
    /* ################################################################## */
    /**
     REQUIRED: This cancels all I/O, and flushes the transaction queue.
     */
    func cancelTransactions()
}
