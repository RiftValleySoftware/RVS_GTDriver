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
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains the device list for this instance of the driver.
     */
    private var _device_list: [RVS_BTDriver_Device] = []
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.
     If true, it could adversely affect battery life. Default is false.
     */
    internal var internal_AllowDuplicatesInBLEScan: Bool = false
    
    /* ################################################################## */
    /**
     This is a flag that tells us to remain connected continuously, until explicitly disconnected by the user. Default is false.
     */
    internal var internal_stayConnected: Bool = false
    
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
    internal weak var internal_queue: DispatchQueue!

    /* ################################################################## */
    /**
     The delegate. It is a weak reference.
     */
    internal weak var internal_delegate: RVS_BTDriverDelegate!
    
    /* ################################################################## */
    /**
     This will contain our vendor factory instances. This is loaded at instantiation time.
     */
    internal var internal_vendors: [RVS_BTDriver_VendorProtocol] = []
    
    /* ################################################################################################################################## */
    // MARK: - Internal Ininitailzer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The main internal initializer.
     
     - parameter inDelegate: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
     - parameter vendors: This is an Array of vendor enums, and is used to determine which vendors will be loaded.
     - parameter queue: This is a desired queue for the CB manager to operate from. It is optional, and default is nil (main queue).
     - parameter allowDuplicatesInBLEScan:  This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.
                                            If true, it could adversely affect battery life. Default is false.
     - parameter stayConnected: This is set to true, if you want all your device connections to be persistent. That is, once connected, they must be explicitly disconencted by the user.
                                Otherwise, each device will be connected only while interacting.
                                This is optional. Default is false.
     */
    internal init(_ inDelegate: RVS_BTDriverDelegate, vendors inVendors: [RVS_BTDriver_VendorTypes] = [], queue inQueue: DispatchQueue? = nil, allowDuplicatesInBLEScan inAllowDuplicatesInBLEScan: Bool = false, stayConnected inStayConnected: Bool = false) {
        super.init()
        internal_AllowDuplicatesInBLEScan = inAllowDuplicatesInBLEScan
        internal_stayConnected = inStayConnected
        internal_delegate = inDelegate
        internal_queue = inQueue
        internal_vendors = []
        
        internal_vendors.append(RVS_BTDriver_Vendor_GenericBLE(driver: self))

        if inVendors.isEmpty || inVendors.contains(.goTenna) {
            internal_vendors.append(RVS_BTDriver_Vendor_GoTenna_Mesh(driver: self))
        }
        
        if inVendors.isEmpty || inVendors.contains(.OBD) {
            internal_vendors.append(RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK(driver: self))
            internal_vendors.append(RVS_BTDriver_Vendor_OBD_ELM327_VLINK(driver: self))
            internal_vendors.append(RVS_BTDriver_Vendor_OBD_ELM327_ANON_1(driver: self))
            internal_vendors.append(RVS_BTDriver_Vendor_OBD_Kiwi(driver: self))
        }
    }

    /* ################################################################## */
    /**
     Make sure that everything is put back the way we found it...
     */
    deinit {
        stopScanning()
    }
    
    /* ################################################################## */
    /**
     This is here to satisfy the sequence protocol. It should not be called.
     
     - parameter sequence_contents: Ignored
     */
    public required init(sequence_contents inSequence_contents: [RVS_BTDriver_DeviceProtocol]) {
        preconditionFailure("This Method Cannot Be Used.")
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     This method will find a device in the holding pen, and replace it with a new device.
     
     - parameter inDevice: The device object to be replaced.
     - parameter withThisDevice: The device to be used as a replacement.
     */
    internal func replaceThisDeviceInTheHoldingPen(_ inDevice: RVS_BTDriver_Device, withThisDevice inReplacementDevice: RVS_BTDriver_Device) {
        if let index = internal_holding_pen.firstIndex(where: { (dev) -> Bool in
            return dev === inDevice
            }) {
            _ = internal_holding_pen[index]
            internal_holding_pen[index] = inReplacementDevice
            #if DEBUG
                print("The Holding Pen device: \(inDevice) at Index \(index) was replaced by a new device: \(inReplacementDevice).")
            #endif
        } else {
            #if DEBUG
                print("The device provided: \(inDevice) was not found in the holding pen. No replacement was made.")
            #endif
        }
    }
    
    /* ################################################################## */
    /**
     This method will move a device from the holding pen to the main list.
     
     - parameter inDevice: The device object to be moved.
     */
    internal func moveDeviceFromHoldingPenToMainList(_ inDevice: RVS_BTDriver_Device) {
        if var testDevice = inDevice  as? RVS_BTDriver_Device_BLE {
            for device in internal_holding_pen where device === testDevice {
                var workingDevice: RVS_BTDriver_Device!  // This allows us to replace the device with a more specialized one.
                if  let index = internal_holding_pen.firstIndex(where: { $0 === testDevice }) {
                    // If the device is one that is handled exclusivley
                    workingDevice = nil
                    
                    // We start at 1, because we don't want to check the generic BLE vendor.
                    for vendorIndex in 1..<internal_vendors.count {
                        // Each vendor gets a crack at creating a specialized variant of the device.
                        let vendor = internal_vendors[vendorIndex]
                        // If the vendor successfully creates a variant, we transfer over the services, and replace our holding pen generic instance with the new one.
                        if  let device = device as? RVS_BTDriver_Device_BLE,    // Has to be a BLE device
                            .unTested == device.deviceType,                     // Has to be untested (no specific device assigned).
                            let tempWorkingDevice = vendor.makeDevice(device.deviceInfoStruct) as? RVS_BTDriver_Device_BLE {    // Try creating the specialized instance.
                            tempWorkingDevice.internal_service_list = device.internal_service_list   // Make sure that we copy our completed services and properties.
                            tempWorkingDevice.internal_service_list.forEach {
                                $0.internal_owner = tempWorkingDevice
                            }
                            tempWorkingDevice.isConnected = device.isConnected
                            tempWorkingDevice.internal_owner = self
                            if vendor.iOwnThisDevice(tempWorkingDevice) {   // This is a final test, and the device type is assigned.
                                replaceThisDeviceInTheHoldingPen(device, withThisDevice: tempWorkingDevice)
                                workingDevice = tempWorkingDevice
                                testDevice = tempWorkingDevice
                                break
                            }
                        }
                    }
                
                    #if DEBUG
                        print("Removing Device at Index \(index) of the Holding Pen.")
                    #endif
                    
                    internal_holding_pen.remove(at: index)
                    
                    if nil != workingDevice {
                        #if DEBUG
                            print("Adding the device to the main list at index \(_device_list.count).")
                        #endif
                        _device_list.append(workingDevice)
                        // If we have a delegate, we send it a notification that a device was added.
                        delegate?.btDriver(self, newDeviceAdded: workingDevice)
                        #if DEBUG
                            print("The new device: \(String(describing: workingDevice))")
                        #endif
                        workingDevice.initialSetup()
                    }
                }
            }
            
            if internal_holding_pen.isEmpty {
                #if DEBUG
                    print("All Devices Discovered.")
                #endif
                reportCompletion()
            }
        }
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

    /* ################################################################## */
    /**
     This method will remove a device from the holding pen or the main list.
     
     - parameter inDevice: The device object to be removed.
     */
    internal func removeThisDevice(_ inDevice: RVS_BTDriver_Device) {
        for device in internal_holding_pen where device === inDevice {
            if let index = internal_holding_pen.firstIndex(where: { (dev) -> Bool in
                return dev === inDevice
                }) {
                
                #if DEBUG
                    print("Removing Device at Index \(index) of the Holding Pen.")
                #endif
                internal_holding_pen.remove(at: index)
                return
            }
        }
        
        // If we found it in the holding pen, this should not happen, but better safe than sorry...
        for device in _device_list where device === inDevice {
            if let index = _device_list.firstIndex(where: { (dev) -> Bool in
                return dev === inDevice
                }) {
                
                #if DEBUG
                    print("Removing Device at Index \(index) of the Main List.")
                #endif
                _device_list.remove(at: index)
            }
        }
    }
    
    /* ################################################################## */
    /**
     Called to report that our holding pen is empty.
     */
    internal func reportCompletion() {
        #if DEBUG
            print("The driver is done with its initialization.")
        #endif
        // Send a simple status update to the delegate.
        delegate?.btDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     See if the given device is still in the holding pen.
     
     - parameter: The device we're looking to see if it is in the Array.
     - returns: True, if the device is still in the holding pen.
     */
    internal func deviceIsInHoldingPen(_ inDevice: RVS_BTDriver_Device) -> Bool {
        return internal_holding_pen.contains(inDevice)
    }
    
    /* ################################################################## */
    /**
     See if the given device is done with initialization, and is in the main list.
     
     - parameter: The device we're looking to see if it is in the Array.
     - returns: True, if the device is in the main list.
     */
    internal func deviceIsInMainList(_ inDevice: RVS_BTDriver_Device) -> Bool {
        return _device_list.contains(inDevice)
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
        inDevice.internal_owner = self
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
    internal func sendInterfaceUpdate(_ inInterface: RVS_BTDriver_InterfaceProtocol) {
        delegate?.btDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     This method will send the driver delegate an update event, on behalf of a device.
     
     - parameter inDevice: The device that wants to send an update.
     */
    internal func sendDeviceUpdate(_ inDevice: RVS_BTDriver_Device) {
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
