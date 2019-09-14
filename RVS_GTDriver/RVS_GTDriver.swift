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
// MARK: - Main Driver RVS_GTDriverDelegate Protocol -
/* ###################################################################################################################################### */
/**
 A delegate object is required to instantiate an instance of the driver class.
 
 This is the delegate protocol.
 */
public protocol RVS_GTDriverDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by the main driver.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDriver(_ driver: RVS_GTDriver, errorEncountered: Error)

    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a peripheral is discovered, and before a device instance is instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread. If not specified, the device will always be added.
     
     - parameter driver: The driver instance calling this.
     - parameter peripheralDiscovered: The peripheral object.
     - returns: True, if the peripheral is to be instantiated.
     */
    func gtDriver(_ driver: RVS_GTDriver, peripheralDiscovered: CBPeripheral) -> Bool
    
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    func gtDriver(_ driver: RVS_GTDriver, newDeviceAdded: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object.
     */
    func gtDriver(_ driver: RVS_GTDriver, deviceWillBeRemoved: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object. It will not be viable after this call.
     */
    func gtDriver(_ driver: RVS_GTDriver, deviceWasRemoved: RVS_GTDevice)
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_GTDriverDelegate Protocol Extension -
/* ###################################################################################################################################### */
/**
 These defaults allow a number of methods to be optional.
 */
extension RVS_GTDriverDelegate {
    /* ################################################################## */
    /**
     Called when a peripheral is discovered, and before a device instance is instantiated.
     
     - parameter driver: The driver instance calling this.
     - parameter peripheralDiscovered: The peripheral object.
     - returns: True.
     */
    public func gtDriver(_ driver: RVS_GTDriver, peripheralDiscovered: CBPeripheral) -> Bool {
        return true
    }
    
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.

     - parameter driver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    public func gtDriver(_ driver: RVS_GTDriver, newDeviceAdded: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object.
     */
    public func gtDriver(_ driver: RVS_GTDriver, deviceWillBeRemoved: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object. It will not be viable after this call.
     */
    public func gtDriver(_ driver: RVS_GTDriver, deviceWasRemoved: RVS_GTDevice) { }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver Class -
/* ###################################################################################################################################### */
/**
 This class implements the main "skeleton" of the driver API.
 
 The driver will always be a BT Central. It will scan for goTenna devices as peripherals, and instantiate internal instances of RVS_GTDevice
 for each discovered peripheral device.
 
 Since this receives delegate callbacks from CB, it must derive from NSObject.
 */
public class RVS_GTDriver: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the signal strength range. Optimal is -50.
     */
    private let _RSSI_range = -80..<(-40)
    
    /* ################################################################## */
    /**
     This is the Maximum Transmission Unit size.
     */
    private let _notifyMTU = 244
    
    /* ################################################################## */
    /**
     This is the service UUID that goTenna uses to advertise. We look for this in our scan.
     */
    private let gtServiceUUID = CBUUID(string: "1276AAEE-DF5E-11E6-BF01-FE55135034F3")

    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna devices, as represented by instances of RVS_GTDevice.
     */
    private var _contents: [RVS_GTDevice] = []
    
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    private var _delegate: RVS_GTDriverDelegate!
    
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
     We declare this private, so we force the user to instantiate with a delegate.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Public Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The main initializer.
     
     - parameter delegate: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
     */
    public init(delegate inDelegate: RVS_GTDriverDelegate) {
        super.init()
        _delegate = inDelegate
        _centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Class Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     This is used to see whether or not we are running under unit tests.
     
     - returns: True, if we are currently in a unit test.
     */
    internal class var isRunningUnitTests: Bool {
        // Searches for an environment setting that describes the XCTest path (only present under unit test, and always present when under unit test).
        return nil != ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    
    /* ################################################################## */
    /**
     Connect the given device.
     
     - parameter inDevice: The deivice we want connected.
     */
    internal func connectDevice(_ inDevice: RVS_GTDevice) {
        if .disconnected == inDevice.peripheral.state { // Must be completely disconnected
            _centralManager.connect(inDevice.peripheral, options: nil)
        }
    }
    
    /* ################################################################## */
    /**
     Disconnect the given device.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func disconnectDevice(_ inDevice: RVS_GTDevice) {
        if .disconnected != inDevice.peripheral.state { // We can disconnect at any stage.
            _centralManager.cancelPeripheralConnection(inDevice.peripheral)
        }
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
        return _contents
    }
    
    /* ################################################################## */
    /**
     This is our delegate instance.
     */
    public var delegate: RVS_GTDriverDelegate {
        return _delegate
    }
    
    /* ################################################################## */
    /**
     This is true, if we are currently scanning for new CB peripherals.
     */
    public var isScanning: Bool {
        get {
            return _centralManager.isScanning
        }
        
        set {
            if !newValue {
                _centralManager.stopScan()
            } else {
                _centralManager.scanForPeripherals(withServices: [gtServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true as Bool)])
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver {
    /* ################################################################## */
    /**
     This simply returns the 0-based index of the given device in our Array of devices.
     
     - returns the 0-based index of the device. Nil, if not available.
     */
    public func indexOfThisDevice(_ inDevice: RVS_GTDevice) -> Int! {
        return devices.firstIndex(of: inDevice)
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
     
     - returns: The Array iterator for our characateristics.
     */
    public func makeIterator() -> Iterator {
        return _contents.makeIterator()
    }
    
    /* ################################################################## */
    /**
     The number of characteristics we have. 1-based. 0 is no characteristics.
     */
    public var count: Int {
        return _contents.count
    }
    
    /* ################################################################## */
    /**
     Returns an indexed characteristic.
     
     - parameter inIndex: The 0-based integer index. Must be less than the total count of characteristics.
     */
    public subscript(_ inIndex: Int) -> Element {
        precondition((0..<count).contains(inIndex))   // Standard precondition. Index needs to be 0 or greater, and less than the count.
        
        return _contents[inIndex]
    }
}

/* ###################################################################################################################################### */
// MARK: - CBCentralManagerDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a device instance for the given peripheral.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns: True, if the driver currently has an instance of the peripheral cached.
     */
    internal func containsThisPeripheral(_ inPeripheral: CBPeripheral) -> Bool {
        return devices.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let peripheral = inElement.peripheral else { return inCurrent }
            return inPeripheral == peripheral
        }
    }

    /* ################################################################## */
    /**
     Return the device from our cached Array that corresponds to the given peripheral.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns: The device. Nil, if not found.
     */
    internal func deviceForThisPeripheral(_ inPeripheral: CBPeripheral) -> RVS_GTDevice? {
        for device in devices where inPeripheral == device.peripheral {
            return device
        }
        
        return nil
    }

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
     Called when a peripheral connects.
     
     - parameter inCentralManager: The manager instance.
     - parameter didConnect: The peripheral that was successfully connected.
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didConnect inPeripheral: CBPeripheral) {
        if let device = deviceForThisPeripheral(inPeripheral) {
            device.reportSuccessfulConnection()
        }
    }
    
    /* ################################################################## */
    /**
     Called when a peripheral disconnects.
     
     - parameter inCentralManager: The manager instance.
     - parameter didDisconnectPeripheral: The peripheral that was successfully disconnected.
     - parameter error: Any error that may have occurred. May be nil (no error).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDisconnectPeripheral inPeripheral: CBPeripheral, error inError: Error?) {
        if let device = deviceForThisPeripheral(inPeripheral) {
            device.reportDisconnection(inError)
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
        // Make sure that we are supposed to add this.
        if delegate.gtDriver(self, peripheralDiscovered: inPeripheral) {
            #if DEBUG
                print("\n***> New Peripheral To Be Installed:")
                print("\tdidDiscover: \(String(describing: inPeripheral))\n")
                print("\t***\n")
                print("\tadvertisementData: \(String(describing: inAdvertisementData))\n")
                print("\t***\n")
                print("\trssi: \(String(describing: inRSSI))")
                print("<***\n")
            #endif
            // If so, we simply create the new device and add it to our list.
            let newDevice = RVS_GTDevice(inPeripheral, owner: self)
            _contents.append(newDevice)
            // Call our delegate to tell it about the new device.
            delegate.gtDriver(self, newDeviceAdded: newDevice)
        }
    }
}
