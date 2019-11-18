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
// MARK: - RVS_BTDriver_Property -
/* ###################################################################################################################################### */
/**
 This is one "property," which maps to a bluetooth "characteristic."
 */
internal class RVS_BTDriver_Property: NSObject, RVS_BTDriver_PropertyProtocol {
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns" this instance.
     */
    internal weak var internal_owner: RVS_BTDriver_Service!

    /* ################################################################## */
    /**
     Simple check to see if this property has already been initialized.
     
     - returns: True, if the property is no longer in the "holding pen," which means that it has been initialized.
     */
    internal var isInitialized: Bool {
        if let internal_owner = internal_owner {
            for property in internal_owner.internal_property_list where property === self {
                return true
            }
        }
        
        return false
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Methods for Overriding
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the property is updated.
     */
    internal func executeUpdate() {
        // If we are still in the holding cell, then we move.
        internal_owner?.movePropertyFromHoldingPenToMainList(self)
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public RVS_BTDriver_PropertyProtocol Properties and Computed Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     - returns: The value, expressed as raw Data. Nil, if no value available (or not available as Data).
     */
    public internal(set) var rawValue: Data?
    
    /* ################################################################## */
    /**
     - returns: The UUID of the value characteristic, as a String.
     */
    public internal(set) var uuid: String = ""
    
    /* ################################################################## */
    /**
     - returns: The Value, but cast into a specific data type (selected by the enum).
     */
    public var value: RVS_BTDriver_PropertyProtocol_Type_Enum {
        if  let rawValue = rawValue {
            if let stringVal = String(data: rawValue, encoding: .utf8) {
                if let floatVal = Double(stringVal) {   // See if we are a number.
                    if  floatVal == floor(floatVal),    // Quick Integer test.
                        Double(Int32.max) >= floatVal,  // We clamp to 32-bit Int to be safe. Double conversions from String can have precision weirdness.
                        Double(Int32.min) <= floatVal {
                        return .intValue(Int(floatVal))
                    } else {
                        return .floatValue(floatVal)
                    }
                }
                return .stringValue(stringVal)
            } else {
                return .rawValue(rawValue)
            }
        }
        
        return .undefinedValue
    }
}

/* ###################################################################################################################################### */
// MARK: - Public RVS_BTDriver_PropertyProtocol Support
/* ###################################################################################################################################### */
extension RVS_BTDriver_Property {
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns" this instance.
     */
    public var owner: RVS_BTDriver_ServiceProtocol! {
        return internal_owner
    }
}

/* ###################################################################################################################################### */
// MARK: - Communicator Support -
/* ###################################################################################################################################### */
/**
 We establish a communicator chain, here.
 */
extension RVS_BTDriver_Property: RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the owner.
     */
    internal func reportThisError(_ inError: RVS_BTDriver.Errors) {
        internal_owner?.reportThisError(inError)
    }
}
