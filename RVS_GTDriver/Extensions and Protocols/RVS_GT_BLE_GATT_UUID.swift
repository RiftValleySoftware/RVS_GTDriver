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
// MARK: - Enums for Standard (and Proprietary) BLE Service and Characteristic UUIDs -
/* ###################################################################################################################################### */
/**
 These are String-based enums that we use to reference various services and characteristics in our driver.
 */
internal enum RVS_GT_BLE_GATT_UUID: String {
    // MARK: - Service IDs
    /// The standard GATT Device Info service.
    case deviceInfoService              =   "0x180A"
    /// This is the basic goTenna proprietary service.
    case goTennaProprietary             =   "1276AAEE-DF5E-11E6-BF01-FE55135034F3"
    
    // MARK: - Device Info Characteristic IDs
    /// Manufacturer Name
    case deviceInfoManufacturerName     =   "0x2A29"
    /// Model Name
    case deviceInfoModelName            =   "0x2A24"
    /// Hardware Revision
    case deviceInfoHardwareRevision     =   "0x2A27"
    /// Firmware Revision
    case deviceInfoFirmwareRevision     =   "0x2A26"
    
    // MARK: - goTenna Proprietary Characteristic IDs
    case goTennaProprietary001          =   "12762B18-DF5E-11E6-BF01-FE55135034F3"
    case goTennaProprietary002          =   "1276B20A-DF5E-11E6-BF01-FE55135034F3"
    case goTennaProprietary003          =   "1276B20B-DF5E-11E6-BF01-FE55135034F3"
}
