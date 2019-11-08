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
class RVS_BTDriver_Vendor_Beartooth: NSObject, RVS_BTDriver_VendorProtocol {
    /* ################################################################## */
    /**
     */
    var driver: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     */
    var interface: RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     */
    var serviceSignatures: [String] = []

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        return nil
    }

    /* ################################################################## */
    /**
     Factory for creating (or referencing) the appropriate interface instance.
     
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    internal func makeInterface(queue inQueue: DispatchQueue!) {
        interface = RVS_BTDriver_Interface_BT_Classic.makeInterface(queue: inQueue)
        interface.driver = driver   // Who's your daddy?
        // Scan for our devices. Don't bother adding if we are already there.
        for serviceSignature in serviceSignatures where !interface.serviceSignatures.contains(serviceSignature) {
            interface.serviceSignatures.append(serviceSignature)
        }
        
        // If we are already on the guest list, then there's no need to add ourselves.
        for vendor in interface.vendors where type(of: vendor) == type(of: self) {
            return
        }
        
        interface.vendors.append(self)
    }

    internal init(driver inDriver: RVS_BTDriver) {
        driver = inDriver
    }
}
