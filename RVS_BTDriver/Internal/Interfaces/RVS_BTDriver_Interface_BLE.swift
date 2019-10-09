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

import CoreBluetooth

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Base_Interface_BLE -
/* ###################################################################################################################################### */
/**
 This is an interface for Bluetooth Low Energy (BLE), using CoreBluetooth.
 */
internal class RVS_BTDriver_Interface_BLE: RVS_BTDriver_Base_Interface {
    /* ################################################################## */
    /**
     This will create the SINGLETON, if it is not already created, or simply returns the one we have.
     */
    internal static func makeInterface(queue inQueue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol! {
        if nil == internal_interface {
            let interface = RVS_BTDriver_Interface_BLE()
            internal_interface = interface
            interface.centralManager = CBCentralManager(delegate: interface, queue: inQueue)
        }
        
        return internal_interface
    }
    
    /* ################################################################## */
    /**
     The manager instance associated with this interface. There is only one.
    */
    internal var centralManager: CBCentralManager!
    
    /* ################################################################## */
    /**
     If true, then Bluetooth is available (powered on).
     */
    override internal var isBTAvailable: Bool {
        return centralManager.state == .poweredOn
    }
    
    /* ################################################################## */
    /**
     Start or stop the scan for new peripherals.
     */
    override internal var isScanning: Bool {
        get {
            return centralManager.isScanning
        }
        
        set {
            if !centralManager.isScanning, newValue {
                // Nil is just temporary.
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            } else if centralManager.isScanning {
                centralManager.stopScan()
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Base_Interface_BLE -
/* ###################################################################################################################################### */
/**
 This is an interface for Bluetooth Low Energy (BLE), using CoreBluetooth.
 */
extension RVS_BTDriver_Interface_BLE: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Callback for when the central manager changes state.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
    */
    internal func centralManagerDidUpdateState(_ inCentral: CBCentralManager) {
        assert(inCentral === centralManager, "Central Manager Not Ours!")
        switch inCentral.state {
        case .poweredOff:
            driver?.reportThisError(.bluetoothNotAvailable)
        default:
            driver?.sendInterfaceUpdate(self)
        }
    }
}
