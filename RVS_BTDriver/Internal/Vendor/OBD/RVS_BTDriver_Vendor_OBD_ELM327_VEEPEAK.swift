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
 A factory class for OBD dongles, based on the VEEPEAK version of the ELM327 chipset.
 */
class RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK: RVS_BTDriver_Vendor_OBD_ELM327 {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID                           =   "VEEPEAK"
        
        /// It advertises this service.
        case advertisedService                          =   "FFF0"
        /// This is a read/notify property for communicating with a MHCP-based chipset
        case MHCPAdvertisedServiceReadNotifyProperty    =   "FFF1"
        /// This is a write-only property for communicating with a MHCP-based chipset
        case MHCPAdvertisedServiceWriteProperty         =   "FFF2"

        /// This is the read/write service used by MHCP-based chipsets.
        case MHCPUserDefinedService                     =   "49535343-FE7D-4AE5-8FA9-9FAFD205E455"
        /// This is a read/write property for communicating with a MHCP-based chipset
        case MHCPUserDefinedServiceReadWriteProperty    =   "49535343-6DAA-4D02-ABF6-19569ACA69FE"
        /// This is a write-only property for communicating with a MHCP-based chipset
        case MHCPUserDefinedServiceWriteNotifyProperty  =   "49535343-ACA3-481C-91EC-D85E28A60318"
    }
    
    /* ################################################################## */
    /**
     This returns a list of BLE CBUUIDs, which the vendor wants us to filter for.
     */
    override var searchForTheseServices: [CBUUID] {
        return [CBUUID(string: RVS_BLE_GATT_UUID.advertisedService.rawValue)]
    }

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     internal override func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if  let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            let ret = RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK_Device(vendor: self)
            
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
        if let device = inDevice as? RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK_Device {
            let myService = RVS_BLE_GATT_UUID.advertisedService.rawValue
            for service in device.services where .unTested == device.deviceType && myService == service.uuid {
                if  let service = service as? RVS_BTDriver_Service_BLE,
                    let readProperty = service.propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.MHCPAdvertisedServiceReadNotifyProperty.rawValue),
                    let writeNotifyProperty = service.propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.MHCPAdvertisedServiceWriteProperty.rawValue) {
                    device.deviceType = .OBD(type: .elm327(model: RVS_BLE_GATT_UUID.deviceSpecificID.rawValue))
                    device.readProperty = readProperty
                    device.writeProperty = writeNotifyProperty
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
        return super.description + "-" + RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD Devices.
 */
class RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK_Device: RVS_BTDriver_Device_OBD_ELM327 {
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD_ELM327_VEEPEAK.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}
