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
// MARK: - RVS_BTDriver_InterfaceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This is a protocol that describes the basic transport abstraction for our bluetooth device connection. It will be specialized for Classic or BLE.
 */
internal protocol RVS_BTDriver_InterfaceProtocol: class {
    /* ################################################################## */
    /**
     Read-only accessor for the interface.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface(:)` has not yet been called.
     */
    var interface: RVS_BTDriver_InterfaceProtocol! { get }

    /* ################################################################## */
    /**
     OPTIONAL (but actually required): This is a factory/accessor for the interface SINGLETON.
     */
    static func makeInterface(queue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     REQUIRED: This is an "on/off" switch for scanning for peripherals.
     
     If set to true, scanning begins, if false, scanning stops.
     */
    var isScanning: Bool { get set }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_InterfaceProtocol Protocol Optionals -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_InterfaceProtocol {
    /* ################################################################## */
    /**
     This allows us to skip the base class, so we don't need to override anything.
     */
    internal var interface: RVS_BTDriver_InterfaceProtocol! {
        preconditionFailure("Cannot Call the Base Class")
    }

    /* ################################################################## */
    /**
     This allows us to skip the base class, so we don't need to override anything.
     */
    internal static func makeInterface(queue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol! {
        preconditionFailure("Cannot Call the Base Class")
    }
    
    /* ################################################################## */
    /**
     You cannot use the base class version of this. This is just here to satisfy the protocol.
     */
    internal var isScanning: Bool {
        get {
            preconditionFailure("Cannot Call the Base Class")
        }
        
        set {
            _ = newValue    // To keep SwiftLint happy.
            preconditionFailure("Cannot Call the Base Class")
        }
    }
}
