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
// MARK: - Main Driver RVS_GTDriverDelegate Protocol -
/* ###################################################################################################################################### */
/**
 A delegate object is required to instantiate an instance of the driver class.
 
 This is the delegate protocol.
 
 Protocols are an important part of this driver. The driver protocol is required. Protocols for devices and services are optional.
 
 Each protocol has only one required method: an error receiver. We use an enum that wraps errors, and is returned in the handler.
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
    func gtDriver(_ driver: RVS_GTDriver, errorEncountered: RVS_GTDriver.Errors)

    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a peripheral is discovered, and before a device instance is instantiated.
     
     You may return false, if you want to prevent the peripheral from being loaded. This will not remove the peripheral from discovery; it only prevents it from being loaded.
     
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
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    func gtDriverStatusUpdate(_ driver: RVS_GTDriver)
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
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.

     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    func gtDriverStatusUpdate(_ driver: RVS_GTDriver) { }
}

/* ###################################################################################################################################### */
// MARK: - Main Driver Class -
/* ###################################################################################################################################### */
/**
 This class implements the main "skeleton" of the driver API.
 
 The driver will always be a BT Central. It will scan for goTenna devices as peripherals, and instantiate internal instances of RVS_GTDevice
 for each discovered peripheral device.
 
 Since this receives delegate callbacks from CB, it must derive from NSObject.
 
 This driver has two modes: Not scanning, in which case it does not discover new devices, but the devices it does have may still be active and updating, and
 Scanning, in which case, it looks for goTenna devices.
 
 If it finds a device, it adds it to a "Holding Pen," where it lives until some basic information has been read; namely, the Device Info service.
 
 After all that has been gathered, the device is considered "shiny," and gets added to our main Array, and then it will ignore the same device, if that device shows up again in discovery.
 
 The idea is to build up an object model of the goTenna devices, and represent them to the API consumer as simply as possible.
 
 It is important that the consumer provide delegates to the driver, device and service instances. Most of the action happens in delegate callbacks.
 
 Only the entities in the last extension (and the initializer) should be considered useful for API consumers.
 
 You will see that internal methods and properties are explicitly marked as "internal." This is to help clarify their scope.
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
    
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
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
    
    /* ################################################################## */
    /**
     This is "temporary storage" for devices that are still undergoing validation before being added.
     */
    private var _holdingPen: [RVS_GTDevice] = []
    
    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the user to instantiate with a delegate.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Public Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The main initializer.
     
     - parameter delegate: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
     - parameter queue: This is a desired queue for the CB manager to operate from. It is optional, and default is nil (main queue).
     */
    public init(delegate inDelegate: RVS_GTDriverDelegate, queue inQueue: DispatchQueue? = nil) {
        super.init()
        _delegate = inDelegate
        _centralManager = CBCentralManager(delegate: self, queue: inQueue)
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Sequence Support Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna devices, as represented by instances of RVS_GTDevice.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.
     */
    public var sequence_contents: [RVS_GTDevice] = []
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
        // If we are not powered on, then we report an error, and stop.
        guard CBManagerState.poweredOn == _centralManager.state else {
            reportThisError(.bluetoothNotAvailable)
            return
        }

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
    
    /* ################################################################## */
    /**
     Add the device to our main list.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func addDeviceToList(_ inDevice: RVS_GTDevice) {
        #if DEBUG
            print("Adding Device: \(String(describing: inDevice)) To Our List at index \(count).")
        #endif
        // Remove from the "holding pen."
        if let index = _holdingPen.firstIndex(where: { return $0.peripheral == inDevice.peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        sequence_contents.append(inDevice)
        // Let the delegate know that it now has a new device.
        delegate.gtDriver(self, newDeviceAdded: inDevice)
        // Tell the device to report that it was successfully connected.
        inDevice.reportSuccessfulConnection()
        // And this rates a status update.
        delegate.gtDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     This will remove the given device from either the main list, or the holding pen; depending on where it is.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func removeDeviceFromDriver(_ inDevice: RVS_GTDevice) {
        #if DEBUG
            print("Removing Device: \(String(describing: inDevice)).")
        #endif
        if let index = _holdingPen.firstIndex(where: { return $0.peripheral == inDevice.peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        
        if let index = sequence_contents.firstIndex(where: { return $0.peripheral == inDevice.peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Main Cache at index \(index).")
            #endif
            sequence_contents.remove(at: index)
        }
        // And this rates a status update.
        delegate.gtDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     This simply returns the 0-based index of the given device in our Array of devices.
     
     - returns the 0-based index of the device. Nil, if not available.
     */
    internal func indexOfThisDevice(_ inDevice: RVS_GTDevice) -> Int! {
        return sequence_contents.firstIndex(of: inDevice)
    }
    
    /* ################################################################## */
    /**
     Deletes all cached peripherals.
     */
    internal func clearCachedDevices() {
        sequence_contents = []
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver: RVS_GTDriverTools {
    /* ################################################################## */
    /**
     The buck stops here.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_GTDriver.Errors) {
        delegate.gtDriver(self, errorEncountered: inError)
    }
}

/* ###################################################################################################################################### */
// MARK: - CBCentralManagerDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a device instance for the given peripheral.
     This also checks our "holding pen."
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns: True, if the driver currently has an instance of the peripheral cached.
     */
    internal func containsThisPeripheral(_ inPeripheral: CBPeripheral) -> Bool {
        var ret: Bool = sequence_contents.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let peripheral = inElement.peripheral else { return inCurrent }
            return inPeripheral == peripheral
        }
        
        if !ret {
            ret = _holdingPen.reduce(false) { (inCurrent, inElement) -> Bool in
                guard !inCurrent, let peripheral = inElement.peripheral else { return inCurrent }
                return inPeripheral == peripheral
            }
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     Return the device from our cached Array that corresponds to the given peripheral.
     This also checks our "holding pen."
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inPeripheral: The peripheral we are looking for.
     - returns: The device. Nil, if not found.
     */
    internal func deviceForThisPeripheral(_ inPeripheral: CBPeripheral) -> RVS_GTDevice? {
        for device in self where inPeripheral == device.peripheral {
            return device
        }
        
        for device in _holdingPen where inPeripheral == device.peripheral {
            return device
        }

        return nil
    }

    /* ################################################################## */
    /**
     Called when the manager state changes. We simply use this to call the delegate to check the state.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inCentralManager: The manager instance.
    */
    public func centralManagerDidUpdateState(_ inCentralManager: CBCentralManager) {
        delegate.gtDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     Called when a peripheral connects.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inCentralManager: The manager instance.
     - parameter didConnect: The peripheral that was successfully connected.
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didConnect inPeripheral: CBPeripheral) {
        if let device = deviceForThisPeripheral(inPeripheral) {
            device.reportSuccessfulConnection()
        } else {
            reportThisError(.connectionAttemptFailedNoDevice)
        }
        delegate.gtDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     Called when the manager changes state.
     
     - parameter inCentralManager: The manager instance.
     - parameter didFailToConnect: The peripheral that was not successfully connected.
     - parameter error: Any error that may have occurred. May be nil (no error).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didFailToConnect inPeripheral: CBPeripheral, error inError: Error?) {
        reportThisError(.connectionAttemptFailed(error: inError))
        delegate.gtDriverStatusUpdate(self)
    }

    /* ################################################################## */
    /**
     Called when a peripheral disconnects.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inCentralManager: The manager instance.
     - parameter didDisconnectPeripheral: The peripheral that was successfully disconnected.
     - parameter error: Any error that may have occurred. May be nil (no error).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDisconnectPeripheral inPeripheral: CBPeripheral, error inError: Error?) {
        if let error = inError {
            reportThisError(.disconnectionAttemptFailed(error: error))
        } else if let device = deviceForThisPeripheral(inPeripheral) {
            device.reportDisconnection(inError)
            delegate.gtDriverStatusUpdate(self)
        }
    }

    /* ################################################################## */
    /**
     Called when a peripheral is discovered.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.
     
     - parameter inCentralManager: The manager instance.
     - parameter didDiscover: The peripheral instance that was discovered.
     - parameter advertisementData: The advertisement data the peripheral is providing (if any).
     - parameter rssi: The signal strength (in DB).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDiscover inPeripheral: CBPeripheral, advertisementData inAdvertisementData: [String: Any], rssi inRSSI: NSNumber) {
        // Check to make sure the signal is strong enough.
        guard _RSSI_range.contains(inRSSI.intValue) else {
            #if DEBUG
                print("Signal out of range (\(inRSSI.intValue)) for peripheral: \(inPeripheral).")
            #endif
            return
        }
        // Make sure we don't already have this one.
        guard !containsThisPeripheral(inPeripheral) else { return }
        // Make sure that we are supposed to add this.
        let shouldInstall = delegate.gtDriver(self, peripheralDiscovered: inPeripheral)
        if shouldInstall {
            #if DEBUG
                print("\n***> New Peripheral To Be Installed:")
                print("\tdidDiscover: \(String(describing: inPeripheral))\n")
                print("\t***\n")
                print("\tadvertisementData: \(String(describing: inAdvertisementData))\n")
                print("\t***\n")
                print("\trssi: \(String(describing: inRSSI))")
                print("<***\n")
            #endif
            // If so, we simply create the new device and add it to our holding pen.
            _holdingPen.append(RVS_GTDevice(inPeripheral, owner: self))
        }
        #if DEBUG
            if !shouldInstall {
                print("Install of discovered peripheral canceled by API user.")
            }
        #endif
    }
}

/* ###################################################################################################################################### */
// MARK: - This is What We Tell the Kids -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the driver. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 One other thing about this class, is that it conforms to Sequence, so you can iterate through it for devices, or access devices as subscripts.
 */
extension RVS_GTDriver {
    /* ################################################################################################################################## */
    // MARK: - Error Enums -
    /* ################################################################################################################################## */
    /**
     These are the various errors that can be returned by this class.
     The enum is designed to provide keys for use by localization. If you access the "localizedDescription" calculated property, you will get a consistent string.
     */
    public enum Errors: Error {
        /* ################################################################## */
        /**
         This is returned if the manager can't power on.
         */
        case bluetoothNotAvailable
        
        /* ################################################################## */
        /**
         This is returned if we cannot connect to the device.
         The associated value is any error that occurred.
         */
        case connectionAttemptFailed(error: Error?)
        
        /* ################################################################## */
        /**
         This is returned if we connected, but no device was available. This should never happen.
         */
        case connectionAttemptFailedNoDevice

        /* ################################################################## */
        /**
         This is returned if we cannot disconnect from the device.
         The associated value is any error that occurred.
         */
        case disconnectionAttemptFailed(error: Error?)
        
        /* ################################################################## */
        /**
         This is a "catchall" error for a disconnection issue
         */
        case unknownDisconnectionError

        /* ################################################################## */
        /**
         This is a "catchall" error for peripheral discovery
         The associated value is any error that occurred.
         */
        case unknownPeripheralDiscoveryError(error: Error?)
        
        /* ################################################################## */
        /**
         This means that we did not get a characteristic value
         */
        case characteristicValueMissing
        
        /* ################################################################## */
        /**
         This is a "catchall" error for characteristics discovery
         The associated value is any error that occurred.
         */
        case unknownCharacteristicsDiscoveryError(error: Error?)
        
        /* ################################################################## */
        /**
         This is a "catchall" error for characteristics value read
         The associated value is any error that occurred.
         */
        case unknownCharacteristicsReadValueError(error: Error?)

        /* ################################################################## */
        /**
         This is a "catchall" error.
         The associated value is any error that occurred.
         */
        case unknownError(error: Error?)

        /* ################################################################## */
        /**
         The localized description is a simple slug that can be used to key a client-supplied message.
         It is a very simple class.enum.case String.
         */
        public var localizedDescription: String {
            return "RVS_GTDriver.Error.\(String(describing: self))"
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Public Calculated Instance Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance.
     */
    public var delegate: RVS_GTDriverDelegate {
        return _delegate
    }
    
    /* ################################################################## */
    /**
     This is KVO-observable.
     Returns true, if we are currently scanning for new CB peripherals.
     */
    @objc dynamic public var isScanning: Bool {
        get {
            return _centralManager.isScanning
        }
        
        set {
            if !newValue {
                _centralManager.stopScan()
            } else {
                // If we are not powered on, then we report an error, and stop.
                guard CBManagerState.poweredOn == _centralManager.state else {
                    reportThisError(.bluetoothNotAvailable)
                    return
                }
                // We search for any devices that advertise the goTenna proprietary service.
                _centralManager.scanForPeripherals(withServices: [CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary.rawValue)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true as Bool)])
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is KVO-observable. READ-ONLY.
     Returns true, if the bluetooth system is valid.
     */
    @objc dynamic public var isBluetoothAvailable: Bool {
        return .poweredOn == _centralManager.state
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our devices, and treat the driver like an Array of devices.
 */
extension RVS_GTDriver: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     The element type is our device.
     */
    public typealias Element = RVS_GTDevice
}
