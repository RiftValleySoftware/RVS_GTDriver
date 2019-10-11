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
class RVS_BTDriver_Vendor_GoTenna_Mesh: NSObject, RVS_BTDriver_VendorProtocol {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        /// The standard GATT Device Info service.
        case deviceInfoService              =   "180A"
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
     These are the services that we scan for. In our case, it is simply the goTenna proprietary service.
     */
    var serviceSignatures: [String] {
        return [RVS_BLE_GATT_UUID.goTennaProprietary.rawValue]
    }

    /* ################################################################## */
    /**
     Read-only accessor for the interface. This is a weak reference.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface()` has not yet been called.
     */
    internal weak var interface: RVS_BTDriver_InterfaceProtocol!

    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        if let deviceRecord = inDeviceRecord as? RVS_BTDriver_Interface_BLE.DeviceInfo {
            let ret = RVS_BTDriver_Device_GoTenna_Mesh(vendor: self)
            
            ret.peripheral = deviceRecord.peripheral
            ret.centralManager = deviceRecord.centralManager
            
            /// These are the services we search for, after connecting.
            ret.internal_initalServiceDiscovery = [CBUUID(string: RVS_BTDriver_Vendor_GoTenna_Mesh.RVS_BLE_GATT_UUID.deviceInfoService.rawValue),
                                                   CBUUID(string: RVS_BTDriver_Vendor_GoTenna_Mesh.RVS_BLE_GATT_UUID.goTennaProprietary.rawValue)
            ]

            deviceRecord.peripheral.delegate = ret

            return ret
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     Factory for creating (or referencing) the appropriate interface instance.
     
     - parameter queue: The DispatchQueue to use for this (can be nil, in which case, the main queue is used).
     */
    internal func makeInterface(queue inQueue: DispatchQueue!) {
        interface = RVS_BTDriver_Interface_BLE.makeInterface(queue: inQueue)
        interface.driver = driver   // Who's your daddy?
        // Scan for our devices. Don't bother adding if we are already there.
        for serviceSignature in serviceSignatures where !interface.serviceSignatures.contains(serviceSignature) {
            interface.serviceSignatures.append(serviceSignature)
        }
        
        // If we are already on the guest list, then there's no need to add ourselves.
        for vendor in interface.vendors where type(of: vendor) == type(of: self) {
            return
        }
        
        interface.vendors.append(self)
    }
    
    /* ################################################################## */
    /**
     The default initializer.
     
     - parameter driver: The `RVS_BTDriver` instance that "owns" this instance.
     */
    init(driver inDriver: RVS_BTDriver) {
        super.init()
        internal_driver = inDriver
        makeInterface(queue: inDriver.internal_queue)
    }
}

/* ###################################################################################################################################### */
// MARK: - Core Bluetooth Peripheral Delegate Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Device_GoTenna_Mesh: RVS_BTDriver_BLE_Device, CBPeripheralDelegate {
    /* ################################################################## */
    /**
     Called when we have discovered services for the peripheral.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverServices: Any errors that ocurred.
    */
    internal func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        if let error = inError {
            #if DEBUG
                print("\n***> Service Discovery Error: \(String(describing: inError))\n")
            #endif
            reportThisError(.unknownPeripheralDiscoveryError(error: error))
        } else if let services = inPeripheral.services {
            #if DEBUG
                print("\n***> Services Discovered:\n\t\(String(describing: services))")
            #endif
        } else {
            #if DEBUG
                print("\tNo services. Just disconnecting.\n")
            #endif
        }
        
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when the peripheral is ready.
     
    - parameter toSendWriteWithoutResponse: The peripheral that is ready.
    */
    internal func peripheralIsReady(toSendWriteWithoutResponse inPeripheral: CBPeripheral) {
        #if DEBUG
            print("Peripheral Is Ready: \(inPeripheral)")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called to initiate a connection.
    */
    override internal func connect() {
        if .disconnected == peripheral.state { // Must be completely disconnected
            #if DEBUG
                print("Connecting the device: \(String(describing: self))")
            #endif
            centralManager.connect(peripheral, options: nil)
        }
    }
}
