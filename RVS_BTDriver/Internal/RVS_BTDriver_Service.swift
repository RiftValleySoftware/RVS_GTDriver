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
 */
class RVS_BTDriver_Service: RVS_BTDriver_ServiceProtocol {
    /* ################################################################## */
    /**
     This is an Array of subscribers.
     */
    private var _subscribers: [RVS_BTDriver_ServiceSubscriberProtocol] = []
    
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_Service Sequence-Style Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains the property list for this instance of the driver.
     */
    private var _property_list: [RVS_BTDriver_PropertyProtocol] = []
    
    /* ################################################################## */
    /**
     This is a String, holding the service UUID.
     */
    internal var internal_uuid: String! = ""
    
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns" this instance.
     */
    internal var internal_owner: RVS_BTDriver_Device!
    
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
     This is a placeholder for subclasses. This class doesn't do anything.
     
     Subclasses should use this to start a discovery process for their characteristics (properties).
     */
    internal func discoverInitialCharacteristics() { }
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
    func isThisInstanceASubscriber(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) -> Bool {
        return _subscribers.reduce(false) { (inCurrent, inNext) -> Bool in
            return inCurrent || inNext.uuid == inSubscriber.uuid
        }
    }

    /* ################################################################## */
    /**
     Add an observer of the service.
     
     It should be noted that subscribers are held as strong references (if they are classes).
     
     - parameter subscriber: The instance to subscribe. Nothing is done, if we are already subscribed.
     */
    func subscribe(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) {
        if !isThisInstanceASubscriber(inSubscriber) {
            _subscribers.append(inSubscriber)
        }
    }

    /* ################################################################## */
    /**
     remove a subscriber from the list. Nothing happens if the subscriber is not already subscribed.
     
     - parameter subscriber: The instance to unsubscribe. Nothing is done, if we are not already subscribed.
     */
    func unsubscribe(_ inSubscriber: RVS_BTDriver_ServiceSubscriberProtocol) {
        if let index = _subscribers.firstIndex(where: {
            $0.uuid == inSubscriber.uuid
        }) {
            _subscribers.remove(at: index)
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
        return _property_list
    }
    
    /* ################################################################## */
    /**
     This is the read-only count of properties.
     */
    public var count: Int {
        return _property_list.count
    }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the property list.
     */
    public subscript(_ inIndex: Int) -> RVS_BTDriver_PropertyProtocol {
        precondition((0..<count).contains(inIndex), "Index Out of Range")
        return properties[inIndex]
    }
}
