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

public protocol RVS_GTDriverDelegate: class {
    
}

/* ###################################################################################################################################### */
// MARK: - Main Driver Class -
/* ###################################################################################################################################### */
/**
 This class implements the main "skeleton" of the driver API.
 
 The driver will always be a BT Central. It will scan for goTenna devices as peripherals, and instantiate internal instances of RVS_GTDevice
 for each discovered device (in BT Peripheral mode).
 */
public class RVS_GTDriver: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the signal strength range. Optimal is -22.
     */
    private let _RSSI_range = -40..<(-15)
    
    /* ################################################################## */
    /**
     This is the Maximum Transmission Unit size.
     */
    private let _notifyMTU = 244

    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna devices, as represented by instances of RVS_GTDevice.
     */
    private var _devices: [RVS_GTDevice] = []
    
    /* ################################################################## */
    /**
     Our CB Central manager instance.
     */
    private var _centralManager: CBCentralManager!
    
    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We decalre this private, so we force the user to instantiate with a delegate.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Public Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    public weak var delegate: RVS_GTDriverDelegate!

    /* ################################################################################################################################## */
    // MARK: - Public Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The main initializer.
     
     - parameter delegate: The delegate to be used with this instance. It cannot be nil.
     */
    public init(delegate inDelegate: RVS_GTDriverDelegate) {
        super.init()
        delegate = inDelegate
        _centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

/* ###################################################################################################################################### */
// MARK: - Private Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     Tells the Central Manager to start looking for our devices.
     */
    private func _scanForDevices() {
      _centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true as Bool)])
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     This returns our discovered and initialized devices.
     */
    public var devices: [RVS_GTDevice] {
        return _devices
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a device instance for the given peripheral.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns: True, if the driver currently has an instance of the peripheral cached.
     */
    public func containsThisPeripheral(_ inPeripheral: CBPeripheral) -> Bool {
        return devices.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let peripheral = inElement.peripheral else { return inCurrent }
            return inPeripheral == peripheral
        }
    }

    /* ################################################################## */
    /**
     If we have a device that is associated with the given peripheral, then return that device.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns a device for the given peripheral. Nil, if the device is not available.
     */
    public func deviceForThisPeripheral(_ inPeripheral: CBPeripheral) -> RVS_GTDevice! {
        let result = devices.compactMap { (inCurrentDevice) -> RVS_GTDevice? in
            return inCurrentDevice.peripheral == inPeripheral ? inCurrentDevice : nil
        }
        
        // There can only be one...
        guard 1 == result.count else {
            return nil
        }
        
        return result[0]
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our devices, and treat the driver like an Array of devices.
 */
extension RVS_GTDriver: Sequence {
    /* ################################################################## */
    /**
     The element type is our device.
     */
    public typealias Element = RVS_GTDevice

    /* ################################################################## */
    /**
     The iterator is simple, since it is already an Array.
     */
    public typealias Iterator = Array<Element>.Iterator
    
    /* ################################################################## */
    /**
     We just pass the iterator through to the Array.
     
     - returns: The Array iterator for our devices.
     */
    public func makeIterator() -> Iterator {
        return devices.makeIterator()
    }
    
    /* ################################################################## */
    /**
     The number of devices we have. 1-based. 0 is no devices.
     */
    public var count: Int {
        return devices.count
    }
    
    /* ################################################################## */
    /**
     Returns an indexed device.
     
     - parameter inIndex: The 0-based integer index. Must be less than the total count of devices.
     */
    public subscript(_ inIndex: Int) -> RVS_GTDevice {
        precondition(inIndex < count)   // Ah. Ah. Aaah! You didn't say the magic word!
        
        return devices[inIndex]
    }
}

/* ###################################################################################################################################### */
// MARK: - CBCentralManagerDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Called when the manager state changes.
     
     - parameter inCentralManager: The manager instance.
    */
    public func centralManagerDidUpdateState(_ inCentralManager: CBCentralManager) {
        switch inCentralManager.state {
        default:
            ()
        }
    }

    /* ################################################################## */
    /**
     Called when a peripheral is discovered.
     
     - parameter inCentralManager: The manager instance.
     - parameter didDiscover: The peripheral instance that was discovered.
     - parameter advertisementData: The advertisement data the peripheral is providing (if any).
     - parameter rssi: The signal strength (in DB).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDiscover inPeripheral: CBPeripheral, advertisementData inAdvertisementData: [String: Any], rssi inRSSI: NSNumber) {
        // Check to make sure the signal is strong enough.
        guard _RSSI_range.contains(inRSSI.intValue) else { return }
        // Make sure we don't already have this one.
        guard !containsThisPeripheral(inPeripheral) else { return }
        let device = RVS_GTDevice(inPeripheral)
        _devices.append(device)
    }
}
