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
 :nodoc: This class wraps a CB characteristic, on behalf of the BLE driver.
 
 This class conforms to our sequence protocol, so you can iterate and subscript descriptors.
 
 We derive from NSObject, mainly for the description calculated property.
 */
public class RVS_BLECharacteristic: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth characteristic instance that is associated with this object.
     */
    private var _characteristic: CBCharacteristic!
    
    /* ################################################################## */
    /**
     This is the service instance that "owns" this characteristic instance. It is a weak reference.
     */
    private weak var _owner: RVS_BLEService!
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a "cache" of the data.
     */
    internal var internal_cachedData: Data!

    /* ################################################################################################################################## */
    // MARK: - Internal Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a CBCharacteristic instance and a service owner.
     
     - parameter inCharacteristic: The characteristic to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The service that "owns" this characteristic. It is a weak reference. It cannot be nil or omitted.
     */
    internal init(_ inCharacteristic: CBCharacteristic, owner inOwner: RVS_BLEService) {
        super.init()
        _characteristic = inCharacteristic
        _owner = inOwner
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLECharacteristic: RVS_BLEDriverTools {
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
// MARK: - Internal Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_BLECharacteristic {
    /* ################################################################## */
    /**
     Returns the value data for this characteristic.
     */
    internal var characteristicValue: Data? {
        // If the characteristic object has data, we always use that.
        if let cachedData = _characteristic.value {
            internal_cachedData = cachedData
        }
        
        return internal_cachedData
    }

    /* ################################################################## */
    /**
     Returns the value of the characteristic, cast to a string. It may well be nil.
     */
    internal var stringValue: String? {
        if let value = characteristicValue {
            return String(data: value, encoding: .utf8)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is the service instance that "owns" this characteristic instance.
     */
    internal var owner: RVS_BLEService {
        return _owner
    }
    
    /* ################################################################## */
    /**
     This returns our characteristic instance.
     */
    internal var characteristic: CBCharacteristic! {
        return _characteristic
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can broadcast its value.
     */
    internal var canBroadcast: Bool {
        return _characteristic.properties.contains(.broadcast)
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be read.
     */
    internal var canRead: Bool {
        return _characteristic.properties.contains(.read)
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can be written, with or without a response.
     */
    internal var canWrite: Bool {
        return canWriteWithResponse || canWriteWithoutResponse
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can be written, with a response.
     */
    internal var canWriteWithResponse: Bool {
        return _characteristic.properties.contains(.write)
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, without a response.
     */
    internal var canWriteWithoutResponse: Bool {
        return _characteristic.properties.contains(.writeWithoutResponse)
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can notify.
     */
    internal var canNotify: Bool {
        return _characteristic.properties.contains(.notify)
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can indicate. The driver need sto respond to indications.
     */
    internal var canIndicate: Bool {
        return _characteristic.properties.contains(.indicate)
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can have authenticated signed writes, without a response.
     */
    internal var canHaveAuthenticatedSignedWrites: Bool {
        return _characteristic.properties.contains(.indicate)
    }
    
    /* ################################################################## */
    /**
     Only trusted devices can subscribe to notifications of this property.
     */
    internal var isEncryptionRequiredForNotify: Bool {
        return _characteristic.properties.contains(.notifyEncryptionRequired)
    }
    
    /* ################################################################## */
    /**
     Only trusted devices can see indications of this property.
     */
    internal var isEncryptionRequiredForIndication: Bool {
        return _characteristic.properties.contains(.indicateEncryptionRequired)
    }
    
    /* ################################################################## */
    /**
     - returns: The User description (if any) as a String. Nil, if none.
     */
    internal var descriptorString: String! {
        for descriptor in self where CBUUIDCharacteristicUserDescriptionString == descriptor.uuid.uuidString {
            return descriptor.value as? String
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     - returns: The type of data. Nil, if none.
     */
    internal var typeString: String! {
        for descriptor in self where CBUUIDCharacteristicFormatString == descriptor.uuid.uuidString {
            return descriptor.value as? String
        }
        
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence Support
/* ###################################################################################################################################### */
extension RVS_BLECharacteristic: RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     :nodoc: We sequence CBDescriptors.
     */
    public typealias Element = CBDescriptor
    
    /* ################################################################## */
    /**
     :nodoc: This is a simple direct access to the characteristic descriptors.
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
// MARK: - Public RVS_BLEDriver_ValueProtocol Support -
/* ###################################################################################################################################### */
extension RVS_BLECharacteristic: RVS_BLEDriver_ValueProtocol {
    /* ################################################################## */
    /**
     Returns the value, expressed as raw Data. Nil, if no value available (or not available as Data).
     */
    public var rawValue: Data? {
        return characteristicValue
    }
    
    /* ################################################################## */
    /**
     Return a value, dependent upon our type.
     
     - returns: An enum, wrapping the data in a parsed form.
     */
    public var value: RVS_BLEDriver_ValueProtocol_Type_Enum {
        if let type = typeString {  // If we have a type descriptor...
            print("The characteristic type is \(String(describing: type))")
        } else if   let rawValue = rawValue,
                    let stringVal = String(data: rawValue, encoding: .utf8) {
            return .stringValue(stringVal)
        }
        return .undefinedValue
    }
    
    /* ################################################################## */
    /**
     - returns: either the user description (if given), or the UUID.
     */
    override public var description: String {
        var ret: String! = descriptorString
        
        if nil == ret || ret.isEmpty,
            let gattInst = RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID(rawValue: characteristic.uuid.uuidString) {         // Try first, without the hex prefix
            ret = String(describing: gattInst)
        }
        
        if nil == ret || ret.isEmpty,
            let gattInst = RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID(rawValue: "0x" + characteristic.uuid.uuidString) {  // Need to add the hex indicator.
            ret = String(describing: gattInst)
        }
        
        if nil == ret || ret.isEmpty {
            ret = characteristic.uuid.uuidString
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns: The UUID of the value characteristic, as a String.
     */
    public var uuidString: String {
        return characteristic.uuid.uuidString
    }
}
