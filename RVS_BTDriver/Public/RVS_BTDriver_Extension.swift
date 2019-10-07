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
// MARK: - RVS_BTDriverDelegate Protocol -
/* ###################################################################################################################################### */
/**
 */
protocol RVS_BTDriverDelegate: class {
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver {
    /* ################################################################################################################################## */
    // MARK: - Public Error Enum -
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
            
            return "RVS_BTDriver.Error.\(caseString)"
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Calculated Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     A weak reference to the instance delegate.
     */
    public var delegate: RVS_BTDriverDelegate! {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
}
