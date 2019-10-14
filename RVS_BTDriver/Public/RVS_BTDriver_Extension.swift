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
// MARK: - RVS_BTDriver_SubscriberProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This is a "base" subscriber protocol for accessing driver elements.
 
 We require that subscribers be classes, so they will be referenced.
 */
public protocol RVS_BTDriver_SubscriberProtocol: class {
    /* ################################################################## */
    /**
     REQUIRED: This is a unique UUID that needs to be assigned to each instance, so we can match subscribers.
     
     The implementor should declare this, and set it only once with something like this code:
     
        `var uuid = UUID() /// Has to be a var, because protocol`
     
     After that, forget about it.
     */
    var uuid: UUID { get }
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
}

/* ###################################################################################################################################### */
// MARK: - Public Error Enum -
/* ###################################################################################################################################### */
/**
 These are the various errors that can be returned by this class.
 The enum is designed to provide keys for use by localization. If you access the "localizedDescription" calculated property, you will get a consistent string.
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
            
            return "RVS_BTDriver.Error.\(caseString)"
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Properties -
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
        for vendor in vendors where !vendor.interface.isBTAvailable {
            return false
        }
        return true
    }
    
    /* ################################################################## */
    /**
     This is KVO (READ-ONLY)
     
     - returns: true, if even one of the vendor interfaces is in active scanning.
     */
    @objc dynamic public var isScanning: Bool {
        for vendor in vendors where vendor.interface.isScanning {
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
        vendors.forEach {
            $0.interface.isScanning = true
        }
    }

    /* ################################################################## */
    /**
     Tells the vendor interfaces to stop scanning.
     */
    public func stopScanning() {
        vendors.forEach {
            $0.interface.isScanning = false
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Initializer -
/* ###################################################################################################################################### */
extension RVS_BTDriver {
    /* ################################################################## */
    /**
     The main initializer for the class.
     
     - parameter delegate: The delegate instance. It is required, and cannot be nil.
     */
    public convenience init(delegate inDelegate: RVS_BTDriverDelegate) {
        self.init(inDelegate)
    }
}
