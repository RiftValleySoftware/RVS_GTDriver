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
// MARK: - RVS_BTDriver_Base_Interface -
/* ###################################################################################################################################### */
/**
 This is the base class for our transport abstractions.
 */
internal class RVS_BTDriver_Base_Interface: NSObject, RVS_BTDriver_InterfaceProtocol {
    /* ################################################################## */
    /**
     Holds our SINGLETON
    */
    internal static var internal_interface: RVS_BTDriver_InterfaceProtocol!

    /* ################################################################## */
    /**
     A weak reference to the main driver instance.
     */
    internal weak var driver: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     You cannot use the base class version of this. This is just here to satisfy the protocol.
     */
    internal var isBTAvailable: Bool {
        preconditionFailure("Cannot Call the Base Class")
    }

    /* ################################################################## */
    /**
     Read-only accessor for the interface.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface(:)` has not yet been called.
     */
    internal var interface: RVS_BTDriver_InterfaceProtocol! {
        return type(of: self).internal_interface
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
