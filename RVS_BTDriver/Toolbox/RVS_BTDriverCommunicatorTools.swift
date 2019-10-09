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
// MARK: - RVS_BTDriverCommunicatorTools Protocol -
/* ###################################################################################################################################### */
/**
 This protocol allows aggregated instances to report stuff through the main driver, without breaking the fourth wall.
 */
internal protocol RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     This is required.
     
     - parameter error: The error to be sent to the delegate.
     */
    func reportThisError(_ error: RVS_BTDriver.Errors)
    
    /* ################################################################## */
    /**
     This method will send the driver delegate an update event, on behalf of a interface.
     This is optional.

     - parameter interface: The interface that wants to send an update.
     */
    func sendInterfaceUpdate(_ interface: RVS_BTDriver_InterfaceProtocol)
    
    /* ################################################################## */
    /**
     This method will send the driver delegate an update event, on behalf of a device.
     This is optional.
     
     - parameter device: The device that wants to send an update.
     */
    func sendDeviceUpdate(_ device: RVS_BTDriver_Device)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverCommunicatorTools Default Implementations -
/* ###################################################################################################################################### */
extension RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     The default implementation does nothing.
     */
    internal func sendInterfaceUpdate(_ interface: RVS_BTDriver_InterfaceProtocol) { }
    
    /* ################################################################## */
    /**
     The default implementation does nothing.
     */
    internal func sendDeviceUpdate(_ device: RVS_BTDriver_Device) { }
}
