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
// MARK: - The Main Driver Class -
/* ###################################################################################################################################### */
/**
 This is the main driver class. It is the "manager" for all the bluetooth-connected devices, which are accessible as `RVS_BTDriver_DeviceProtocol`-conformant instances.
 
 The `RVS_BTDriver` instance can be treated like a [Sequence](https://developer.apple.com/documentation/swift/sequence), with an iterator, higher-order functions and subscripting.
 
 Just remember that it aggregates a protocol, not a class/struct, so you see a "mask" over a different class that is known internally.
 */
public class RVS_BTDriver: NSObject {
    /* ################################################################## */
    /**
     This contains the device list for this instance of the driver.
     */
    private var _device_list: [RVS_BTDriver_Device] = []
    
    /* ################################################################## */
    /**
     This contains instances that have not yet passed a credit check.
     */
    internal var internal_holding_pen: [RVS_BTDriver_Device] = [] {
        didSet {
            triageHoldingPen()
        }
    }
    
    /* ################################################################## */
    /**
     This contains any queue we're supposed to use. Nil (default) is the main queue.
     */
    internal var internal_queue: DispatchQueue!

    /* ################################################################## */
    /**
     The delegate. It is a weak reference.
     */
    internal weak var internal_delegate: RVS_BTDriverDelegate!
    
    /* ################################################################## */
    /**
     This will contain our vendor factory instances. This is loaded at instantiation time.
     */
    internal var vendors: [RVS_BTDriver_VendorProtocol] = []

    /* ################################################################## */
    /**
     We declare a blank init as private, so it can't be called outside this file.
     */
    override private init() {
        super.init()
    }
    
    /* ################################################################## */
    /**
     An internal convenience initializer (meant to be called from the public convenience init).
     
     - parameter inDelegate: The delegate instance. It is required, and cannot be nil.
     - parameter queue: The queue we want to use. Default is nil (optional). Nil means use the main thread.
     */
    internal convenience init(_ inDelegate: RVS_BTDriverDelegate, queue inQueue: DispatchQueue! = nil) {
        self.init()
        internal_delegate = inDelegate
        internal_queue = inQueue
        // We initialize with our vendors, which will also allow us to create any required interfaces.
        vendors = [
            RVS_BTDriver_Vendor_GoTenna_Mesh(driver: self)
        ]
    }
    
    /* ################################################################## */
    /**
     This method runs through our "holding pen," and will start device on their initialization (if not started), or move them to the completed queue, if they are done.
     */
    internal func triageHoldingPen() {
        internal_holding_pen.forEach {
            if  let deviceAsStateMachine = $0 as? RVS_BTDriver_State_Machine,
                .uninitialized == deviceAsStateMachine.state {
                #if DEBUG
                    print("Starting initialization of a device in the holding pen: \(String(describing: $0))")
                #endif
                deviceAsStateMachine.startInit()
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Calls from the field Support -
/* ###################################################################################################################################### */
/**
 Handles calls from the device interfaces.
 */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     */
    internal func addDiscoveredDevice(_ inDevice: RVS_BTDriver_Device) {
        #if DEBUG
            print("Adding a new device to the holding pen: \(String(describing: inDevice))")
        #endif
        internal_holding_pen.append(inDevice)
    }
}

/* ###################################################################################################################################### */
// MARK: - Communicator Support -
/* ###################################################################################################################################### */
/**
 We establish a communicator chain, here.
 */
extension RVS_BTDriver: RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     The buck stops here.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_BTDriver.Errors) {
        if let delegate = delegate {    // We test, to make sure that we have a delegate. If so, we send the error thataways.
            #if DEBUG
                print("Error Message Being Sent to Driver Delegate: \(inError.localizedDescription)")
            #endif
            delegate.btDriver(self, encounteredThisError: inError)
        } else {    // That's a Bozo No-No. I considered putting a precondition crash here, but that would be like kicking a sick kitten.
            assert(false, "BAD NEWS! Error Message Ignored: \(inError.localizedDescription)")
        }
    }
    
    /* ################################################################## */
    /**
     This method will send the driver delegate an update event, on behalf of a interface.
     
     - parameter inInterface: The interface that wants to send an update.
     */
    func sendInterfaceUpdate(_ inInterface: RVS_BTDriver_InterfaceProtocol) {
        delegate?.btDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     This method will send the driver delegate an update event, on behalf of a device.
     
     - parameter inDevice: The device that wants to send an update.
     */
    func sendDeviceUpdate(_ inDevice: RVS_BTDriver_Device) {
        delegate?.btDriverStatusUpdate(self)
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver Sequence Support -
/* ###################################################################################################################################### */
/**
 This sets up the Sequence protocol.
 */
extension RVS_BTDriver: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     We aggregate devices.
     */
    public typealias Element = RVS_BTDriver_DeviceProtocol
    
    /* ################################################################## */
    /**
     This is a public read-only list of devices, masked by the protocol.
     */
    public var sequence_contents: [Element] {
        get {
            return _device_list
        }
        
        /// We do not allow the list to be modified from outside the driver.
        set {
            _ = newValue    // Just to shut up SwiftLint.
            preconditionFailure("Value is Read-Only.")
        }
    }
}
