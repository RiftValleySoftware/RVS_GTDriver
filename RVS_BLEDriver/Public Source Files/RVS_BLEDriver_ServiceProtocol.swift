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
// MARK: - Main Driver RVS_BLEDriver_DeviceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This protocol describes a device, or collection of "services."
 */
public protocol RVS_BLEDriver_DeviceProtocol {
    var services: [RVS_BLEDriver_ServiceProtocol] { get }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This protocol describes a service, or collection of "values."
 */
public protocol RVS_BLEDriver_ServiceProtocol {
    var values: [RVS_BLEDriver_ValueProtocol] { get }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ValueProtocol_Type_Enum, Used to Cast the Data -
/* ###################################################################################################################################### */
/**
 This enum is used to cast a value into its proper data type.
 */
public enum RVS_BLEDriver_ValueProtocol_Type_Enum {
    /// The data, cast to a String (associated value)
    case stringValue(_: String!)
    /// The data, cast to an Integer (associated value)
    case intValue(_: Int!)
    /// The data, cast to a Boolean (associated value)
    case boolValue(_: Bool!)
    /// The data, cast to a double-precision float (associated value)
    case floatValue(_: Double!)
    /// The data is not able to be cast, and is returned as the raw Data type.
    case rawValue(_: Data!)
    /// This is returned if the data is nil, or an undefined type (no associated value).
    case undefinedValue
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ValueProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This protocol is used to describe one value in a service.
 */
public protocol RVS_BLEDriver_ValueProtocol {
    /* ################################################################################################################################## */
    // MARK: - Required Methods -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     - returns: The value, expressed as raw Data. Nil, if no value available (or not available as Data).
     */
    var rawValue: Data? { get }

    /* ################################################################## */
    /**
     - returns: The Value, but cast into a specific data type (selected by the enum).
     */
    var value: RVS_BLEDriver_ValueProtocol_Type_Enum { get }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ValueProtocol Protocol Default Implementations -
/* ###################################################################################################################################### */
/**
 This protocol is used to describe one value in a service.
 */
extension RVS_BLEDriver_ValueProtocol {
    /* ################################################################## */
    /**
     The default implementation returns nil.
     
     - returns: Nil
     */
    public var rawValue: Data? {
        return nil
    }
    
    /* ################################################################## */
    /**
     The default implementation returns undefined.
     
     - returns: Undefined data type.
     */
    public var value: RVS_BLEDriver_ValueProtocol_Type_Enum {
        return .undefinedValue
    }
}
