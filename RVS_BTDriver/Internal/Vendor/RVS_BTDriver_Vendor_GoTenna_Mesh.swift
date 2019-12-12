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
class RVS_BTDriver_Vendor_GoTenna_Mesh: RVS_BTDriver_Vendor_GenericBLE {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        // MARK: - Service IDs
        /// This is the basic goTenna proprietary service.
        case goTennaProprietary             =   "1276AAEE-DF5E-11E6-BF01-FE55135034F3"
        
        // MARK: - goTenna Proprietary Characteristic IDs
        /// No idea what this is.
        case goTennaProprietary001          =   "12762B18-DF5E-11E6-BF01-FE55135034F3"
        /// No idea what this is.
        case goTennaProprietary002          =   "1276B20A-DF5E-11E6-BF01-FE55135034F3"
        /// No idea what this is.
        case goTennaProprietary003          =   "1276B20B-DF5E-11E6-BF01-FE55135034F3"
    }
    
    /* ################################################################## */
    /**
     This is the data we need to match against the advertisement data.
     */
    private let _manufacturerCode: [UInt8] = [0xfe, 0xff, 0x02]

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     override internal func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if  let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            // We check to see if the peripheral is one of ours.
            if  let manufacturerCodeData = deviceRecord.advertisementData[CBAdvertisementDataManufacturerDataKey] as? NSData,
                _manufacturerCode.count == manufacturerCodeData.length {
                
                // We read in the manufacturer data, and match it against our own.
                var uIntArray = [UInt8](repeating: 0, count: _manufacturerCode.count)
                manufacturerCodeData.getBytes(&uIntArray, length: _manufacturerCode.count)
                
                if uIntArray == _manufacturerCode {
                    let ret = RVS_BTDriver_Device_GoTenna_Mesh(vendor: self)
                    
                    ret.deviceInfoStruct = deviceRecord

                    deviceRecord.peripheral.delegate = ret

                    return ret
                }
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a test, to see if this vendor is the appropriate one to handle a given device.
     
     - parameter inDevice: The device we're testing for ownership. It will have its device type set, if it is one of ours.
     
     - returns: true, if this vendor "owns" this device (is the vendor that should handle it).
     */
    override internal func iOwnThisDevice(_ inDevice: RVS_BTDriver_Device_BLE) -> Bool {
        let myService = RVS_BLE_GATT_UUID.goTennaProprietary.rawValue
        // Fairly basic. goTenna Mesh uses a proprietary UUID for a proprietary service.
        for service in inDevice.services where myService == service.uuid && .unTested == inDevice.deviceType {
            inDevice.deviceType = .goTennaMesh
            return true
        }
        
        return false
    }
}

/* ###################################################################################################################################### */
// MARK: - goTenna Mesh Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for the goTenna Mesh.
 */
class RVS_BTDriver_Device_GoTenna_Mesh: RVS_BTDriver_Device_BLE {
}
