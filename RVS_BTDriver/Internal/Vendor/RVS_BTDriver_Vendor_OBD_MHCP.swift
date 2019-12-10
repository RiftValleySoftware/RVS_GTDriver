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
 A factory class for OBD dongles, based on the MHCP chipset.
 */
class RVS_BTDriver_Vendor_OBD_MHCP: RVS_BTDriver_Vendor_OBD {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        /// This is the read/write service used by MCHP-based chipsets.
        case mchpUserDefinedService                     =   "49535343-FE7D-4AE5-8FA9-9FAFD205E455"
        /// This is a read/write property for communicating with a MCHP-based chipset
        case mchpUserDefinedServiceReadWriteProperty    =   "49535343-6DAA-4D02-ABF6-19569ACA69FE"
        /// This is a read-only property for communicating with a MCHP-based chipset
        case mchpUserDefinedServiceReadProperty         =   "49535343-ACA3-481C-91EC-D58E28A60318"
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
            let ret = RVS_BTDriver_Vendor_OBD_MHCP_Device(vendor: self)
            
            ret.deviceInfoStruct = deviceRecord
            ret.canConnect = 1 == (deviceRecord.advertisementData[CBAdvertisementDataIsConnectable] as? Int ?? 0)

            deviceRecord.peripheral.delegate = ret

            return ret
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is called to ask the vendor to test a device for "ownership."
     
     In some cases, the test may be a NOP, but in others, it may require some back-and-forth, before it is resolved.
     
     - parameter inDevice: The device we're testing for ownership.
     */
    override internal func testDevice(_ inDevice: RVS_BTDriver_DeviceProtocol) {
        // We need it to be a BLE device, and that device can't be identified, yet, or under test.
        if  let device = inDevice as? RVS_BTDriver_Device_BLE,
            .unTested == device.deviceType {
// TODO: Remove this comment, and delete the following line.
//            device.deviceType = .testing
            device.deviceType = .unknown
        }
    }
    
    /* ################################################################## */
    /**
     This tests a device to see if it has a pattern of services and properties consistent with being an OBD device.
     
     - parameter inDevice: The device we're testing for ownership.
     
     - returns: true, if the device appears to be eligible for testing as OBD.
     */
    override internal func deviceCouldBeOBD(_ inDevice: RVS_BTDriver_Device_BLE) -> Bool {
        return false
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD Devices.
 */
class RVS_BTDriver_Vendor_OBD_MHCP_Device: RVS_BTDriver_Device_BLE {
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
