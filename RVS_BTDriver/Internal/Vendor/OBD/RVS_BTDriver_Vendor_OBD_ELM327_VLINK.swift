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
 A factory class for OBD dongles, based on the VLINK version of the ELM327 chipset.
 */
class RVS_BTDriver_Vendor_OBD_ELM327_VLINK: RVS_BTDriver_Vendor_OBD_ELM327 {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID                           =   "VLINK"
        
        /// It advertises this property.
        case advertisedProperty                         =   "18F0"
        
        /// This is the communication service for FSC-ELM327 BLE devices.
        case vlinkUserDefinedService                    =   "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"
        /// This is the read/write property for communicating with VLink devices.
        case vlinkReadWriteProperty                     =   "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"
    }
    
    /* ################################################################## */
    /**
     This is the data we need to match against the advertisement data.
     */
    private let _manufacturerCode: [UInt8] = [0xfe, 0xff, 0x02]
    
    /* ################################################################## */
    /**
     This returns a list of BLE CBUUIDs, which the vendor wants us to filter for.
     */
    override var searchForTheseServices: [CBUUID] {
        return [CBUUID(string: RVS_BLE_GATT_UUID.advertisedProperty.rawValue)]
    }

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     internal override func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if  let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            let ret = RVS_BTDriver_Vendor_OBD_ELM327_VLINK_Device(vendor: self)
            
            ret.deviceInfoStruct = deviceRecord

            deviceRecord.peripheral.delegate = ret

            return ret
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a test, to see if this vendor is the appropriate one to handle a given device.
     
     - parameter inDevice: The device we're testing for ownership. It will have its device type set, if it is one of ours.
     
     - returns: true, if this vendor "owns" this device (is the vendor that should handle it).
     */
    internal override func iOwnThisDevice(_ inDevice: RVS_BTDriver_Device_BLE) -> Bool {
        if let device = inDevice as? RVS_BTDriver_Vendor_OBD_ELM327_VLINK_Device {
            let myService = RVS_BLE_GATT_UUID.vlinkUserDefinedService.rawValue
            for service in device.services where .unTested == device.deviceType && myService == service.uuid {
                if  let service = service as? RVS_BTDriver_Service_BLE,
                    let readWriteProperty = service.propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.vlinkReadWriteProperty.rawValue) {
                    device.deviceType = .OBD(type: .elm327(model: RVS_BLE_GATT_UUID.deviceSpecificID.rawValue))
                    device.readProperty = readWriteProperty
                    device.writeProperty = readWriteProperty
                    return true
                }
            }
        }
        
        return false
    }
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD Devices.
 */
class RVS_BTDriver_Vendor_OBD_ELM327_VLINK_Device: RVS_BTDriver_Device_OBD_ELM327 {
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD_ELM327_VLINK.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}
