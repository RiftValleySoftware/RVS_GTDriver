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
// MARK: - RVS_BTDriver_VendorProtocol Protocol -
/* ###################################################################################################################################### */
/**
 */
internal protocol RVS_BTDriver_VendorProtocol {
    /* ################################################################## */
    /**
     A reference to the main driver instance.
     */
    var driver: RVS_BTDriver! { get }
    
    /* ################################################################## */
    /**
     These are the services that we scan for.
     */
    var serviceSignatures: [String] { get }

    /* ################################################################## */
    /**
     Read-only accessor for the interface.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface()` has not yet been called.
     */
    var interface: RVS_BTDriver_InterfaceProtocol! { get }

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
     - parameter inDeviceRecord: A typeless instance that contains the Bluetooth info for the device. It is the responsibility of the vendor to cast this.
     - returns: a device instance. Can be nil, if the vendor can't instantiate the device.
     */
    func makeDevice(_ inDeviceRecord: Any) -> RVS_BTDriver_Device!
    
    /* ################################################################## */
    /**
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    func makeInterface(queue: DispatchQueue!)
}
