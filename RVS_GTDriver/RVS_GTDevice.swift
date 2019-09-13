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
public class RVS_GTDevice: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth peripheral instance that is associated with this object.
     */
    private var _peripheral: PeripheralType!
    
    /* ################################################################## */
    /**
     This is the driver instance that "owns" this device instance.
     */
    private weak var _owner: RVS_GTDriver!

    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We decalre this private, so we force the driver to instantiate with a peripheral and an owner.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Public Typealiases
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We alias the peripheral type for mocking.
     */
    public typealias PeripheralType = CBPeripheral
    
    /* ################################################################################################################################## */
    // MARK: - Public Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance.
     
     - parameter inPeripheral: The peripheral to associate with this instance.
     - parameter owner: The driver that "owns" this peripheral. It is a weak reference.
     */
    public init(_ inPeripheral: PeripheralType?, owner inOwner: RVS_GTDriver) {
        super.init()
        _peripheral = inPeripheral
        _owner = inOwner
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
    public var peripheral: PeripheralType! {
        return _peripheral
    }
    
    /* ################################################################## */
    /**
     this is the driver instance that "owns" this device instance.
     */
    public var owner: RVS_GTDriver {
        return _owner
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
