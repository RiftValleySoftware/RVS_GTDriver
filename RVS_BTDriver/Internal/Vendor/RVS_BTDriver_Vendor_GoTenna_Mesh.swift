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

import CoreBluetooth

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Vendor_GoTenna -
/* ###################################################################################################################################### */
/**
 A factory class for goTenna Mesh devices
 */
class RVS_BTDriver_Vendor_GoTenna_Mesh: NSObject, RVS_BTDriver_VendorProtocol {
    /* ################################################################## */
    /**
     A weak reference to the main driver instance.
     */
    internal weak var internal_driver: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     A read-only accessor to the main driver instance.
     */
    internal var driver: RVS_BTDriver! {
        return internal_driver
    }

    /* ################################################################## */
    /**
     Read-only accessor for the interface. This is a weak reference.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface()` has not yet been called.
     */
    internal weak var interface: RVS_BTDriver_InterfaceProtocol!

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of th vendor device.
     
     - returns: a device instance.
     */
    func makeDevice() -> RVS_BTDriver_Device {
        return RVS_BTDriver_Device_GoTenna_Mesh(vendor: self)
    }

    /* ################################################################## */
    /**
     Factory for creating (or referencing) the appropriate interface instance.
     
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    internal func makeInterface(queue inQueue: DispatchQueue!) {
        interface = RVS_BTDriver_Interface_BLE.makeInterface(queue: inQueue)
        interface.driver = driver   // Who's your daddy?
    }
    
    /* ################################################################## */
    /**
     The default initializer.
     
     - parameter driver: The `RVS_BTDriver` instance that "owns" this instance.
     */
    init(driver inDriver: RVS_BTDriver) {
        super.init()
        internal_driver = inDriver
        makeInterface(queue: inDriver.internal_queue)
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Device_GoTenna_Mesh -
/* ###################################################################################################################################### */
/**
 This is a class that implements a goTenna Mesh device instance.
 */
class RVS_BTDriver_Device_GoTenna_Mesh: RVS_BTDriver_Device {
    /// The peripheral instance associated with this device.
    var peripheral: CBPeripheral!
}
