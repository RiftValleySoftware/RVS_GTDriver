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
// MARK: - Individual Device Instance Class -
/* ###################################################################################################################################### */
/**
 This class implements a single discovered goTenna device (in peripheral mode).
 
 It needs to be a class, as opposed to a struct, so that it can have its delegate set and passed around.
 */
public class RVS_GTService {
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

    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the driver to instantiate with a peripheral and an owner.
     */
    private init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance and an owner.
     
     - parameter inService: The service to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The device that "owns" this service. It is a weak reference. It cannot be nil or omitted.
     - parameter delegate: The RVS_GTServiceDelegate instance. This is a weak reference, but is optional, and can be omitted
     */
    internal init(_ inService: CBService, owner inOwner: RVS_GTDevice, delegate inDelegate: RVS_GTServiceDelegate! = nil) {
        _service = inService
        _owner = inOwner
        _delegate = inDelegate
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Sequence Support Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered characteristics, as represented by instances of RVS_GTCharacteristic.
     */
    public var sequence_contents: [RVS_GTCharacteristic] = []
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
     Return the service from our cached Array that corresponds to the given service.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inCharacteristic: The characteristic we are looking for.
     - returns: The service. Nil, if not found.
     */
    internal func characteristicForThisCharacteristic(_ inCharacteristic: CBCharacteristic) -> Element? {
        for characteristic in characteristics where inCharacteristic == characteristic.characteristic {
            return characteristic
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     We add and instantiate a new RVS_GTCharacteristic for the given CBCharacteristic.
     
     - parameter inCharacteristic: The CB characteristic we are adding.
     */
    internal func addCharacteristic(_ inCharacteristic: CBCharacteristic) {
        if !containsThisCharacteristic(inCharacteristic) {
            let chrInstance = RVS_GTCharacteristic(inCharacteristic, owner: self)
            sequence_contents.append(chrInstance)
            delegate?.gtService(self, dicoveredCharacteristic: chrInstance)
        }
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
// MARK: - Public Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_GTService {
    /* ################################################################## */
    /**
     This returns our service instance.
     */
    public var service: CBService! {
        return _service
    }
    
    /* ################################################################## */
    /**
     this is the device instance that "owns" this service instance.
     */
    public var owner: RVS_GTDevice {
        return _owner
    }
    
    /* ################################################################## */
    /**
     This returns our characteristics Array.
     */
    public var characteristics: [RVS_GTCharacteristic]! {
        return sequence_contents
    }
    
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
}

/* ###################################################################################################################################### */
// MARK: - Public Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTService {
    /* ################################################################## */
    /**
     Asks the device to discover all of its characteristics for our service.
     */
    public func discoverCharacteristics() {
        sequence_contents = []   // Start clean.
        _owner.discoverAllCharacteristicsForService(self)
    }
}
