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
// MARK: - Main Driver RVS_GTDriverDelegate Protocol -
/* ###################################################################################################################################### */
/**
 A delegate object is required to instantiate an instance of the driver class.
 
 This is the delegate protocol.
 
 Protocols are an important part of this driver. The driver protocol is required. Protocols for devices and services are optional.
 
 Each protocol has only one required method: an error receiver. We use an enum that wraps errors, and is returned in the handler.
 */
public protocol RVS_GTDriverDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by the main driver.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDriver(_ driver: RVS_GTDriver, errorEncountered: RVS_GTDriver.Errors)

    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    func gtDriver(_ driver: RVS_GTDriver, newDeviceAdded: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    func gtDriverStatusUpdate(_ driver: RVS_GTDriver)

    /* ###################################################################################################################################### */
    // MARK: - Optional Advanced Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     This is the only place that Core Bluetooth is exposed!
     
     Called when a peripheral is discovered, and before a device instance is instantiated. This gives your implementation the chance to "vet" a device before adding it to our list.
     
     You may return false, if you want to prevent the peripheral from being loaded. This will not remove the peripheral from discovery; it only prevents it from being loaded.
     
     This is optional, and is NOT guaranteed to be called in the main thread. If not specified, the device will always be added.
     
     - parameter driver: The driver instance calling this.
     - parameter peripheralDiscovered: The peripheral object (CoreBluetooth CBPeripheral).
     - returns: True, if the peripheral is to be instantiated.
     */
    func gtDriver(_ driver: RVS_GTDriver, peripheralDiscovered: CBPeripheral) -> Bool
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_GTDriverDelegate Protocol Extension -
/* ###################################################################################################################################### */
/**
 These defaults allow a number of methods to be optional.
 */
extension RVS_GTDriverDelegate {
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter driver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    public func gtDriver(_ driver: RVS_GTDriver, newDeviceAdded: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter driver: The driver instance calling this.
     */
    public func gtDriverStatusUpdate(_ driver: RVS_GTDriver) { }

    /* ################################################################## */
    /**
     The default implementation always returns true.
     
     - parameter driver: The driver instance calling this.
     - parameter peripheralDiscovered: The peripheral object.
     - returns: True.
     */
    public func gtDriver(_ driver: RVS_GTDriver, peripheralDiscovered: CBPeripheral) -> Bool {
        return true
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Declaractions -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the driver. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 One other thing about this class, is that it conforms to Sequence, so you can iterate through it for devices, or access devices as subscripts.
 */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     The main initializer.
     
     - parameter delegate: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
     - parameter queue: This is a desired queue for the CB manager to operate from. It is optional, and default is nil (main queue).
     - parameter allowDuplicatesInBLEScan:  This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.
                                            If true, it could adversely affect battery life. Default is false.
     */
    public convenience init(delegate inDelegate: RVS_GTDriverDelegate, queue inQueue: DispatchQueue? = nil, allowDuplicatesInBLEScan inAllowDuplicatesInBLEScan: Bool = false) {
        self.init(delegate: inDelegate, queue: inQueue)
        internal_AllowDuplicatesInBLEScan = inAllowDuplicatesInBLEScan
    }

    /* ################################################################################################################################## */
    // MARK: - Error Enums -
    /* ################################################################################################################################## */
    /**
     These are the various errors that can be returned by this class.
     The enum is designed to provide keys for use by localization. If you access the "localizedDescription" calculated property, you will get a consistent string.
     */
    public enum Errors: Error {
        /* ################################################################## */
        /**
         This is returned if the manager can't power on.
         */
        case bluetoothNotAvailable
        
        /* ################################################################## */
        /**
         This is returned if we cannot connect to the device.
         The associated value is any error that occurred.
         */
        case connectionAttemptFailed(error: Error?)
        
        /* ################################################################## */
        /**
         This is returned if we connected, but no device was available. This should never happen.
         */
        case connectionAttemptFailedNoDevice

        /* ################################################################## */
        /**
         This is returned if we cannot disconnect from the device.
         The associated value is any error that occurred.
         */
        case disconnectionAttemptFailed(error: Error?)
        
        /* ################################################################## */
        /**
         This is a "catchall" error for a disconnection issue
         */
        case unknownDisconnectionError

        /* ################################################################## */
        /**
         This is a "catchall" error for peripheral discovery
         The associated value is any error that occurred.
         */
        case unknownPeripheralDiscoveryError(error: Error?)
        
        /* ################################################################## */
        /**
         This means that we did not get a characteristic value
         */
        case characteristicValueMissing
        
        /* ################################################################## */
        /**
         This is a "catchall" error for characteristics discovery
         The associated value is any error that occurred.
         */
        case unknownCharacteristicsDiscoveryError(error: Error?)
        
        /* ################################################################## */
        /**
         This is a "catchall" error for characteristics value read
         The associated value is any error that occurred.
         */
        case unknownCharacteristicsReadValueError(error: Error?)

        /* ################################################################## */
        /**
         This is a "catchall" error.
         The associated value is any error that occurred.
         */
        case unknownError(error: Error?)

        /* ################################################################## */
        /**
         The localized description is a simple slug that can be used to key a client-supplied message.
         It is a very simple class.enum.case String.
         NOTE: This May not be in the main thread!
         */
        public var localizedDescription: String {
            var caseString = ""
            switch self {
            case .bluetoothNotAvailable:
                caseString = "bluetoothNotAvailable"

            case .connectionAttemptFailed:
                caseString = "connectionAttemptFailed"

            case .connectionAttemptFailedNoDevice:
                caseString = "connectionAttemptFailedNoDevice"

            case .disconnectionAttemptFailed:
                caseString = "disconnectionAttemptFailed"

            case .unknownDisconnectionError:
                caseString = "unknownDisconnectionError"

            case .unknownPeripheralDiscoveryError:
                caseString = "unknownPeripheralDiscoveryError"

            case .characteristicValueMissing:
                caseString = "characteristicValueMissing"

            case .unknownCharacteristicsDiscoveryError:
                caseString = "unknownCharacteristicsDiscoveryError"

            case .unknownCharacteristicsReadValueError:
                caseString = "unknownCharacteristicsReadValueError"

            default:
                 caseString = "unknownError"
            }
            return "RVS_GTDriver.Error.\(caseString)"
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Public Calculated Instance Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    public var delegate: RVS_GTDriverDelegate {
        return internal_delegate
    }
    
    /* ################################################################## */
    /**
     This is KVO-observable.
     Returns true, if we are currently scanning for new CB peripherals.
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var isScanning: Bool {
        get {
            return internal_centralManager.isScanning
        }
        
        set {
            if !newValue {
                internal_centralManager.stopScan()
            } else {
                // If we are not powered on, then we report an error, and stop.
                guard CBManagerState.poweredOn == internal_centralManager.state else {
                    reportThisError(.bluetoothNotAvailable)
                    return
                }
                // See if we want to be continuously scanning.
                let options = [
                    CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: internal_AllowDuplicatesInBLEScan)
                ]
                // We search for any devices that advertise the goTenna proprietary service.
                internal_centralManager.scanForPeripherals(withServices: [CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary.rawValue)], options: options)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is KVO-observable. READ-ONLY.
     Returns true, if the bluetooth system is valid.
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var isBluetoothAvailable: Bool {
        return .poweredOn == internal_centralManager.state
    }
    
    /* ################################################################## */
    /**
     This accesses the devices as a simple Array.
     This is KVO-observable. READ-ONLY.
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var devices: [RVS_GTDevice] {
        return sequence_contents
    }
}
