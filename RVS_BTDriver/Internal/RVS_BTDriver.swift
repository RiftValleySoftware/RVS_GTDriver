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
// MARK: - RVS_BTDriver -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver: NSObject {
    /* ################################################################## */
    /**
     This contains instances that have not yet passed a credit check.
     */
    internal var internal_holding_pen: [RVS_BTDriver_Device] = []
    
    /* ################################################################## */
    /**
     This contains the device list for this instance of the driver.
     */
    internal var internal_device_list: [RVS_BTDriver_Device] = []
    
    /* ################################################################## */
    /**
     The delegate. It is a weak reference.
     */
    internal weak var internal_delegate: RVS_BTDriverDelegate!
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver Sequence Support -
/* ###################################################################################################################################### */
/**
 This sets up the Sequence protocol.
 */
extension RVS_BTDriver: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     We aggregate devices.
     */
    public typealias Element = RVS_BTDriver_DeviceProtocol
    
    /* ################################################################## */
    /**
     This is a public read-only list of devices, masked by the protocol.
     */
    public internal(set) var sequence_contents: [Element] {
        get {
            return internal_device_list
        }
        
        /// We do not allow the list to be modified from outside the driver.
        set {
            _ = newValue    // NOP
        }
    }
}
