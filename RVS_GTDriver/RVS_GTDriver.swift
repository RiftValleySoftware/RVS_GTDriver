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
// MARK: - Main Driver Class -
/* ###################################################################################################################################### */
/**
 This class implements the main "skeleton" of the driver API.
 
 The driver will always be a BT Central. It will scan for goTenna devices as peripherals, and instantiate internal instances of RVS_GTDevice
 for each discovered device (in BT Peripheral mode).
 */
open class RVS_GTDriver: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    private var _devices: [RVS_GTDevice] = []
    
    /* ################################################################################################################################## */
    // MARK: - Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override init() {
        
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Enums
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
}

/* ###################################################################################################################################### */
// MARK: - Calculated Instance Properties
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     This returns our discovered and initialized devices.
     */
    private var devices: [RVS_GTDevice] {
        return _devices
    }
}

/* ###################################################################################################################################### */
// MARK: - Central Manager Delegate Handler
/* ###################################################################################################################################### */
extension RVS_GTDriver: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
    */
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
}
