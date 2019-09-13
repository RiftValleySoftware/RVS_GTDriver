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
import CoreBluetooth

/* ###################################################################################################################################### */
// MARK: - Individual Device Instance Class -
/* ###################################################################################################################################### */
/**
 This class implements a single discovered goTenna device (in peripheral mode).
 */
open class RVS_GTDevice: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth peripheral instance that is associated with this object.
     */
    private var _peripheral: CBPeripheral!
    
    /* ################################################################################################################################## */
    // MARK: - Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance.
     
     - parameter inPeripheral: The peripheral to associate with this instance.
     */
    init(_ inPeripheral: CBPeripheral?) {
        _peripheral = inPeripheral
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_GTDevice {
    /* ################################################################## */
    /**
     This returns our peripheral instance.
     */
    public var peripheral: CBPeripheral! {
        return _peripheral
    }
}

/* ###################################################################################################################################### */
// MARK: - CBPeripheralDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice: CBPeripheralDelegate {
    /* ################################################################## */
    /**
    */
}
