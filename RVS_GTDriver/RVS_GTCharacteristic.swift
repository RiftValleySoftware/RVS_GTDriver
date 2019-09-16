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
public class RVS_GTCharacteristic: NSObject, RVS_SequenceProtocol, RVS_GTDriverErrorReporter {    
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
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_GTDriver.Errors) {
        owner.reportThisError(inError)
    }

    /* ################################################################## */
    /**
     This is the service instance that "owns" this characteristic instance.
     */
    internal var owner: RVS_GTService {
        return _owner
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_GTCharacteristic {
    /* ################################################################## */
    /**
     This returns our characteristic instance.
     */
    public var characteristic: CBCharacteristic! {
        return _characteristic
    }
    
    /* ################################################################## */
    /**
     Returns the value data for this characteristic.
     */
    public var value: Data? {
        return _characteristic.value
    }
    
    /* ################################################################## */
    /**
     Return the simple description UUID.
     */
    override public var description: String {
        return String(describing: characteristic.uuid)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support
/* ###################################################################################################################################### */
extension RVS_GTCharacteristic {
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