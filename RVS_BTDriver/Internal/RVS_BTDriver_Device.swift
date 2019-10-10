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
// MARK: - RVS_BTDriver_Device -
/* ###################################################################################################################################### */
/**
 This is one "device," which maps to a bluetooth "peripheral."
 
 Must derive from NSObject, for purposes of being a delegate.
 */
class RVS_BTDriver_Device: NSObject, RVS_BTDriver_DeviceProtocol {
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_Device Sequence-Style Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains instances that have not yet passed a credit check.
     */
    private var _holding_pen: [RVS_BTDriver_Service] = []
    
    /* ################################################################## */
    /**
     This contains the service list for this instance of the driver.
     */
    private var _service_list: [RVS_BTDriver_Service] = []
    
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns," this instance.
     */
    internal var internal_owner: RVS_BTDriver!

    /* ################################################################## */
    /**
     This is a read-write accessor for the delegate for this device. It is a weak reference.
     */
    public var delegate: RVS_BTDriver_DeviceDelegate!
    
    /* ################################################################## */
    /**
     The interface for this device
     */
    internal var interface: RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     The vendor handler for this device
     */
    internal var vendor: RVS_BTDriver_VendorProtocol!
    
    /* ################################################################## */
    /**
     The device initializer
     
     - parameter vendor: The vendor factory for the device.
     */
    internal init(vendor inVendor: RVS_BTDriver_VendorProtocol) {
        vendor = inVendor
    }
    
    internal func connect() { }
}

/* ###################################################################################################################################### */
// MARK: - Communicator Support -
/* ###################################################################################################################################### */
/**
 We establish a communicator chain, here.
 */
extension RVS_BTDriver_Device: RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    public func reportThisError(_ inError: RVS_BTDriver.Errors) {
        if let delegate = delegate {    // We test, to make sure that we have a delegate. If so, we send the error thataways.
            #if DEBUG
                print("Error Message Being Sent to Device Delegate: \(inError.localizedDescription)")
            #endif
            delegate.device(self, encounteredThisError: inError)
        } else {    // Otherwise, we send it to the driver, for reporting there.
            internal_owner?.reportThisError(inError)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence-Style Support -
/* ###################################################################################################################################### */
/**
 Because of the requirement for either: A) iOS 13 or greater, or B) no associated type, we can't have a true Sequence support (we're relying on protocol masking), so we do this.
 */
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     This is the public read-only access to the service list.
     */
    public var services: [RVS_BTDriver_ServiceProtocol] {
        return _service_list
    }
    
    /* ################################################################## */
    /**
     This is the read-only count of services.
     */
    public var count: Int {
        return _service_list.count
    }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the service list.
     */
    public subscript(_ inIndex: Int) -> RVS_BTDriver_ServiceProtocol {
        precondition((0..<count).contains(inIndex), "Index Out of Range")
        return services[inIndex]
    }
}
