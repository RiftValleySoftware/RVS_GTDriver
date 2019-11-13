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
 A factory class for Beartooth devices
 */
class RVS_BTDriver_Vendor_Beartooth: NSObject, RVS_BTDriver_VendorProtocol {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BT_Classic_GATT_UUID: String {
        // MARK: - Device Info Characteristic IDs
        /// Manufacturer Name
        case deviceInfoManufacturerName     =   "2A29"
        /// Model Name
        case deviceInfoModelName            =   "2A24"
        /// Hardware Revision
        case deviceInfoHardwareRevision     =   "2A27"
        /// Firmware Revision
        case deviceInfoFirmwareRevision     =   "2A26"
    }
    
    /* ################################################################## */
    /**
     This is the data we need to match against the advertisement data.
     */
    private let _manufacturerCode: [UInt8] = [0xfe, 0xff, 0x02]

    /* ################################################################## */
    /**
     The driver instance that "owns" this vendor instance.
     */
    var driver: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     The interface object that handles the Bluetooth connections.
     */
    var interface: RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     These are the services that we scan for.
     */
    var serviceSignatures: [String] {
        return [RVS_BTDriver_Base_Interface.RVS_GATT_UUID.deviceInfoService.rawValue]
    }

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if  let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            // We check to see if the peripheral is one of ours.
            if  let manufacturerCodeData = deviceRecord.advertisementData[CBAdvertisementDataManufacturerDataKey] as? NSData,
                _manufacturerCode.count == manufacturerCodeData.length {
                
                // We read in the manufacturer data, and match it against our own.
                var uIntArray = [UInt8](repeating: 0, count: _manufacturerCode.count)
                manufacturerCodeData.getBytes(&uIntArray, length: _manufacturerCode.count)
                
                if uIntArray == _manufacturerCode {
                    let ret = RVS_BTDriver_Device_Beartooth(vendor: self)
                    
                    ret.peripheral = deviceRecord.peripheral
                    ret.centralManager = deviceRecord.centralManager
                    
                    /// These are the services we search for, after connecting.
                    ret.internal_initalServiceDiscovery = [CBUUID(string: RVS_BTDriver_Base_Interface.RVS_GATT_UUID.deviceInfoService.rawValue)
                    ]

                    deviceRecord.peripheral.delegate = ret

                    return ret
                }
            }
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     Factory for creating (or referencing) the appropriate interface instance.
     
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    internal func makeInterface(queue inQueue: DispatchQueue!) {
        #if DEBUG
            print("Making Beartooth interface.")
        #endif
        interface = RVS_BTDriver_Interface_BT_Classic.makeInterface(queue: inQueue)
        interface.driver = driver   // Who's your daddy?
        // Scan for our devices. Don't bother adding if we are already there.
        for serviceSignature in serviceSignatures where !interface.serviceSignatures.contains(serviceSignature) {
            interface.serviceSignatures.append(serviceSignature)
        }
        
        // If we are already on the guest list, then there's no need to add ourselves.
        for vendor in interface.vendors where type(of: vendor) == type(of: self) {
            #if DEBUG
                print("Beartooth interface already loaded.")
            #endif
            return
        }
        
        interface.vendors.append(self)
    }

    /* ################################################################## */
    /**
     */
    internal init(driver inDriver: RVS_BTDriver) {
        super.init()
        driver = inDriver
        makeInterface(queue: inDriver.internal_queue)
    }
}

/* ###################################################################################################################################### */
// MARK: - Beartooth Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for the goTenna Mesh.
 */
class RVS_BTDriver_Device_Beartooth: RVS_BTDriver_Device_BT_Classic {
    /* ################################################################## */
    /**
     This is a String, containing a unique ID for this peripheral.
     */
    override public internal(set) var uuid: String! {
        get {
            return peripheral.identifier.uuidString
        }
        
        set {
            _ = newValue
        }
    }
}
