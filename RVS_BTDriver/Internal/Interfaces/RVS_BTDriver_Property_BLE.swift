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
// MARK: - Specialization of the Generic Property for BLE -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Property_BLE: RVS_BTDriver_Property {
    /// The CB characteristic associated with this instance.
    internal var cbCharacteristic: CBCharacteristic!
    
    /* ################################################################## */
    /**
     - returns: The User description (if any) as a String. Nil, if none.
     */
    internal var descriptorString: String! {
        if let descriptors = cbCharacteristic?.descriptors {
            for descriptor in descriptors where CBUUIDCharacteristicUserDescriptionString == descriptor.uuid.uuidString {
                return descriptor.value as? String
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is called when the property is updated.
     We use this to set the value.
     */
    internal override func executeUpdate() {
        rawValue = self.cbCharacteristic.value
        #if DEBUG
            print("Property : \(String(describing: self)) added a property: \(String(describing: rawValue)).")
        #endif
        super.executeUpdate()   // This will move the updated property from the holding pen (if it is still there), into the main array.
    }

    /* ################################################################## */
    /**
     - returns: The user description of the property, including any capabilities.
     */
    public override var description: String {
        var desc = super.description
        
        if  let descriptorString = descriptorString,
            !descriptorString.isEmpty {
            desc += "\n\tDescriptor: \"\(descriptorString))\""
        }

        if  let cbCharacteristic = cbCharacteristic {
            desc += "\n\tCharacteristic: \(cbCharacteristic))"

            if canBroadcast {
                desc += "\n\tCan Broadcast"
            }
            
            if canRead {
                desc += "\n\tCan Read"
            }
            
            if canWriteWithResponse {
                desc += "\n\tCan Write With Response"
            }
            
            if canWriteWithoutResponse {
                desc += "\n\tCan Write Without Response"
            }
            
            if canNotify {
                desc += "\n\tCan Notify"
            }
            
            if canIndicate {
                desc += "\n\tCan Indicate"
            }
            
            if canHaveAuthenticatedSignedWrites {
                desc += "\n\tCan Have Authenticated Signed Writes"
            }
            
            if isEncryptionRequiredForNotify {
                desc += "\n\tEncryption is Required for Notify"
            }
            
            if isEncryptionRequiredForIndication {
                desc += "\n\tEncryption is Required for Indicate"
            }
        }
        
        return desc
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can broadcast its value.
     */
    public override var canBroadcast: Bool {
        get { return cbCharacteristic.properties.contains(.broadcast) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be read.
     */
    public override var canRead: Bool {
        get { return cbCharacteristic.properties.contains(.read) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, with or without a response.
     */
    public override var canWrite: Bool {
        get { return canWriteWithResponse || canWriteWithoutResponse }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, with a response.
     */
    public override var canWriteWithResponse: Bool {
        get { return cbCharacteristic.properties.contains(.write) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, without a response.
     */
    public override var canWriteWithoutResponse: Bool {
        get { return cbCharacteristic.properties.contains(.writeWithoutResponse) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can notify.
     */
    public override var canNotify: Bool {
        get {
            return cbCharacteristic.properties.contains(.notify)
        }
        
        set {
            if  let owner = internal_owner as? RVS_BTDriver_Service_BLE,
                let device = owner.owner as? RVS_BTDriver_Device_BLE {
                #if DEBUG
                    print("Setting Notify to \(newValue ? "true" : "false") for \(self).")
                #endif
                device.peripheral.setNotifyValue(newValue, for: cbCharacteristic)
            }
        }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can indicate. The driver need sto respond to indications.
     */
    public override var canIndicate: Bool {
        get { return cbCharacteristic.properties.contains(.indicate) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can have authenticated signed writes, without a response.
     */
    public override var canHaveAuthenticatedSignedWrites: Bool {
        get { return cbCharacteristic.properties.contains(.authenticatedSignedWrites) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     Only trusted devices can subscribe to notifications of this property.
     */
    public override var isEncryptionRequiredForNotify: Bool {
        get { return cbCharacteristic.properties.contains(.notifyEncryptionRequired) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }

    /* ################################################################## */
    /**
     Only trusted devices can see indications of this property.
     */
    public override var isEncryptionRequiredForIndication: Bool {
        get { return cbCharacteristic.properties.contains(.indicateEncryptionRequired) }
        set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Standard Device Info Service for BLE -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Service_DeviceInfo_BLE: RVS_BTDriver_Service_BLE {
    /* ################################################################## */
    /**
     This is a list of the UUIDs for the standard Device Info charateristics.
     */
    internal enum RVS_BLE_GATT_UUID: String, CaseIterable {
        /// This is the actual device info service ID
        case deviceInfoService      =   "180A"
        
        /// This characteristic represents a structure containing an Organizationally Unique Identifier (OUI) followed by a manufacturer-defined identifier and is unique for each individual instance of the product.
        case systemIDStruct         =   "2A23"
        /// This characteristic represents the model number that is assigned by the device vendor.
        case modelNumberString      =   "2A24"
        /// This characteristic represents the serial number for a particular instance of the device.
        case serialNumberString     =   "2A25"
        /// This characteristic represents the firmware revision for the firmware within the device.
        case firmwareRevisionString =   "2A26"
        /// This characteristic represents the hardware revision for the hardware within the device.
        case hardwareRevisionString =   "2A27"
        /// This characteristic represents the software revision for the software within the device.
        case softwareRevisionString =   "2A28"
        /// This characteristic represents the name of the manufacturer of the device.
        case manufacturerNameString =   "2A29"
        /// This characteristic represents regulatory and certification information for the product in a list defined in IEEE 11073-20601.
        case ieeRegulatoryList      =   "2A2A"
        /// The PnP_ID characteristic is a set of values used to create a device ID value that is unique for this device.
        case pnpIDSet               =   "2A50"
    }

    /* ################################################################## */
    /**
     Start a discovery process for basic characteristics (properties).
     */
    internal override func discoverInitialCharacteristics() {
        if let owner = internal_owner as? RVS_BTDriver_Device_BLE {
            owner.peripheral.discoverCharacteristics(nil, for: cbService)
        }
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    public var modelName: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.modelNumberString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .ascii)
        }
        return nil
    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    public var manufacturerName: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.manufacturerNameString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .ascii)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a serial number, it is available here.
     */
    public var serialNumber: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.serialNumberString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .ascii)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    public var hardwareRevision: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.hardwareRevisionString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .ascii)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    public var firmwareRevision: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.firmwareRevisionString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .ascii)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    public var softwareRevision: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.softwareRevisionString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .ascii)
        }
        
        return nil
    }
}
