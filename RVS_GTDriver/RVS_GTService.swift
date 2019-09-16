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
// MARK: - RVS_GTServiceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol.
 */
public protocol RVS_GTServiceDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by a single service.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter service: The service instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtService(_ service: RVS_GTService, errorEncountered: RVS_GTDriver.Errors)
    
    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a new characteristic has been added to the service.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter service: The service instance calling this.
     - parameter dicoveredCharacteristic: The new characteristic instance.
     */
    func gtService(_ service: RVS_GTService, dicoveredCharacteristic: RVS_GTCharacteristic)
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTServiceDelegate Protocol Extension (Optional Methods) -
/* ###################################################################################################################################### */
extension RVS_GTServiceDelegate {
    /* ################################################################## */
    /**
     Called when a new characteristic has been added to the service.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter service: The service instance calling this.
     - parameter dicoveredCharacteristic: The new characteristic instance.
     */
    func gtService(_ service: RVS_GTService, dicoveredCharacteristic: RVS_GTCharacteristic) { }
}

/* ###################################################################################################################################### */
// MARK: - Individual Service Instance Class -
/* ###################################################################################################################################### */
/**
 This class implements a BLE service wrapper, specialized for the goTenna driver.
 */
public class RVS_GTService: NSObject {
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
    private weak var _owner: RVS_GTDevice!
    
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    private var _delegate: RVS_GTServiceDelegate!
    
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
    private var _holdingPen: [RVS_GTCharacteristic] = []
    
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
     
     - parameter inService: The service to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The device that "owns" this service. It is a weak reference. It cannot be nil or omitted.
     - parameter delegate: The RVS_GTServiceDelegate instance. This is a weak reference. It is optional. Default is nil (no delegate).
     - parameter initialCharacteristics: This is a list of UUIDs that must be all read before the service is considered initialized. This is optional, and default is an empty Array.
     */
    internal init(_ inService: CBService, owner inOwner: RVS_GTDevice, delegate inDelegate: RVS_GTServiceDelegate? = nil, initialCharacteristics inInitialCharacteristics: [CBUUID] = []) {
        super.init()
        _service = inService
        _owner = inOwner
        _delegate = inDelegate
        _initialCharacteristics = inInitialCharacteristics
        
        // If we aren't looking up any initial characteristics, then we're done.
        if _initialCharacteristics.isEmpty {
            addOurselvesToDevice()
        } else {
            discoverCharacteristics(characteristicCBUUIDs: _initialCharacteristics)
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Sequence Support Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered characteristics, as represented by instances of RVS_GTCharacteristic.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.
     */
    public var sequence_contents: [RVS_GTCharacteristic] = []
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_GTService {
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
    internal var characteristics: [RVS_GTCharacteristic]! {
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
    internal var owner: RVS_GTDevice {
        return _owner
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTService {
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
     We add and instantiate a new RVS_GTCharacteristic for the given CBCharacteristic, but we don't add it quite yet, if we are initializing.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func interimCharacteristic(_ inCharacteristic: CBCharacteristic) {
        var chrInstance: RVS_GTCharacteristic!
        
        if !containsThisCharacteristic(inCharacteristic) {
            chrInstance = RVS_GTCharacteristic(inCharacteristic, owner: self)
            
            if let index = _initialCharacteristics.firstIndex(of: inCharacteristic.uuid) {
                #if DEBUG
                    print("Removing Characteristic: \(String(describing: inCharacteristic)) From Our Initial List at index \(index).")
                #endif
                _initialCharacteristics.remove(at: index)
            }
            
            #if DEBUG
                print("Adding Characteristic: \(String(describing: chrInstance)) To Our Holding Pen at index \(_holdingPen.count).")
            #endif
            _holdingPen.append(chrInstance)
            _owner.readValueForCharacteristic(chrInstance)
        }
    }
    
    /* ################################################################## */
    /**
     We add and instantiate a new RVS_GTCharacteristic for the given CBCharacteristic.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func addCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        #if DEBUG
            print("Adding Characteristic: \(String(describing: inCharacteristic)) To Our List at index \(count).")
        #endif
        if let index = _holdingPen.firstIndex(where: { return $0.characteristic == inCharacteristic.characteristic }) {
            #if DEBUG
                print("Removing Characteristic: \(String(describing: inCharacteristic)) From Our Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
            sequence_contents.append(inCharacteristic)
        }
        
        // If we are already initialized, then we simply call the delegate to let it know we have a characteristic ready.
        if _initialized {
            #if DEBUG
                print("Sending Characteristic: \(String(describing: inCharacteristic)) To the Delegate.")
            #endif
            delegate?.gtService(self, dicoveredCharacteristic: inCharacteristic)
        } else if _holdingPen.isEmpty { // Otherwise, we see if we are done. If so, we add ourselves to the device.
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
            sequence_contents = [] // Start clean
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
            sequence_contents = [] // Start clean
        }
        
        #if DEBUG
            print("Service: \(String(describing: self)) is Discovering All Characteristics")
        #endif

        _owner.discoverAllCharacteristicsForService(self)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support -
/* ###################################################################################################################################### */
/**
 We do this, so we can iterate through our characteristics, and treat the service like an Array of characteristics.
 */
extension RVS_GTService: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     The element type is our characteristic class.
     */
    public typealias Element = RVS_GTCharacteristic
}

/* ###################################################################################################################################### */
// MARK: - This is What We Tell the Kids -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the device. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 One other thing about this class, is that it conforms to Sequence, so you can iterate through it for services, or access services as subscripts.
 */
extension RVS_GTService {
    /* ################################################################################################################################## */
    // MARK: - Public Calculated Instance Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. It can be nil.
     */
    public var delegate: RVS_GTServiceDelegate! {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
    
    /* ################################################################## */
    /**
     Return the simple description UUID.
     */
    override public var description: String {
        return String(describing: service.uuid)
    }
}
