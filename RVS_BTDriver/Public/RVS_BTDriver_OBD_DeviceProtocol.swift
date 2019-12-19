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
     REQUIRED: This is called when an OBD device responds with data.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter returnedThisData: The data returned. It may be nil.
     */
    func device(_ device: RVS_BTDriver_OBD_DeviceProtocol, returnedThisData: Data?)
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
     This property is one that the driver uses to send commands to the OBD unit.
     */
    var writeProperty: RVS_BTDriver_PropertyProtocol! { get }
    
    /* ################################################################## */
    /**
     This menthod will send an AT command to the OBD unit. Responses will arrive in the readProperty.
     
     - parameter commandString: The Sting for the command.
     */
    func sendCommandWithResponse(_ commandString: String)
}
