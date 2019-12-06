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
     A weak reference to the main driver instance.
     */
    internal weak var driver: RVS_BTDriver!

    /* ################################################################## */
    /**
     This flag tells the driver to maintain a persistent connection (until explicitly disconneted).
     
     Otherwise, connections are made and canceled for each transaction.
     
     Default is false.
     */
    var persistentConnection: Bool = false
    
    /* ################################################################## */
    /**
     A list of the vendors that are users of this interface.
     */
    var vendors: [RVS_BTDriver_VendorProtocol] = []

    /* ################################################################## */
    /**
     This flag tells the driver to "remember" devices that it discovers in a scan.
     
     This means that when a device is "rediscovered," we don't get another discovery event.
     
     If true (default), then we only get one discovery event per device. If false, we keep getting discovery events.
     
     This can be useful for "rediscovering" devices that we remove from our list (set to `false` for that).
     */
    var rememberAdvertisedDevices: Bool = true

    /* ################################################################## */
    /**
     You cannot use the base class version of this. This is just here to satisfy the protocol.
     */
    internal var isBTAvailable: Bool {
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
