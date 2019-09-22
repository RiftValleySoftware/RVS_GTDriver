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
// MARK: - Adapter Class for goTenna Devices -
/* ########################################################################################################################################## */
/**
 This class provides a set of constants and factories for handling goTenna devices.
 */
class RVS_GTDevice_DeviceSpec_goTenna: RVS_GTDevice_DeviceSpec {
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
        case goTennaProprietary001          =   "12762B18-DF5E-11E6-BF01-FE55135034F3"
        case goTennaProprietary002          =   "1276B20A-DF5E-11E6-BF01-FE55135034F3"
        case goTennaProprietary003          =   "1276B20B-DF5E-11E6-BF01-FE55135034F3"
    }
    
    /* ################################################################## */
    /**
     - returns: An Array, with the UUIDs of all the services this handler will take.
     */
    private var _serviceUUIDs: [CBUUID] = [
        CBUUID(string: RVS_BLE_GATT_UUID.goTennaProprietary.rawValue)           // We handle proprietary services, too.
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
     - returns: An Array, with the UUIDs of the service[s] that the handler advertises (for a search).
     */
    var advertisedServiceUUIDs: [CBUUID] {
        return serviceUUIDs
    }
    
    /* ################################################################## */
    /**
     This allows the handler to "adopt" a service.
     This is a factory method for creating instances of our goTenna Services.
     
     - parameter inService: The discovered Core Bluetooth service.
     - parameter forPeripheral: The Core Bluetooth peripheral that "owns" the discovered service.
     - parameter andDevice: The Instance of the device that "owns" this service.
     - returns: An instance of a subclass of RVS_GTService, if it is handled by this instance, or nil, if not.
     */
    func handleDiscoveredService(_ inService: CBService, forPeripheral inPeripheral: CBPeripheral, andDevice inDevice: RVS_GTDevice) -> RVS_GTService! {
        if serviceUUIDs.contains(inService.uuid) {
            let initialCharacteristics = [  CBUUID(string: RVS_BLE_GATT_UUID.goTennaProprietary001.rawValue),
                                            CBUUID(string: RVS_BLE_GATT_UUID.goTennaProprietary002.rawValue),
                                            CBUUID(string: RVS_BLE_GATT_UUID.goTennaProprietary003.rawValue)
            ]
            return RVS_GTService_goTenna(inService, owner: inDevice, initialCharacteristics: initialCharacteristics)
        }

        return nil
    }
}

/* ########################################################################################################################################## */
// MARK: - General-Purpose Service Class for goTenna Devices -
/* ########################################################################################################################################## */
/**
 This is a general-purpose goTenna service class. It will probably be superceded by more specialized ones.
 */
internal class RVS_GTService_goTenna: RVS_GTService {
    /* ################################################################## */
    /**
     This is a factory function, for creating characteristic instances.
     
     This is declared @objc, so we can override it in our factory-produced subclasses.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    @objc internal override func makeCharacteristicForThisCharacteristic(_ inCharacteristic: CBCharacteristic) -> RVS_GTCharacteristic? {
        return RVS_GTCharacteristic_goTenna(inCharacteristic, owner: self)
    }
}

/* ########################################################################################################################################## */
// MARK: - General-Purpose Characteristic Class for goTenna Devices -
/* ########################################################################################################################################## */
/**
 This is a general-purpose goTenna Characteristic class. It will probably be superceded by more specialized ones.
 */
internal class RVS_GTCharacteristic_goTenna: RVS_GTCharacteristic {
}
