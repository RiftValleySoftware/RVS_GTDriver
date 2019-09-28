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
    /// This is the general service ID for the class.
    static var serviceID: String { get }
    /// These are the characteristics, supplied as "values."
    var values: [RVS_BLEDriver_ValueProtocol] { get }
    /* ################################################################## */
    /**
     */
    subscript(_ inHash: String) -> RVS_BLEDriver_ValueProtocol? { get }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_ServiceProtocol {
    /* ################################################################## */
    /**
     Default is unknown.
     */
    public static var serviceID: String {
        return ""
    }
    
    /* ################################################################## */
    /**
     Simple subscript, where we search for a value by its subscript.
     
     - parameter inHash: The UUID of the value, as a String.
     - returns: The value intance, masked as a protocol. Nil, if not found.
     */
    public subscript(_ inHash: String) -> RVS_BLEDriver_ValueProtocol? {
        for value in values where (value.uuidString) == inHash {
            return value
        }
        
        // If the straight-up UUID didn't work, try adding the hex prefix.
        for value in values where ("0x" + value.uuidString) == inHash {
            return value
        }
        
        return nil
    }
}
