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
// MARK: - Main Driver Class -
/* ###################################################################################################################################### */
/**
 This class implements the main "skeleton" of the driver API.
 
 This driver has two modes: Not scanning, in which case it does not discover new devices, but the devices it does have may still be active and updating, and
 Scanning, in which case, it looks for goTenna devices.
 
 If it finds a device, it adds it to a "Holding Pen," where it lives until some basic information has been read; namely, the Device Info service, and the proprietary goTenna service.
 
 After all that has been gathered, the device is considered "shiny," and gets added to our main Array, and then it will ignore the same device, if that device shows up again in discovery.
 
 The idea is to build up an object model of the goTenna devices, and represent them to the API consumer as simply as possible.
 
 It is important that the consumer provide delegates to the driver, device and service instances. Most of the action happens in delegate callbacks.
 
 Only the entities in the [RVS_BLEDriver_Public.swift](https://github.com/RiftValleySoftware/RVS_BLEDriver/blob/master/RVS_BLEDriver/RVS_BLEDriver_Public.swift) extension should be considered useful for API consumers.
 
 You may also treat the instance as [a Sequence](https://developer.apple.com/documentation/swift/sequence), with Element being instances of RVS_BLEDevice (goTenna devices).
 You can access them directly with subscripts (count returns the number of devices).
 
 You will see that internal methods and properties are explicitly marked as "internal." This is to help clarify their scope.
 
 One of the goals of this driver is to abstract the [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) stuff from the consumer, so it can be swapped out with things like USB or WiFi.
 
 Internally, the driver will always run a [CBCentralManager](https://developer.apple.com/documentation/corebluetooth/cbcentralmanager) instance.
 It will scan for goTenna devices as [peripherals](https://developer.apple.com/documentation/corebluetooth/cbperipheral), and instantiate internal instances of [RVS_BLEDevice](https://github.com/RiftValleySoftware/RVS_BLEDriver/blob/master/RVS_BLEDriver/RVS_BLEDevice.swift)
 for each discovered peripheral device.
 
 Since this receives delegate callbacks from [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth), it must derive from [NSObject](https://developer.apple.com/documentation/objectivec/1418956-nsobject?language=occ).
*/
public class RVS_BLEDriver: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Internal Static Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains our device handlers.
     */
    static internal let handlers: [RVS_BLEDevice_DeviceSpec] = [
        /// Handle goTenna devices.
        RVS_BLEDevice_DeviceSpec_goTenna()
    ]
    
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is "temporary storage" for devices that are still undergoing validation before being added.
     */
    private var _holdingPen: [RVS_BLEDevice] = []
    
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna devices, as represented by instances of RVS_BLEDevice.
     */
    private var _sequence_contents: [RVS_BLEDevice] = []

    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the user to instantiate with a delegate.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the signal strength range. Optimal is -50.
     */
    internal let RSSI_range = -80..<(-30)
    
    /* ################################################################## */
    /**
     This is the Maximum Transmission Unit size.
     */
    internal let notifyMTU = 244
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    internal var internal_delegate: RVS_BLEDriverDelegate!
    
    /* ################################################################## */
    /**
     Our CB Central manager instance.
     */
    internal var internal_centralManager: CBCentralManager!
    
    /* ################################################################## */
    /**
     This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.
     If true, it could adversely affect battery life. Default is false.
     */
    internal var internal_AllowDuplicatesInBLEScan: Bool = false
    
    /* ################################################################## */
    /**
     This is a flag that tells us to remain connected continuously, until explicitly disconnected by the user. Default is false.
     */
    internal var internal_stayConnected: Bool = false
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver {
    /* ################################################################## */
    /**
     This forces a device update callback to be sent to the delegate.
     */
    internal func sendDeviceUpdateToDelegegate() {
        delegate.gtDriverStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     Connect the given device.
     
     - parameter inDevice: The deivice we want connected.
     */
    internal func connectDevice(_ inDevice: RVS_BLEDevice) {
        // If we are not powered on, then we report an error, and stop.
        guard CBManagerState.poweredOn == internal_centralManager.state else {
            reportThisError(.bluetoothNotAvailable)
            return
        }

        if .disconnected == inDevice.internal_peripheral.state { // Must be completely disconnected
            internal_centralManager.connect(inDevice.internal_peripheral, options: nil)
        }
    }

    /* ################################################################## */
    /**
     Disconnect the given device.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func disconnectDevice(_ inDevice: RVS_BLEDevice) {
        if .disconnected != inDevice.internal_peripheral.state { // We can disconnect at any stage.
            internal_centralManager.cancelPeripheralConnection(inDevice.internal_peripheral)
        }
    }
    
    /* ################################################################## */
    /**
     Add the device to our main list.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func addDeviceToList(_ inDevice: RVS_BLEDevice) {
        #if DEBUG
            print("Adding Device: \(String(describing: inDevice)) To Our List at index \(count).")
        #endif
        // Remove from the "holding pen."
        if let index = _holdingPen.firstIndex(where: { return $0.internal_peripheral == inDevice.internal_peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        
        _sequence_contents.append(inDevice)
        // Let the delegate know that it now has a new device.
        delegate.gtDriver(self, newDeviceAdded: inDevice)
        // Tell the device to report that it was successfully connected.
        inDevice.reportSuccessfulConnection()
        // And this rates a status update.
        sendDeviceUpdateToDelegegate()
    }
    
    /* ################################################################## */
    /**
     This will remove the given device from either the main list, or the holding pen; depending on where it is.
     
     - parameter inDevice: The deivice we want disconnected.
     */
    internal func removeDeviceFromDriver(_ inDevice: RVS_BLEDevice) {
        #if DEBUG
            print("Removing Device: \(String(describing: inDevice)).")
        #endif
        // Make sure that we are not connected.
        internal_centralManager.cancelPeripheralConnection(inDevice.internal_peripheral)

        if let index = _holdingPen.firstIndex(where: { return $0.internal_peripheral == inDevice.internal_peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        
        if let index = sequence_contents.firstIndex(where: { return $0.internal_peripheral == inDevice.internal_peripheral }) {
            #if DEBUG
                print("Removing Device: \(String(describing: inDevice)) From Main Cache at index \(index).")
            #endif
            _sequence_contents.remove(at: index)
        }
        // And this rates a status update.
        sendDeviceUpdateToDelegegate()
    }
    
    /* ################################################################## */
    /**
     This simply returns the 0-based index of the given device in our Array of devices.
     
     - returns the 0-based index of the device. Nil, if not available.
     */
    internal func indexOfThisDevice(_ inDevice: RVS_BLEDevice) -> Int! {
        return sequence_contents.firstIndex(of: inDevice)
    }
    
    /* ################################################################## */
    /**
     Deletes all cached peripherals.
     */
    internal func clearCachedDevices() {
        _sequence_contents = []
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver: RVS_BLEDriverTools {
    /* ################################################################## */
    /**
     The buck stops here.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_BLEDriver.Errors) {
        delegate.gtDriver(self, errorEncountered: inError)
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our devices, and treat the driver like an Array of devices.
 */
extension RVS_BLEDriver: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     :nodoc: The element type is our device.
     */
    public typealias Element = RVS_BLEDevice
    
    /* ################################################################## */
    /**
     :nodoc: This is an Array of our discovered and initialized goTenna devices, as represented by instances of RVS_BLEDevice.
     READ-ONLY
     */
    public var sequence_contents: [RVS_BLEDevice] {
        get {
            return _sequence_contents
        }
        
        set {
            _ = newValue    // NOP
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - CBCentralManagerDelegate Methods (NOT FOR EXTERNAL USE) -
/* ###################################################################################################################################### */
extension RVS_BLEDriver: CBCentralManagerDelegate {
    /* ################################################################################################################################## */
    // MARK: - Internal Utility Methods
    /* ################################################################################################################################## */
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
            guard !inCurrent, let peripheral = inElement.internal_peripheral else { return inCurrent }
            return inPeripheral == peripheral
        }
        
        if !ret {
            ret = _holdingPen.reduce(false) { (inCurrent, inElement) -> Bool in
                guard !inCurrent, let peripheral = inElement.internal_peripheral else { return inCurrent }
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
    internal func deviceForThisPeripheral(_ inPeripheral: CBPeripheral) -> RVS_BLEDevice? {
        for device in self where inPeripheral == device.internal_peripheral {
            return device
        }
        
        for device in _holdingPen where inPeripheral == device.internal_peripheral {
            return device
        }

        return nil
    }

    /* ################################################################################################################################## */
    // MARK: - Public CBManager Callbacks
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     :nodoc: Called when the manager state changes. We simply use this to call the delegate to check the state.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inCentralManager: The manager instance.
    */
    public func centralManagerDidUpdateState(_ inCentralManager: CBCentralManager) {
        sendDeviceUpdateToDelegegate()
    }
    
    /* ################################################################## */
    /**
     :nodoc: Called when a peripheral connects.
     
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
        sendDeviceUpdateToDelegegate()
    }
    
    /* ################################################################## */
    /**
     :nodoc: Called when the manager changes state.
     
     - parameter inCentralManager: The manager instance.
     - parameter didFailToConnect: The peripheral that was not successfully connected.
     - parameter error: Any error that may have occurred. May be nil (no error).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didFailToConnect inPeripheral: CBPeripheral, error inError: Error?) {
        reportThisError(.connectionAttemptFailed(error: inError))
        sendDeviceUpdateToDelegegate()
    }

    /* ################################################################## */
    /**
     :nodoc: Called when a peripheral disconnects.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inCentralManager: The manager instance.
     - parameter didDisconnectPeripheral: The peripheral that was successfully disconnected.
     - parameter error: Any error that may have occurred. May be nil (no error).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDisconnectPeripheral inPeripheral: CBPeripheral, error inError: Error?) {
        if  let error = inError {
            let nsError = error as NSError
            if nsError.domain == "CBErrorDomain", 7 == nsError.code {   // This is a special case, where we sometimes get a standard "they disconnected" error.
                if let device = deviceForThisPeripheral(inPeripheral) {
                    device.reportDisconnection(inError)
                    sendDeviceUpdateToDelegegate()
                }
            } else {
                reportThisError(.disconnectionAttemptFailed(error: error))
            }
        } else if let device = deviceForThisPeripheral(inPeripheral) {
            device.reportDisconnection(inError)
            sendDeviceUpdateToDelegegate()
        }
    }

    /* ################################################################## */
    /**
     :nodoc: Called when a peripheral is discovered.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.
     
     - parameter inCentralManager: The manager instance.
     - parameter didDiscover: The peripheral instance that was discovered.
     - parameter advertisementData: The advertisement data the peripheral is providing (if any).
     - parameter rssi: The signal strength (in DB).
    */
    public func centralManager(_ inCentralManager: CBCentralManager, didDiscover inPeripheral: CBPeripheral, advertisementData inAdvertisementData: [String: Any], rssi inRSSI: NSNumber) {
        // Check to make sure the signal is strong enough.
        guard RSSI_range.contains(inRSSI.intValue) else {
            #if DEBUG
                print("Signal out of range (\(inRSSI.intValue)) for peripheral: \(inPeripheral).")
            #endif
            // Make sure that we remove the device, if we have it.
            if let device = deviceForThisPeripheral(inPeripheral) {
                device.deleteThisDevice()
            }
            return
        }
//        // Make sure we don't already have this one.
//        if !containsThisPeripheral(inPeripheral) {
//            // Make sure that we are supposed to add this.
//            let shouldInstall = delegate.gtDriver(self, errorEncountered: inPeripheral)
//            if shouldInstall {
//                #if DEBUG
//                    print("\n***> New Peripheral To Be Installed:")
//                    print("\tdidDiscover: \(String(describing: inPeripheral))\n")
//                    print("\t***\n")
//                    print("\tadvertisementData: \(String(describing: inAdvertisementData))\n")
//                    print("\t***\n")
//                    print("\trssi: \(String(describing: inRSSI))")
//                    print("<***\n")
//                #endif
//                // If so, we simply create the new device and add it to our holding pen.
//                _holdingPen.append(RVS_BLEDevice(inPeripheral, owner: self, remainConnected: stayConnected))
//            }
//            #if DEBUG
//                if !shouldInstall {
//                    print("Install of discovered peripheral canceled by API user.")
//                }
//            #endif
//        }
    }
}
