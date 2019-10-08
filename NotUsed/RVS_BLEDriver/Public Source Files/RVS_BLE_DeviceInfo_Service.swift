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
// MARK: - Service Class for Device Info Service -
/* ###################################################################################################################################### */
/**
 This class implements a BLE service wrapper, specialized for the Device Info standard service.
 */
public class RVS_BLE_DeviceInfo_Service: RVS_BLEService {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Standard BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    public enum RVS_BLE_GATT_UUID: String, RawRepresentable {
        // MARK: - Service IDs
        /// The standard GATT Device Info service.
        case deviceInfoService              =   "180A"
        
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

    /* ################################################################################################################################## */
    // MARK: - RVS_BLEDriver_ServiceProtocol Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     - returns: The service UUID.
     */
    public static var serviceID: String {
        return RVS_BLE_GATT_UUID.deviceInfoService.rawValue
    }
}

/* ###################################################################################################################################### */
// MARK: - Extension -
/* ###################################################################################################################################### */
extension RVS_BLE_DeviceInfo_Service {
    /* ################################################################## */
    /**
     - returns: The manufacturer name (if any). If none, an empty String is returned.
     */
    public var manufacturerNameString: String {
        if  let value = self[RVS_BLE_GATT_UUID.deviceInfoManufacturerName.rawValue],
            case let RVS_BLEDriver_ValueProtocol_Type_Enum.stringValue(inValueString) = value.value {
            return inValueString ?? ""
        }
        return ""
    }
    
    /* ################################################################## */
    /**
     - returns: The model name (if any). If none, an empty String is returned.
     */
    public var modelNameString: String {
        if  let value = self[RVS_BLE_GATT_UUID.deviceInfoModelName.rawValue],
            case let RVS_BLEDriver_ValueProtocol_Type_Enum.stringValue(inValueString) = value.value {
            return inValueString ?? ""
        }
        return ""
    }
    
    /* ################################################################## */
    /**
     - returns: The hardware revision (if any). If none, an empty String is returned.
     */
    public var hardwareRevisionString: String {
        if  let value = self[RVS_BLE_GATT_UUID.deviceInfoHardwareRevision.rawValue],
            case let RVS_BLEDriver_ValueProtocol_Type_Enum.stringValue(inValueString) = value.value {
            return inValueString ?? ""
        }
        return ""
    }
    
    /* ################################################################## */
    /**
     - returns: The firmware revision (if any). If none, an empty String is returned.
     */
    public var firmwareRevisionString: String {
        if  let value = self[RVS_BLE_GATT_UUID.deviceInfoFirmwareRevision.rawValue],
            case let RVS_BLEDriver_ValueProtocol_Type_Enum.stringValue(inValueString) = value.value {
            return inValueString ?? ""
        }
        return ""
    }
}
