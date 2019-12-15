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
class RVS_BTDriver_Vendor_GenericBLE: NSObject, RVS_BTDriver_VendorProtocol {    
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        case userDefinedService =   "FFF0"
    }
    
    /* ################################################################## */
    /**
     This is the data we need to match against the advertisement data.
     */
    private let _manufacturerCode: [UInt8] = [0xfe, 0xff, 0x02]
    
    /* ################################################################## */
    /**
     Read-only accessor for the interface. This is a weak reference.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface()` has not yet been called.
     */
    internal weak var interface: RVS_BTDriver_InterfaceProtocol!

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
     This returns a list of BLE CBUUIDs, which the vendor wants us to filter for.
     */
    var searchForTheseServices: [CBUUID] {
        return []
    }

    /* ################################################################## */
    /**
     Factory for creating (or referencing) the appropriate interface instance.
     
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    internal func makeInterface(queue inQueue: DispatchQueue!) {
        #if DEBUG
            print("Making Generic BLE interface.")
        #endif
        interface = RVS_BTDriver_Interface_BLE.makeInterface(queue: inQueue)
        interface.driver = driver   // Who's your daddy?
        interface.rememberAdvertisedDevices = driver.internal_AllowDuplicatesInBLEScan  // This means that if a device is deleted while in scanning mode, and it will be found again.
        // If we are already on the guest list, then there's no need to add ourselves.
        for vendor in interface.vendors where type(of: vendor) == type(of: self) {
            #if DEBUG
                print("Generic interface already loaded.")
            #endif
            return
        }
        
        interface.vendors.append(self)
    }

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     internal func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if  let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            let ret = RVS_BTDriver_Device_GenericBLE(vendor: self)
            
            ret.deviceInfoStruct = deviceRecord

            deviceRecord.peripheral.delegate = ret

            return ret
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of a service.
     
     - parameter inServiceRecord: The Bluetooth info for the service, the vendor should cast this to its service info. This can be nil. If so, then the method should return nil.
     - returns: a service instance. Can be nil, if the vendor can't instantiate the service.
     */
    internal func makeService(_ inServiceRecord: CBService?, forDevice inDeviceRecord: RVS_BTDriver_Device) -> RVS_BTDriver_Service! {
        if let service = inServiceRecord {
            let ret = RVS_BTDriver_Service_BLE(owner: inDeviceRecord, uuid: service.uuid.uuidString)
            ret.cbService = inServiceRecord
            
            return ret
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a test, to see if this vendor is the appropriate one to handle a given device.
     
     - parameter inDevice: The device we're testing for ownership.
     
     - returns: always false, for this base class.
     */
    internal func iOwnThisDevice(_ inDevice: RVS_BTDriver_Device_BLE) -> Bool {
        return false
    }
    
    /* ################################################################## */
    /**
     The default initializer.
     
     - parameter driver: The `RVS_BTDriver` instance that "owns" this instance.
     */
    internal init(driver inDriver: RVS_BTDriver) {
        super.init()
        internal_driver = inDriver
        makeInterface(queue: inDriver.internal_queue)
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for Generic BLE Devices.
 */
class RVS_BTDriver_Device_GenericBLE: RVS_BTDriver_Device_BLE {
    /* ################################################################## */
    /**
     This is a String, containing a unique ID for this peripheral.
     */
    public override var uuid: String! {
        get {
            return peripheral.identifier.uuidString
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property!")
        }
    }
}
