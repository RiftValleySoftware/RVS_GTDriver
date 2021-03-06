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
// MARK: - Public Driver Enums -
/* ###################################################################################################################################### */
/**
 This enum is used to select which vendors to include.
 */
public enum RVS_BTDriver_VendorTypes: Equatable {
    /// This is for goTenna devices.
    case goTenna
    /// This is for any OBD device.
    case OBD
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_SubscriberProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This is a "base" subscriber protocol for accessing driver elements.
 
 We require that subscribers be classes, so they will be referenced.
 */
public protocol RVS_BTDriver_SubscriberProtocol: class {
    /* ################################################################################################################################## */
    // MARK: - Required Instance Propeties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     REQUIRED: The implementation is required to provide this. The implementation should not do anything with it; simply provide a read/write instance property.
     */
    var _uuid: UUID! { get set }
    
    /* ################################################################################################################################## */
    // MARK: - Optional Instance Propeties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     OPTIONAL: This is a unique UUID that needs to be assigned to each instance, so we can match subscribers.
     */
    var uuid: UUID! { get }
}

/* ###################################################################################################################################### */
// MARK: - Default Implementation
/* ###################################################################################################################################### */
extension RVS_BTDriver_SubscriberProtocol {
    /* ################################################################## */
    /**
     This simply generates a new UUID for the subscriber.
     
     It will only generate it the first time.
     */
    public var uuid: UUID! {
        if nil == _uuid {
            _uuid = UUID()
        }
        
        return _uuid
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate for the driver instance. You should definitely do this.
 */
public protocol RVS_BTDriverDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Error reporting method. This is required for the delegate.
     
     - parameter driver: The `RVS_BTDriver` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func btDriver(_ driver: RVS_BTDriver, encounteredThisError: RVS_BTDriver.Errors)
    
    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     - parameter newDeviceAdded: The device object, masked as a protocol.
     */
    func btDriver(_ driver: RVS_BTDriver, newDeviceAdded: RVS_BTDriver_DeviceProtocol)
    
    /* ################################################################## */
    /**
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     */
    func btDriverStatusUpdate(_ driver: RVS_BTDriver)
    
    /* ################################################################## */
    /**
     Called to indicate that the driver started or stopped scanning.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     - parameter isScanning: True, if the new state is scanning is on.
     */
    func btDriverScanningChanged(_ driver: RVS_BTDriver, isScanning: Bool)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverDelegate Default Implementations -
/* ###################################################################################################################################### */
extension RVS_BTDriverDelegate {
    /* ################################################################## */
    /**
     The default implementation does nothing.
     */
    public func btDriver(_ driver: RVS_BTDriver, newDeviceAdded: RVS_BTDriver_DeviceProtocol) { }
    
    /* ################################################################## */
    /**
     The default implementation does nothing.
     */
    public func btDriverStatusUpdate(_ driver: RVS_BTDriver) { }
    
    /* ################################################################## */
    /**
     The default implementation does nothing.
     */
    public func btDriverScanningChanged(_ driver: RVS_BTDriver, isScanning: Bool) { }
}

/* ###################################################################################################################################### */
// MARK: - Public Error Enum -
/* ###################################################################################################################################### */
/**
 These are the various errors that can be returned by this class.
 The enum is designed to provide keys for use by localization. If you access the "localizedDescription" computed property, you will get a consistent string.
 */
extension RVS_BTDriver {
    /// The error enum declaration.
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
         This means that there was a timeout.
         The associated value is any relevant data for that command (typeless).
         */
        case commandTimeout(commandData: Any?)

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
                
            case .commandTimeout:
                caseString = "commandTimeout"

            case .unknownCharacteristicsDiscoveryError:
                caseString = "unknownCharacteristicsDiscoveryError"

            case .unknownCharacteristicsReadValueError:
                caseString = "unknownCharacteristicsReadValueError"

            default:
                 caseString = "unknownError"
            }
            
            return "RVS_BTDriver.Error.\(caseString)"
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Subscript -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     Simple "String Key" subscript, so we can treat the array as a dictionary.
     
     - parameter inStringKey: A String, containing the unique UUID of the device we are looking for.
     
     - returns: The device, or nil, if not found.
     */
    public subscript(_ inStringKey: String) -> RVS_BTDriver_DeviceProtocol! {
        for item in sequence_contents where  item.uuid == inStringKey {
            return item
        }
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Computed Properties -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     A weak reference to the instance delegate.
     */
    public var delegate: RVS_BTDriverDelegate! {
        get {
            return internal_delegate
        }
        
        set {
            internal_delegate = newValue
        }
    }
    
    /* ################################################################## */
    /**
     This is KVO (READ-ONLY)
     
     - returns: true, if all of the vendor interfaces have Bluetooth powered on.
     */
    @objc dynamic public var isBTAvailable: Bool {
        for vendor in internal_vendors where !(vendor.interface?.isBTAvailable ?? false) {
            return false
        }
        return 0 < internal_vendors.count   // Just in case we don't have any vendors (should never happen, but what the hey).
    }
    
    /* ################################################################## */
    /**
     This is KVO (READ-ONLY)
     
     - returns: true, if even one of the vendor interfaces is in active scanning.
     */
    @objc dynamic public var isScanning: Bool {
        for vendor in internal_vendors where (vendor.interface?.isScanning ?? false) {
            return true
        }
        return false
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     Tells the vendor interfaces (all of them) to start scanning for services.
     */
    public func startScanning() {
        if isBTAvailable {
            let wasScanning = isScanning
            internal_vendors.forEach {
                $0.interface?.isScanning = true
            }
            
            if !wasScanning {
                delegate?.btDriverScanningChanged(self, isScanning: true)
                delegate?.btDriverStatusUpdate(self)
            }
        } else {
            #if DEBUG
                print("Scanning not started, because BT is not available.")
            #endif
        }
    }

    /* ################################################################## */
    /**
     Tells the vendor interfaces to stop scanning.
     */
    public func stopScanning() {
        let wasScanning = isScanning
        internal_vendors.forEach {
            $0.interface?.isScanning = false
        }
        
        if wasScanning {
            delegate?.btDriverScanningChanged(self, isScanning: false)
            delegate?.btDriverStatusUpdate(self)
        }
    }
    
    /* ################################################################## */
    /**
     Removes an indicated device from our list.
     
     - parameter inDevice: The device instance to be removed. After this call, it should be considered invalid.
     */
    public func removeDevice(_ inDevice: RVS_BTDriver_DeviceProtocol) {
        if let device = inDevice as? RVS_BTDriver_Device {
            removeThisDevice(device)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Initializer -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     The main initializer.
     
     - parameter delegate: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
     - parameter vendors: This is an Array of vendor enums, and is used to determine which vendors will be loaded.
     - parameter queue: This is a desired queue for the CB manager to operate from. It is optional, and default is nil (main queue).
     - parameter allowDuplicatesInBLEScan:  This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.
                                            If true, it could adversely affect battery life. Default is false.
     - parameter stayConnected: This is set to true, if you want all your device connections to be persistent. That is, once connected, they must be explicitly disconencted by the user.
                                Otherwise, each device will be connected only while interacting.
                                This is optional. Default is false.
     */
    public convenience init(delegate inDelegate: RVS_BTDriverDelegate, vendors inVendors: [RVS_BTDriver_VendorTypes] = [], queue inQueue: DispatchQueue? = nil, allowDuplicatesInBLEScan inAllowDuplicatesInBLEScan: Bool = false, stayConnected inStayConnected: Bool = false) {
        self.init(inDelegate, vendors: inVendors, queue: inQueue, allowDuplicatesInBLEScan: inAllowDuplicatesInBLEScan, stayConnected: inStayConnected)
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Description -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     This is a simplified, readable description of the instance that should be quite useful.
     */
    @objc dynamic public override var description: String {
        return  "RVS_BTDriver Instance.\n"
            +   "\tBluetooth is " + (isBTAvailable ? "" : "not ") + "available.\n"
            +   "\tThe driver is " + (isScanning ? "" : "not ") + "scanning.\n"
            +   "\tThe driver has \(count) devices discovered"
            +   (0 < count ? ":\n\t" + String(describing: sequence_contents) : ".")
    }
}
