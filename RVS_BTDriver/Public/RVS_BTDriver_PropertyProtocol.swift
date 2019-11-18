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
// MARK: - Main Driver RVS_BTDriver_PropertyProtocol_Type_Enum, Used to Cast the Data -
/* ###################################################################################################################################### */
/**
 This enum is used to cast a property value into its proper data type.
 */
public enum RVS_BTDriver_PropertyProtocol_Type_Enum: Equatable {
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
// MARK: - RVS_BTDriver_PropertyProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This represents the public face of a "property," which maps to a bluetooth "characteristic."
 */
public protocol RVS_BTDriver_PropertyProtocol: class {
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns" this instance.
     */
    var owner: RVS_BTDriver_ServiceProtocol! { get }
    
    /* ################################################################## */
    /**
     - returns: The value, expressed as raw Data. Nil, if no value available (or not available as Data).
     */
    var rawValue: Data? { get }
    
    /* ################################################################## */
    /**
     - returns: The Value, but cast into a specific data type (selected by the enum).
     */
    var value: RVS_BTDriver_PropertyProtocol_Type_Enum { get }
    
    /* ################################################################## */
    /**
     - returns: The user description of the value (if any). If none, the String will be empty.
     */
    var description: String { get }
    
    /* ################################################################## */
    /**
     - returns: The UUID of the value characteristic, as a String.
     */
    var uuid: String { get }
}
