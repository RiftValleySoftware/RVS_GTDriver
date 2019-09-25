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
// MARK: - Individual Service Instance Class -
/* ###################################################################################################################################### */
/**
 :nodoc: This class implements a BLE service wrapper, specialized for the goTenna driver.
 
 This class also conforms to a Sequence protocol, so you can iterate and subscript characteristics.
 */
public class RVS_BLEService: NSObject, RVS_BLEDriver_ServiceProtocol {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth service instance that is associated with this object.
     */
    private var _service: CBService!
    
    /* ################################################################## */
    /**
     This is the device instance that "owns" this service instance.
     */
    private weak var _owner: RVS_BLEDevice!
    
    /* ################################################################## */
    /**
     This is a list of initial characteristics that must be read before we consider the initialization complete.
     */
    private var _initialCharacteristics: [CBUUID] = []
    
    /* ################################################################## */
    /**
     This is a (yuck) semaphore, indicating that the initial service info was read.
     */
    private var _initialized = false

    /* ################################################################## */
    /**
     This is a "holding pen" for characteristics that have been discovered, but not yet initialized. They need to be kept around, in order to remain viable.
     */
    private var _holdingPen: [RVS_BLECharacteristic] = []
    
    /* ################################################################## */
    /**
     This is where we keep our discovered and cached characteristics.
     */
    private var _sequence_contents: [RVS_BLECharacteristic] = []

    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the driver to instantiate with a peripheral and an owner.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance and an owner.
     
     - parameter inService: The service to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The device that "owns" this service. It is a weak reference. It cannot be nil or omitted.
     - parameter initialCharacteristics: This is a list of UUIDs that must be all read before the service is considered initialized. This is optional, and default is an empty Array.
     */
    internal init(_ inService: CBService, owner inOwner: RVS_BLEDevice, initialCharacteristics inInitialCharacteristics: [CBUUID] = []) {
        super.init()
        _service = inService
        _owner = inOwner
        _initialCharacteristics = inInitialCharacteristics
        
        // If we aren't looking up any initial characteristics, then we're done.
        if _initialCharacteristics.isEmpty {
            addOurselvesToDevice()
        } else {
            discoverCharacteristics(characteristicCBUUIDs: _initialCharacteristics)
        }
    }
    
    /* ################################################################## */
    /**
     This is a factory function, for creating characteristic instances.
     
     This is declared here, so we can override it in our factory-produced subclasses.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func makeCharacteristicForThisCharacteristic(_ inCharacteristic: CBCharacteristic) -> RVS_BLECharacteristic? {
        return RVS_BLECharacteristic(inCharacteristic, owner: self)
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_BLEService {
    /* ################################################################## */
    /**
     This returns our characteristics Array as well as our "holding" characteristics
     */
    internal var characteristicUUIDs: [CBUUID] {
        var ret: [CBUUID] = []
        
        self.forEach {
            ret.append($0.characteristic.uuid)
        }
        
        _holdingPen.forEach {
            ret.append($0.characteristic.uuid)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This returns our characteristics Array.
     */
    internal var characteristics: [RVS_BLECharacteristic]! {
        return sequence_contents
    }
    
    /* ################################################################## */
    /**
     This returns our service instance.
     */
    internal var service: CBService! {
        return _service
    }
    
    /* ################################################################## */
    /**
     this is the device instance that "owns" this service instance.
     */
    internal var owner: RVS_BLEDevice {
        return _owner
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLEService {
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inCharacteristic: The characteristic we are looking for.
     - returns: True, if the service currently has an instance of the characteristic cached.
     */
    internal func containsThisCharacteristic(_ inCharacteristic: CBCharacteristic) -> Bool {
        return characteristics.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let characteristic = inElement.characteristic else { return inCurrent }
            return inCharacteristic == characteristic
        }
    }
    
    /* ################################################################## */
    /**
     Return the characteristic from our cached Array that corresponds to the given CB Characteristic.
     This also checks our "holding pen."
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inCharacteristic: The characteristic we are looking for.
     - returns: The characteristic. Nil, if not found.
     */
    internal func characteristicForThisCharacteristic(_ inCharacteristic: CBCharacteristic) -> Element? {
        #if DEBUG
            print("Searching for Characteristic.")
        #endif
        
        #if DEBUG
            print("Searching Main Array for Characteristic.")
        #endif
        for characteristic in characteristics where inCharacteristic == characteristic.characteristic {
            #if DEBUG
                print("Characteristic Found In Main Array.")
            #endif
            return characteristic
        }
        
        #if DEBUG
            print("Searching Holding Pen for Characteristic.")
        #endif
        for characteristic in _holdingPen where inCharacteristic == characteristic.characteristic {
            #if DEBUG
                print("Characteristic Found In Holding Pen.")
            #endif
            return characteristic
        }

        #if DEBUG
            print("Characteristic Was Not Found.")
        #endif
        return nil
    }
    
    /* ################################################################## */
    /**
     Return the characteristic from our cached Array that corresponds to the given characteristic UUID.
     This DOES NOT check the "holding pen."
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inUUID: The UUID of the characteristic we are looking for.
     - returns: The characteristic. Nil, if not found.
     */
    internal func characteristicForThisUUID(_ inUUID: CBUUID) -> Element? {
        #if DEBUG
            print("Searching for Characteristic for \(String(describing: inUUID)).")
        #endif
        
        for characteristic in self where inUUID == characteristic.characteristic.uuid {
            #if DEBUG
                print("Characteristic Found.")
            #endif
            return characteristic
        }

        return nil
    }
    
    /* ################################################################## */
    /**
     We add and instantiate a new RVS_BLECharacteristic for the given CBCharacteristic, but we don't add it quite yet, if we are initializing.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func interimCharacteristic(_ inCharacteristic: CBCharacteristic) {
        if  !containsThisCharacteristic(inCharacteristic),
            let chrInstance = makeCharacteristicForThisCharacteristic(inCharacteristic) {
            if let index = _initialCharacteristics.firstIndex(of: inCharacteristic.uuid) {
                #if DEBUG
                    print("Removing Characteristic: \(String(describing: inCharacteristic)) From Our Initial List at index \(index).")
                #endif
                _initialCharacteristics.remove(at: index)
            }
            
            if chrInstance.canRead {    // If we are allowed to read, we do so.
                #if DEBUG
                    print("Adding Characteristic: \(String(describing: chrInstance)) To Our Holding Pen at index \(_holdingPen.count).")
                #endif
                _holdingPen.append(chrInstance)
                _owner.readValueForCharacteristic(chrInstance)
            } else {    // If we can't read, we immediately add it.
                #if DEBUG
                    print("Immediately Adding Characteristic: \(String(describing: chrInstance)).")
                #endif
                addCharacteristic(chrInstance)
            }
        }
    }
    
    /* ################################################################## */
    /**
     We add and instantiate a new RVS_BLECharacteristic for the given CBCharacteristic.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func addCharacteristic(_ inCharacteristic: RVS_BLECharacteristic) {
        #if DEBUG
            print("Adding Characteristic: \(String(describing: inCharacteristic)) To Our List at index \(count).")
        #endif
        if let index = _holdingPen.firstIndex(where: { return $0.characteristic == inCharacteristic.characteristic }) {
            #if DEBUG
                print("Removing Characteristic: \(String(describing: inCharacteristic)) From Our Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
            _sequence_contents.append(inCharacteristic)
        }
        
        if  !_initialized,
            _holdingPen.isEmpty { // We see if we are done. If so, we add ourselves to the device.
            #if DEBUG
                print("We Are Done With Initialization. Time to Add Ourselves to the Device.")
            #endif
            addOurselvesToDevice()
        }
    }
    
    /* ################################################################## */
    /**
     Adds this instance to our device.
     */
    internal func addOurselvesToDevice() {
        #if DEBUG
            print("Adding Ourselves to the Device.")
        #endif
        _initialized = true
        owner.addServiceToList(self)
    }

    /* ################################################################## */
    /**
     Asks the device to discover specific characteristics for this service.
     
     - parameter characteristicCBUUIDs: An Array of CBUUIDs, with the specific characteristics we're looking for.
     - parameter startClean: Optional (default is false). If true, then all cached characteristics are cleared before discovery.
     */
    internal func discoverCharacteristics(characteristicCBUUIDs inUUIDs: [CBUUID], startClean inStartClean: Bool = false) {
        if inStartClean {
            _sequence_contents = [] // Start clean
        }
        
        if !inUUIDs.isEmpty {
            #if DEBUG
                print("Service: \(String(describing: self)) is Discovering Characteristics for UUIDs: \(String(describing: inUUIDs))")
            #endif
            _owner.discoverCharacteristicsForService(self, characteristicCBUUIDs: inUUIDs)
        }
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for this service.
     
     - parameter startClean: Optional (default is false). If true, then all cached characteristics are cleared before discovery.
     */
    internal func discoverAllCharacteristics(startClean inStartClean: Bool = false) {
        if inStartClean {
            _sequence_contents = [] // Start clean
        }
        
        #if DEBUG
            print("Service: \(String(describing: self)) is Discovering All Characteristics")
        #endif

        _owner.discoverAllCharacteristicsForService(self)
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLEService: RVS_BLEDriverTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_BLEDriver.Errors) {
        owner.reportThisError(inError)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our characteristics, and treat the service like an Array of characteristics.
 */
extension RVS_BLEService: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     :nodoc: The element type is our characteristic class.
     */
    public typealias Element = RVS_BLECharacteristic
    
    /* ################################################################## */
    /**
     :nodoc: This is an Array of our discovered characteristics, as represented by instances of RVS_BLECharacteristic.
     */
    public var sequence_contents: [RVS_BLECharacteristic] {
        get {
            return _sequence_contents
        }
        
        set {
            _ = newValue    // NOP
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_BLEService {
    /* ################################################################## */
    /**
     :nodoc: Return the simple description UUID.
     */
    override public var description: String {
        return String(describing: service.uuid)
    }
}
