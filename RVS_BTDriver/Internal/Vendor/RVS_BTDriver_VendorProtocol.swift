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
import CoreBluetooth

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_VendorProtocol Protocol -
/* ###################################################################################################################################### */
/**
 A base protocol for vendors.
 */
internal protocol RVS_BTDriver_VendorProtocol {
    /* ################################################################## */
    /**
     A reference to the main driver instance.
     */
    var driver: RVS_BTDriver! { get }
    
    /* ################################################################## */
    /**
     This returns a list of BLE CBUUIDs, which the vendor wants us to filter for.
     */
    var searchForTheseServices: [CBUUID] { get }

    /* ################################################################## */
    /**
     Read-only accessor for the interface.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface()` has not yet been called.
     */
    var interface: RVS_BTDriver_InterfaceProtocol! { get }
    
    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
     - parameter inDeviceRecord: The Bluetooth info for the device, the vendor should cast this to its device info. This can be nil. If so, then the method should return nil.
     - returns: a device instance. Can be nil, if the vendor can't instantiate the device.
     */
    func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device!
    
    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of a service.
     
     - parameter inServiceRecord: The Bluetooth info for the service, the vendor should cast this to its service info. This can be nil. If so, then the method should return nil.
     - parameter forDevice: The device that "owns" this service.
     - returns: a service instance. Can be nil, if the vendor can't instantiate the service.
     */
    func makeService(_ inServiceRecord: CBService?, forDevice inDeviceRecord: RVS_BTDriver_Device) -> RVS_BTDriver_Service!
    
    /* ################################################################## */
    /**
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    func makeInterface(queue: DispatchQueue!)
    
    /* ################################################################## */
    /**
     This is a test, to see if this vendor is the appropriate one to handle a given device.
     
     - parameter device: The device we're testing for ownership.
     
     - returns: true, if this vendor "owns" this device (is the vendor that should handle it).
     */
    func iOwnThisDevice(_ device: RVS_BTDriver_Device_BLE) -> Bool
}
