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
// MARK: - Specialization of the Generic Service for BLE -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Service_BLE: RVS_BTDriver_Service {
    /// The CB service associated with this instance.
    internal var cbService: CBService!
    
    /* ################################################################## */
    /**
     Start a discovery process for all characteristics (properties).
     */
    internal override func discoverInitialCharacteristics() {
        if let owner = internal_owner as? RVS_BTDriver_Device_BLE {
            owner.peripheral.discoverCharacteristics(nil, for: cbService)
        }
    }
    
    /* ################################################################## */
    /**
     This searches the service, and returns a property that "owns" the given characteristic.
     
     - parameter inCBCharacteristic: The CoreBluetooth Characteristic we are matching.
     
     - returns: The Property instance for the characteristic. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBCharacteristic(_ inCBCharacteristic: CBCharacteristic) -> RVS_BTDriver_Property_BLE! {
        // First, we check the "holding pen."
        for propertyInstance in internal_holding_pen {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance.cbCharacteristic === inCBCharacteristic {
                    return propertyInstance
                }
            }
        }
        
        // Then, we check the property storage.
        for propertyInstance in internal_property_list {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance.cbCharacteristic === inCBCharacteristic {
                    return propertyInstance
                }
            }
        }

        return nil
    }
    
    /* ################################################################## */
    /**
     This searches the service, and returns a property for the given characteristic, identified by its UUID (as a String).
     
     - parameter inUUIDString: The CoreBluetooth Characteristic UID (as a String) we are matching.
     
     - returns: The Property instance for the UID. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBUUID(_ inUUIDString: String) -> RVS_BTDriver_Property_BLE! {
        // First, we check the "holding pen."
        for propertyInstance in internal_holding_pen {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance.uuid == inUUIDString {
                    return propertyInstance
                }
            }
        }
        
        // Then, we check the property storage.
        for propertyInstance in internal_property_list {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance.uuid == inUUIDString {
                    return propertyInstance
                }
            }
        }

        return nil
    }

    /* ################################################################## */
    /**
     This adds a new property to the holding pen (if it can read), where an update will be requested, or directly into the main list.
     
     - parameter inPropertyObject: The property object we are adding.
     */
    internal func addPropertyToList(_ inPropertyObject: RVS_BTDriver_Property_BLE) {
        // First, we check both our lists, and make sure we're not already there.
        for propertyInstance in internal_holding_pen {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance === inPropertyObject {
                    assert(false, "Property Object: \(propertyInstance) is Already in the Holding Pen.")
                    return
                }
            }
        }
        
        for propertyInstance in internal_property_list {
            if let propertyInstance = propertyInstance as? RVS_BTDriver_Property_BLE {
                if propertyInstance === inPropertyObject {
                    assert(false, "Property Object: \(propertyInstance) is Already in the Main List.")
                    return
                }
            }
        }
        
        // If we got here, then we are not already there.
        if inPropertyObject.canRead,    // If we can read, then we go in the holding pen, and trigger an update.
            let owner = internal_owner as? RVS_BTDriver_Device_BLE {
            #if DEBUG
                print("Readable Property Added to Holding Pen: \(inPropertyObject).")
            #endif
            addPropertyToHoldingPen(inPropertyObject)
            owner.peripheral.readValue(for: inPropertyObject.cbCharacteristic)
        } else {    // Otherwise, we go straight into the main list.
            #if DEBUG
                print("Non-Readable Property Added Directly to Main List: \(inPropertyObject).")
            #endif
            addPropertyToMainList(inPropertyObject)
            notifySubscribersOfNewProperty(inPropertyObject)
            
            if internal_holding_pen.isEmpty {
                #if DEBUG
                    print("All Properties Discovered.")
                #endif
                reportCompletion()
            }
        }
    }
}
