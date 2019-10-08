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
// MARK: - RVS_BTDriver_DeviceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_DeviceDelegate: class {
    /* ################################################################## */
    /**
     REQUIRED: Error reporting method.
     
     - parameter device: The `RVS_BTDriver_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func device(_ device: RVS_BTDriver_DeviceProtocol, encounteredThisError: RVS_BTDriver.Errors)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_DeviceProtocol Protocol (Aggregates Services) -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_DeviceProtocol {
    /* ################################################################## */
    /**
     This is the public read-only access to the service list.
     */
    var services: [RVS_BTDriver_ServiceProtocol] { get }
    
    /* ################################################################## */
    /**
     This is the read-only count of services.
     */
    var count: Int { get }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the service list.
     */
    subscript(_ inIndex: Int) -> RVS_BTDriver_ServiceProtocol { get }
    
    /* ################################################################## */
    /**
     This is a read-write accessor for the delegate for this device. It is a weak reference.
     */
    var delegate: RVS_BTDriver_DeviceDelegate! { get set }
}
