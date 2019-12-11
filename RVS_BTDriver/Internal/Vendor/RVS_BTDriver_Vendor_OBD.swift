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
// MARK: - RVS_BTDriver_Vendor_OBD -
/* ###################################################################################################################################### */
/**
 A base class for various OBD dongle handlers.
 */
class RVS_BTDriver_Vendor_OBD: RVS_BTDriver_Vendor_GenericBLE {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary OBD BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        /// This is the communication service for FSC-BT826N BLE devices.
        case vlinkUserDefinedService                    =   "18F0"
        /// This is the indicate/notify property for communicating with VLink devices.
        case vlinkIndicateNotifyProperty                =   "2AF0"
        /// This is the write-only property for communicating with VLink devices.
        case vlinkWriteProperty                         =   "2AF1"
        
        /// This is the communication service for communicating with LELink BLE devices
        case leLinkUserDefinedService                   =   "FFE0"
        /// This is the read/write/notify property of an LELink BLE device
        case leLinkReadWriteNotifyProperty              =   "FFE1"
        /// This is the read/write property of an LELink BLE device
        case leLinkReadWriteProperty                    =   "FFEE"
        
        /// This is the communication service for the Zentri (Kiwi 60) BLE device
        case kiwiUserDefinedService                     =   "B2E7D564-C077-404E-9D29-B547F4512DCE"
        /// This is the write, indicate, notify property for the Kiwi 60 BLE device
        case kiwiWriteIndicateNotifyProperty            =   "48CBE15E-642D-4555-AC66-576209C50C1E"
        /// This is the write property for the Kiwi 60 BLE device
        case kiwiWriteProperty                          =   "DB96492D-CF53-4A43-B896-14CBBF3BF4F3"
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
        precondition(false, "Cannot Call Base Class Method!")
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD Devices.
 */
class RVS_BTDriver_Device_OBD: RVS_BTDriver_Device_BLE {
    /* ################################################################## */
    /**
     This property is one that the OBD unit uses to send AT commands to the driver.
     */
    internal var readProperty: RVS_BTDriver_Property_BLE!
    
    /* ################################################################## */
    /**
     This property is one that the OBD unit uses to receive AT commands from the driver.
     */
    internal var writeProperty: RVS_BTDriver_Property_BLE!
    
    /* ################################################################## */
    /**
     This property is one that the OBD unit uses to send AT commands to the driver, but as inidicate, not read.
     */
    internal var indicateProperty: RVS_BTDriver_Property_BLE!
    
    /* ################################################################## */
    /**
     This is a String, containing a unique ID for this peripheral.
     */
    override public var uuid: String! {
        get {
            return peripheral.identifier.uuidString
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property!")
        }
    }
}
