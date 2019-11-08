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

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Service -
/* ###################################################################################################################################### */
/**
 This is a standard service class.
 */
class RVS_BTDriver_Service: RVS_BTDriver_ServiceProtocol {
    /* ################################################################################################################################## */
    // MARK: - Subscriber Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of subscribers.
     */
    internal var internal_subscribers: [RVS_BTDriver_ServiceSubscriberProtocol] = []
    
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_Service Sequence-Style Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains the property list for this instance of the driver.
     */
    internal var internal_holding_pen: [RVS_BTDriver_Property] = []
    
    /* ################################################################## */
    /**
     This contains the property list for this instance of the driver.
     */
    internal var internal_property_list: [RVS_BTDriver_Property] = []
    
    /* ################################################################## */
    /**
     This is a String, holding the service UUID.
     */
    internal var internal_uuid: String! = ""
    
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns" this instance.
     */
    internal weak var internal_owner: RVS_BTDriver_Device!
    
    /* ################################################################## */
    /**
     This is a placeholder for subclasses. This class doesn't do anything.
     
     Subclasses should use this to start a discovery process for their characteristics (properties).
     */
    internal func discoverInitialCharacteristics() { }

    /* ################################################################## */
    /**
     Main initializer.
     
     - parameter owner: The device that "owns" this service.
     - parameter uuid: A String, with the service UUID.
     */
    internal init(owner inOwner: RVS_BTDriver_Device, uuid inUUID: String) {
        internal_uuid = inUUID
        internal_owner = inOwner
    }
    
    /* ################################################################## */
    /**
     Notifies subscribers of a new property.
     This is defined here, so we can override.
     
     - parameter inProperty: The property to notify.
     */
    internal func notifySubscribersOfNewProperty(_ inProperty: RVS_BTDriver_Property) {
        internal_subscribers.forEach {
            $0.service(self, propertyAdded: inProperty)
        }
    }
    
    /* ################################################################## */
    /**
     Notifies subscribers of a status update.
     This is defined here, so we can override.
     */
    internal func notifySubscribersOfStatusUpdate() {
        internal_subscribers.forEach {
            $0.serviceStatusUpdate(self)
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that everything is put back the way we found it...
     */
    deinit {
        internal_subscribers = []
        internal_property_list = []
        internal_holding_pen = []
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Service {
    /* ################################################################## */
    /**
     This method will move a property from the holding pen to the main list.
     
     - parameter inProperty: The property object to be moved.
     */
    internal func movePropertyFromHoldingPenToMainList(_ inProperty: RVS_BTDriver_Property) {
        assert(!internal_holding_pen.isEmpty, "The holding pen is empty!")
        for property in internal_holding_pen where property == inProperty {
            if let index = internal_holding_pen.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                #if DEBUG
                    print("Removing Property at Index \(index) of the Holding Pen, and adding it to the main list at index \(internal_property_list.count).")
                #endif
                
                internal_holding_pen.remove(at: index)
                addPropertyToMainList(inProperty)
                
                notifySubscribersOfNewProperty(inProperty)
                
                if internal_holding_pen.isEmpty {
                    reportCompletion()
                }
            } else {
                assert(false, "Property was not found in the holding pen! This is bad.")
            }
        }
    }
    
    /* ################################################################## */
    /**
     This method will remove a property from the holding pen or the main list.
     
     - parameter inProperty: The property object to be removed.
     */
    internal func removeThisProperty(_ inProperty: RVS_BTDriver_Service) {
        #if DEBUG
            var itWasRemoved = false
        #endif
        for property in internal_holding_pen where property === inProperty {
            if let index = internal_holding_pen.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                #if DEBUG
                    print("Removing Property at Index \(index) of the Holding Pen.")
                #endif
                
                internal_holding_pen.remove(at: index)
                #if DEBUG
                    itWasRemoved = true
                #endif
            }
        }
        
        // If we found it in the holding pen, this should not happen, but better safe than sorry...
        for property in internal_property_list where property === inProperty {
            if let index = internal_property_list.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                #if DEBUG
                    print("Removing Property at Index \(index) of the Main List.")
                #endif
                
                internal_property_list.remove(at: index)
                #if DEBUG
                    itWasRemoved = true
                #endif
            }
        }
        #if DEBUG
            assert(itWasRemoved, "The property was not found!")
        #endif
    }
    
    /* ################################################################## */
    /**
     This method adds a property to the holding pen.
     
     If already there, nothing happens.
     
     - parameter inProperty: The property object to be added.
     */
    internal func addPropertyToHoldingPen(_ inProperty: RVS_BTDriver_Property) {
        // Make sure that we are not in the main list.
        for property in internal_property_list where property === inProperty {
            if let index = internal_property_list.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                assert(false, "Property Already Exists at Index \(index) of the Main List. This is not good.")

                return
            }
        }

        // Make sure that we are not in the holding pen.
        for property in internal_holding_pen where property === inProperty {
            if let index = internal_holding_pen.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                #if DEBUG
                    print("Property Already Exists at Index \(index) of the Holding Pen. Not Adding.")
                #endif
                
                return
            }
        }
        
        #if DEBUG
            print("Adding Property to Holding Pen.")
        #endif
        internal_holding_pen.append(inProperty)
    }
    
    /* ################################################################## */
    /**
     This method adds a property to the main list.
     
     If already there, nothing happens.
     
     - parameter inProperty: The property object to be added.
     */
    internal func addPropertyToMainList(_ inProperty: RVS_BTDriver_Property) {
        // Make sure that we are not in the holding pen.
        for property in internal_holding_pen where property === inProperty {
            if let index = internal_holding_pen.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                assert(false, "Property Already Exists at Index \(index) of the Holding Pen. This is not good.")
                
                return
            }
        }
        
        for property in internal_property_list where property === inProperty {
            if let index = internal_property_list.firstIndex(where: { (pro) -> Bool in
                return pro === inProperty
                }) {
                
                #if DEBUG
                    print("Property Already Exists at Index \(index) of the Main List. Not Adding.")
                #endif
                
                return
            }
        }
        
        #if DEBUG
            print("Adding Property to Main List.")
        #endif
        internal_property_list.append(inProperty)
    }

    /* ################################################################## */
    /**
     Called to report that our holding pen is empty.
     */
    internal func reportCompletion() {
        #if DEBUG
            print("The service is done with its initialization.")
        #endif
        internal_owner.moveServiceFromHoldingPenToMainList(self)
        notifySubscribersOfStatusUpdate()
    }
}

/* ###################################################################################################################################### */
// MARK: - Subscription Support Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Service {
    /* ################################################################## */
    /**
     Test to see if a subscriber is already subscribed.
     
     - parameter inSubscriber: The subscriber to test.
     - returns: True, if the instance is subscribed.
     */
    public func isThisInstanceASubscriber(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) -> Bool {
        return internal_subscribers.reduce(false) { (inCurrent, inNext) -> Bool in
            return inCurrent || inNext.uuid == inSubscriber.uuid
        }
    }

    /* ################################################################## */
    /**
     Add an observer of the service.
     
     It should be noted that subscribers are held as strong references (if they are classes).
     
     - parameter subscriber: The instance to subscribe. Nothing is done, if we are already subscribed.
     */
    public func subscribe(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) {
        if !isThisInstanceASubscriber(inSubscriber) {
            inSubscriber.setUpUUID()
            internal_subscribers.append(inSubscriber)
        }
    }

    /* ################################################################## */
    /**
     remove a subscriber from the list. Nothing happens if the subscriber is not already subscribed.
     
     - parameter subscriber: The instance to unsubscribe. Nothing is done, if we are not already subscribed.
     */
    public func unsubscribe(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) {
        if let index = internal_subscribers.firstIndex(where: {
            $0.uuid == inSubscriber.uuid
        }) {
            internal_subscribers.remove(at: index)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Communicator Support -
/* ###################################################################################################################################### */
/**
 We establish a communicator chain, here.
 */
extension RVS_BTDriver_Service: RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the owner.
     */
    internal func reportThisError(_ inError: RVS_BTDriver.Errors) {
        internal_subscribers.forEach {
            $0.service(self, encounteredThisError: inError)
        }
        
        internal_owner?.reportThisError(inError)
    }
}

/* ###################################################################################################################################### */
// MARK: - Sequence-Style Support -
/* ###################################################################################################################################### */
/**
 Because of the requirement for either: A) iOS 13 or greater, or B) no associated type, we can't have a true Sequence support (we're relying on protocol masking), so we do this.
 */
extension RVS_BTDriver_Service {
    /* ################################################################## */
    /**
     This is the public read-only access to the property list.
     */
    public var properties: [RVS_BTDriver_PropertyProtocol] {
        return internal_property_list
    }
    
    /* ################################################################## */
    /**
     This is the read-only count of properties.
     */
    public var count: Int {
        return internal_property_list.count
    }
    
    /* ################################################################## */
    /**
     This is a public read-only 0-based integer subscript to the property list.
     */
    public subscript(_ inIndex: Int) -> RVS_BTDriver_PropertyProtocol {
        precondition((0..<count).contains(inIndex), "Index Out of Range")
        return properties[inIndex]
    }

    /* ################################################################## */
    /**
     Simple "String Key" subscript, so we can treat the array as a dictionary.
     
     - parameter inStringKey: A String, containing the unique UUID of the property we are looking for.
     
     - returns: The property, or nil, if not found.
     */
    public subscript(_ inStringKey: String) -> RVS_BTDriver_PropertyProtocol! {
        for item in properties where  item.uuid == inStringKey {
            return item
        }
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Service {
    /* ################################################################## */
    /**
     This is the read-only unique ID for this service.
     */
    public var uuid: String {
        return internal_uuid
    }
    
    /* ################################################################## */
    /**
     This refers to the device instance that "owns" this service.
     */
    public var owner: RVS_BTDriver_DeviceProtocol! {
        return internal_owner
    }
}
