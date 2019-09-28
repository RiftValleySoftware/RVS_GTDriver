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

/* ########################################################################################################################################## */
// MARK: - Adapter Class for Any Device -
/* ########################################################################################################################################## */
/**
 This is a "general-purpose" adapter. It provides some of the standard BLE services and characteristics.
 */
public class RVS_BLEDevice_DeviceSpec_GeneralPurpose: RVS_BLEDevice_DeviceSpec {    
    /* ################################################################## */
    /**
     - returns: An Array, with the UUIDs of all the services this handler will take.
     */
    private var _serviceUUIDs: [CBUUID] = [ // We register for standard services
        CBUUID(string: RVS_BLE_DeviceInfo_Service.serviceID)    // Device Info.
    ]
    
    /* ################################################################## */
    /**
     - returns: An Array, with the UUIDs of all the services this handler will take.
     */
    internal var serviceUUIDs: [CBUUID] {
        return _serviceUUIDs
    }

    /* ################################################################## */
    /**
     - returns: An empty Array. We don't advertise.
     */
    var advertisedServiceUUIDs: [CBUUID] {
        return []
    }
    
    /* ################################################################## */
    /**
     This allows the handler to "adopt" a service.
     This is a factory method for creating instances of our goTenna Services.
     
     - parameter inService: The discovered Core Bluetooth service.
     - parameter forPeripheral: The Core Bluetooth peripheral that "owns" the discovered service.
     - parameter andDevice: The Instance of the device that "owns" this service.
     - returns: An instance of a subclass of RVS_BLEService, if it is handled by this instance, or nil, if not.
     */
    func handleDiscoveredService(_ inService: CBService, forPeripheral inPeripheral: CBPeripheral, andDevice inDevice: RVS_BLEDevice) -> RVS_BLEService! {
        // If this is the device info service, we make an instance of the RVS_BLE_DeviceInfo_Service specialized subclass.
        if  serviceUUIDs.contains(inService.uuid),
            RVS_BLE_DeviceInfo_Service.serviceID == "0x" + inService.uuid.uuidString {
            // We start off by looking for these four characteristics.
            let initialCharacteristics = [  CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoManufacturerName.rawValue),
                                            CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoModelName.rawValue),
                                            CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoHardwareRevision.rawValue),
                                            CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoFirmwareRevision.rawValue)
            ]
            return RVS_BLE_DeviceInfo_Service(inService, owner: inDevice, initialCharacteristics: initialCharacteristics)
        }

        return nil
    }
}
