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
// MARK: - RVS_GTDeviceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol.
 */
public protocol RVS_GTDeviceDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDevice(_ device: RVS_GTDevice, errorEncountered: RVS_GTDriver.Errors)
    
    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     */
    func gtDeviceWillBeRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    func gtDeviceWasBeRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     */
    func gtDeviceWasConnected(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?)
    
    /* ################################################################## */
    /**
     Called when a device discovers a new service
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter discoveredService: The discovered service.
     */
    func gtDevice(_ device: RVS_GTDevice, discoveredService: RVS_GTService)
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDeviceDelegate Protocol Extension (Optional Methods) -
/* ###################################################################################################################################### */
extension RVS_GTDeviceDelegate {
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     */
    public func gtDeviceWillBeRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    public func gtDeviceWasBeRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     */
    public func gtDeviceWasConnected(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?) { }

    /* ################################################################## */
    /**
     Called when a device discovers a new service
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter discoveredService: The discovered service.
     */
    public func gtDevice(_ device: RVS_GTDevice, discoveredService: RVS_GTService) { }
}

/* ###################################################################################################################################### */
// MARK: - Individual Device Instance Class -
/* ###################################################################################################################################### */
/**
 This class implements a single discovered goTenna device (in peripheral mode).
 
 Since this receives delegate callbacks from CB, it must derive from NSObject.
 */
public class RVS_GTDevice: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth peripheral instance that is associated with this object.
     */
    private var _peripheral: CBPeripheral!
    
    /* ################################################################## */
    /**
     This is the driver instance that "owns" this device instance.
     */
    private weak var _owner: RVS_GTDriver!
    
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    private var _delegate: RVS_GTDeviceDelegate!
    
    /* ################################################################## */
    /**
     This is a (yuck) semaphore, indicating that the initial device info connection was made.
     */
    private var _initialized = false
    
    /* ################################################################## */
    /**
     This is a "holding pen" for services that have been discovered, but not yet initialized. They need to be kept around, in order to remain viable.
     */
    private var _holdingPen: [RVS_GTService] = []
    
    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the driver to instantiate with a peripheral and an owner.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance and an owner.
     
     - parameter inPeripheral: The peripheral to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The driver that "owns" this device. It is a weak reference. It cannot be nil or omitted.
     - parameter delegate: The RVS_GTDeviceDelegate instance. This is a weak reference, but is optional, and can be omitted
     */
    internal init(_ inPeripheral: CBPeripheral, owner inOwner: RVS_GTDriver, delegate inDelegate: RVS_GTDeviceDelegate! = nil) {
        super.init()
        _peripheral = inPeripheral
        _peripheral.delegate = self
        _owner = inOwner
        _delegate = inDelegate
        isConnected = true  // We start by connecting, so we can get information.
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Sequence Support Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna services, as represented by instances of RVS_GTService.
     */
    public var sequence_contents: [RVS_GTService] = []
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice {
    /* ################################################################## */
    /**
     Called to send a connection message to the delegate for this device.
     */
    internal func reportSuccessfulConnection() {
        if !_initialized {  // If we have not yet been initialized, then we straightaway start looking for our device information, which is now available.
            discoverServices([CBUUID(string: "180A")])
        } else {
            delegate?.gtDeviceWasConnected(self)
        }
    }
    
    /* ################################################################## */
    /**
     Called to send a disconnection event to the device's delegate.
     
     - parameter inError: Any error that may have occurred. It is passed directly to the delegate.
     */
    internal func reportDisconnection(_ inError: Error?) {
        delegate?.gtDevice(self, wasDisconnected: inError)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover specific services.
     
     - parameter inServiceCBUUIDs: These are the specific UUIDs we are searching for.
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverServices(_ inServiceCBUUIDs: [CBUUID], startClean inStartClean: Bool = false) {
        if inStartClean {
            sequence_contents = [] // Start clean
        }
        peripheral.discoverServices(inServiceCBUUIDs)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of its services.
     
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverAllServices(startClean inStartClean: Bool = false) {
        if inStartClean {
            sequence_contents = [] // Start clean
        }
        peripheral.discoverServices(nil)
    }

    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_GTService) {
        peripheral.discoverCharacteristics(nil, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverAllCharacteristicsForService(_ inService: RVS_GTService) {
        peripheral.discoverCharacteristics(nil, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover specific characteristics for a given service.
     
     - parameter inService: The service object.
     - parameter characteristicCBUUIDs: An Array of CBUUIDs, with the specific characteristics we're looking for.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_GTService, characteristicCBUUIDs inUUIDs: [CBUUID]) {
        peripheral.discoverCharacteristics(inUUIDs, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     This is called when a service is done initializing.
     
     - parameter inService: The service object.
     */
    internal func addServiceToList(_ inService: RVS_GTService) {
        #if DEBUG
            print("Adding Service: \(String(describing: inService)) To Our List at index \(count).")
        #endif
        // Remove from the "holding pen."
        if let index = _holdingPen.firstIndex(where: { return $0.service == inService.service }) {
            #if DEBUG
                print("Removing Service: \(String(describing: inService)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        sequence_contents.append(inService)
        delegate?.gtDevice(self, discoveredService: inService)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to start updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func startNotifyForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.setNotifyValue(true, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to stop updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func stopNotifyForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.setNotifyValue(false, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to read the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func readValueForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.readValue(for: inCharacteristic.characteristic)
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
    
    /* ################################################################## */
    /**
     this is the driver instance that "owns" this device instance.
     */
    public var owner: RVS_GTDriver {
        return _owner
    }
    
    /* ################################################################## */
    /**
     This is our delegate instance. It can be nil.
     */
    public var delegate: RVS_GTDeviceDelegate! {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
    
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna services, as represented by instances of RVS_GTService.
     */
    private var services: [RVS_GTService] {
        return sequence_contents
    }

    /* ################################################################## */
    /**
     This manages and reports our connection. Changing this value will connect or disconnect this device.
     */
    public var isConnected: Bool {
        get {
            return .connected == peripheral.state
        }
        
        set {
            if newValue && .disconnected == peripheral.state {
                _owner.connectDevice(self)
            } else {
                _owner.disconnectDevice(self)
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our services, and treat the driver like an Array of services.
 */
extension RVS_GTDevice: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     The element type is our service.
     */
    public typealias Element = RVS_GTService
}

/* ###################################################################################################################################### */
// MARK: - CBPeripheralDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice: CBPeripheralDelegate {
    /* ################################################################## */
    /**
     This searches through our services for the chacarteristic instance that corresponds to the supplied characteristic.
     
     - parameter inCharacteristic: The CBCharacteristic that we want to match to its RVS_GTCharacteristic instance.
     - returns: The instance associated with the CBCharacteristic. Nil, if none.
     */
    internal func getCharacteristicInstanceForCharacteristic(_ inCharacteristic: CBCharacteristic) -> RVS_GTCharacteristic! {
        #if DEBUG
            print("Searching Services for Characteristic.")
        #endif
        for service in self {
            if let characteristic = service.characteristicForThisCharacteristic(inCharacteristic) {
                #if DEBUG
                    print("Characteristic Found.")
                #endif
                return characteristic
            }
        }
        
        #if DEBUG
            print("Searching Service Holding Pen for Characteristic.")
        #endif
        for service in _holdingPen {
            if let characteristic = service.characteristicForThisCharacteristic(inCharacteristic) {
                #if DEBUG
                    print("Characteristic Found.")
                #endif
                return characteristic
            }
        }

        #if DEBUG
            print("Characteristic Not Found.")
        #endif
        return nil
    }
    
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service, but it has not yet been added to our main cache.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: True, if the "holding pen" currently has an instance of the peripheral cached.
     */
    internal func holdingThisService(_ inService: CBService) -> Bool {
        return _holdingPen.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let service = inElement.service else { return inCurrent }
            return inService == service
        }
    }
    
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: True, if the driver currently has an instance of the peripheral cached.
     */
    internal func containsThisService(_ inService: CBService) -> Bool {
        return services.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let service = inElement.service else { return inCurrent }
            return inService == service
        }
    }
    
    /* ################################################################## */
    /**
     Return the service from our cached Array that corresponds to the given service.
     This checks our "holding pen," as well as our main array.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: The service. Nil, if not found.
     */
    internal func serviceForThisService(_ inService: CBService) -> Element? {
        for service in services where inService == service.service {
            return service
        }
        
        for service in _holdingPen where inService == service.service {
            return service
        }

        return nil
    }

    /* ################################################################## */
    /**
     Called when we have discovered services for the peripheral.
     
     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverServices: Any errors that ocurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        #if DEBUG
            print("\n***> Services Discovered:")
            print("\terror: \(String(describing: inError))\n")
        #endif
        if let services = inPeripheral.services {
            for service in services where !containsThisService(service) && !holdingThisService(service) {
                #if DEBUG
                    print("\t***\n")
                    print("\tservice: \(String(describing: service))\n")
                #endif
                var initialCharacteristics: [CBUUID] = []
                let testUUID = CBUUID(string: "0x180A")
                let serviceUUID = service.uuid
                if testUUID == serviceUUID {   // If device info, we ask for the following four characteristics
                    initialCharacteristics = [CBUUID(string: "0x2A29"), // Manufacturer name
                                              CBUUID(string: "0x2A24"), // Model name
                                              CBUUID(string: "0x2A27"), // Hardware Revision
                                              CBUUID(string: "0x2A26")  // Firmware Revision
                    ]
                }
                let sInstance = RVS_GTService(service, owner: self, initialCharacteristics: initialCharacteristics)
                sInstance.discoverCharacteristics()
                #if DEBUG
                    print("Adding Service: \(String(describing: sInstance)) To Holding Pen at index \(_holdingPen.count).")
                #endif
                _holdingPen.append(sInstance)   // In the holding pen, until we officially add it.
            }
        }
        
        if !_initialized {
            _initialized = true
            reportSuccessfulConnection()
        }
    }
    
    /* ################################################################## */
    /**
     Called when we have discovered characteristics for a service.
     
     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverCharacteristicsFor: The service object.
     - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverCharacteristicsFor inService: CBService, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristics Detected:")
            print("\tdidDiscoverCharacteristicsFor: \(String(describing: inService))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        guard let service = serviceForThisService(inService) else { return }
        if let characteristics = inService.characteristics {
            for characteristic in characteristics where nil == service.characteristicForThisCharacteristic(characteristic) {
                service.interimCharacteristic(characteristic)
            }
        }
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
    Called when a characteristic state has changed.
    
    - parameter inPeripheral: The peripheral we have received notification on.
    - parameter didUpdateNotificationStateFor: The characteristic object.
    - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didUpdateNotificationStateFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristic State Change Detected:")
            print("\tdidUpdateNotificationStateFor: \(String(describing: inCharacteristic))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        
        if let characteristic = getCharacteristicInstanceForCharacteristic(inCharacteristic) {
            characteristic.owner.addCharacteristic(characteristic)
        }
    }
    
    /* ################################################################## */
    /**
    Called when a characteristic state has changed.
    
    - parameter inPeripheral: The peripheral we have received notification on.
    - parameter didUpdateNotificationStateFor: The characteristic object.
    - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristic Value Updated:")
            print("\tdidUpdateValueFor: \(String(describing: inCharacteristic))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        
        if let characteristic = getCharacteristicInstanceForCharacteristic(inCharacteristic) {
            #if DEBUG
                print("Adding Characteristic: \(String(describing: characteristic)) to its service.\n")
            #endif
            characteristic.owner.addCharacteristic(characteristic)
        }
        
        #if DEBUG
            print("<***\n")
        #endif
    }
}
