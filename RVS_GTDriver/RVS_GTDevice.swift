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
    func gtDevice(_ device: RVS_GTDevice, errorEncountered: Error)
    
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
     - parameter discoveredService: The CBUUID of the discovered service.
     */
    func gtDevice(_ device: RVS_GTDevice, discoveredService: CBUUID)
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
     - parameter discoveredService: The CBUUID of the discovered service.
     */
    public func gtDevice(_ device: RVS_GTDevice, discoveredService: CBUUID) { }
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
     This is an Array of our discovered and initialized goTenna services, as represented by instances of RVS_GTService.
     */
    private var _contents: [RVS_GTService] = []

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
    }
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
        delegate?.gtDeviceWasConnected(self)
    }
    
    /* ################################################################## */
    /**
     Called to send a disconnection event to the device's delegate.
     
     - parameter inError: Any error that may have occurred. It is passed directly to the delegate.
     */
    internal func reportDisconnection(_ inError: Error?) {
        delegate?.gtDevice(self, wasDisconnected: inError)
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
        return _contents
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
// MARK: - Public Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice {
    /* ################################################################## */
    /**
     Asks the device to discover all of its services.
     */
    public func discoverServices() {
        _contents = [] // Start clean
        peripheral.discoverServices(nil)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     */
    public func discoverAllCharacteristicsForService(_ inService: RVS_GTService) {
        peripheral.discoverCharacteristics(nil, for: inService.service)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our services, and treat the driver like an Array of services.
 */
extension RVS_GTDevice: Sequence {
    /* ################################################################## */
    /**
     The element type is our service.
     */
    public typealias Element = RVS_GTService

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
// MARK: - CBPeripheralDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice: CBPeripheralDelegate {
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The peripheral we are looking for.
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
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: The service. Nil, if not found.
     */
    internal func serviceForThisService(_ inService: CBService) -> Element? {
        for service in services where inService == service.service {
            return service
        }
        
        return nil
    }

    /* ################################################################## */
    /**
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        #if DEBUG
            print("\n***> Services Discovered:")
            print("\terror: \(String(describing: inError))\n")
            if let services = inPeripheral.services {
                for service in services where !containsThisService(service) {
                    #if DEBUG
                        print("\t***\n")
                        print("\tservice: \(String(describing: service))\n")
                    #endif
                    _contents.append(RVS_GTService(service, owner: self))
                }
            }
        #endif
    }
    
    /* ################################################################## */
    /**
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverCharacteristicsFor inService: CBService, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristics Detected:")
            print("\tdidDiscoverCharacteristicsFor: \(String(describing: inService))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        guard let service = serviceForThisService(inService) else { return }
        guard let characteristics = inService.characteristics else { return }
        for characteristic in characteristics {
            #if DEBUG
                print("\t***\n")
                print("\tcharacteristic: \(String(describing: characteristic))\n")
            #endif
            service.addCharacteristic(characteristic)
        }
        #if DEBUG
            print("<***\n")
        #endif
    }
}
