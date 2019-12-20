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

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Vendor_OBD_ELM327 -
/* ###################################################################################################################################### */
/**
 A base class for various OBD dongle handlers, based on the ELM327 chipset.
 */
class RVS_BTDriver_Vendor_OBD_ELM327: RVS_BTDriver_Vendor_OBD {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary OBD ELM327 BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID                           =   "ELM327"
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
// MARK: - OBD ELM327 Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD ELM327 Devices.
 */
class RVS_BTDriver_Device_OBD_ELM327: RVS_BTDriver_Device_OBD {
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD_ELM327.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}
