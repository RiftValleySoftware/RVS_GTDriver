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
// MARK: - Individual Characteristic Instance Class -
/* ###################################################################################################################################### */
/**
 This class wraps a CB characteristic, on behalf of the goTenna driver.
 */
public class RVS_GTCharacteristic: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth service instance that is associated with this object.
     */
    private var _characteristic: CBCharacteristic!
    
    /* ################################################################## */
    /**
     This is the service instance that "owns" this device instance. It is a weak reference.
     */
    private weak var _owner: RVS_GTService!
    
    /* ################################################################## */
    /**
     This is a "cache" of the data.
     */
    private var _cachedData: Data!
    
    /* ################################################################################################################################## */
    // MARK: - Internal Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance and an owner.
     
     - parameter inCharacteristic: The characteristic to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The service that "owns" this characteristic. It is a weak reference. It cannot be nil or omitted.
     */
    internal init(_ inCharacteristic: CBCharacteristic, owner inOwner: RVS_GTService) {
        super.init()
        _characteristic = inCharacteristic
        _owner = inOwner
    }
    
    /* ################################################################## */
    /**
     This is the service instance that "owns" this characteristic instance.
     */
    internal var owner: RVS_GTService {
        return _owner
    }
    
    /* ################################################################## */
    /**
     This returns our characteristic instance.
     */
    internal var characteristic: CBCharacteristic! {
        return _characteristic
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTCharacteristic: RVS_GTDriverTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_GTDriver.Errors) {
        owner.reportThisError(inError)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support
/* ###################################################################################################################################### */
extension RVS_GTCharacteristic: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     We sequence CBDescriptors.
     */
    public typealias Element = CBDescriptor
    
    /* ################################################################## */
    /**
     This is a simple direct access to the characteristic descriptors.
     */
    public var sequence_contents: [CBDescriptor] {
        get {
            return _characteristic.descriptors ?? []
        }
        
        set {
            _ = newValue    // NOP
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - This is What We Tell the Kids -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the characteristic. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 One other thing about this class, is that it conforms to Sequence, so you can iterate through it for descriptors, or access descriptors as subscripts.
 */
extension RVS_GTCharacteristic {
    /* ################################################################## */
    /**
     Returns the value data for this characteristic.
     
     It is KVO Observable
     */
    @objc dynamic public var value: Data? {
        // If the characteristic object has data, we always use that.
        if let cachedData = _characteristic.value {
            _cachedData = cachedData
        }
        
        return _cachedData
    }

    /* ################################################################## */
    /**
     Returns the value of the characteristic, cast to a string. It may well be nil.
     
     It is KVO Observable
     */
    @objc dynamic public var stringValue: String? {
        if let value = value {
            return String(data: value, encoding: .utf8)
        }
        
        return nil
    }

    /* ################################################################## */
    /**
     Return the simple description UUID.
     */
    override public var description: String {
        return String(describing: characteristic.uuid)
    }
}
