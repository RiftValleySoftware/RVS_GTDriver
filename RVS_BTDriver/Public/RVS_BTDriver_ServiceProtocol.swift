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
// MARK: - RVS_BTDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_ServiceSubscriberProtocol: RVS_BTDriver_SubscriberProtocol {
    /* ################################################################## */
    /**
     REQUIRED: Error reporting method.
     
     - parameter service: The `RVS_BTDriver_ServiceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func service(_ service: RVS_BTDriver_ServiceProtocol, encounteredThisError: RVS_BTDriver.Errors)
    
    /* ################################################################## */
    /**
     OPTIONAL: Called When a property is added to the main list.
     
     - parameter service: The `RVS_BTDriver_ServiceProtocol` instance that has the service.
     - parameter propertyAdded: The `RVS_BTDriver_PropertyProtocol` property that was added.
     */
    func service(_ service: RVS_BTDriver_ServiceProtocol, propertyAdded: RVS_BTDriver_PropertyProtocol)
    
    /* ################################################################## */
    /**
     OPTIONAL: Called to indicate that the service's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter service: The `RVS_BTDriver_ServiceProtocol` instance calling this.
     */
    func serviceStatusUpdate(_ service: RVS_BTDriver_ServiceProtocol)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_ServiceSubscriberProtocol Default Implementations -
/* ###################################################################################################################################### */
extension RVS_BTDriver_ServiceSubscriberProtocol {
    /* ################################################################## */
    /**
     Default does nothing.
     */
    func device(_ service: RVS_BTDriver_ServiceProtocol, propertyAdded: RVS_BTDriver_ServiceProtocol) { }
    
    /* ################################################################## */
    /**
     Default does nothing.
     */
    func serviceStatusUpdate(_ service: RVS_BTDriver_ServiceProtocol) { }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_ServiceProtocol: class {
    /* ################################################################## */
    /**
     This is the public read-only access to the properties list.
     */
    var properties: [RVS_BTDriver_PropertyProtocol] { get }
    
    /* ################################################################## */
    /**
     This is the read-only unique ID for this service.
     */
    var uuid: String { get }
    
    /* ################################################################## */
    /**
     This is the read-only count of properties.
     */
    var count: Int { get }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the property list.
     */
    subscript(_ inIndex: Int) -> RVS_BTDriver_PropertyProtocol { get }
    
    /* ################################################################## */
    /**
     Test to see if a subscriber is already subscribed.
     
     - parameter subscriber: The subscriber to test.
     - returns: True, if the instance is subscribed.
     */
    func isThisInstanceASubscriber(_ subscriber: RVS_BTDriver_ServiceSubscriberProtocol) -> Bool

    /* ################################################################## */
    /**
     Add an observer of the service.
     
     It should be noted that subscribers are held as strong references (if they are classes).
     
     - parameter subscriber: The instance to subscribe. Nothing is done, if we are already subscribed.
     */
    func subscribe(_ subscriber: RVS_BTDriver_ServiceSubscriberProtocol)
    
    /* ################################################################## */
    /**
     remove a subscriber from the list. Nothing happens if the subscriber is not already subscribed.
     
     - parameter subscriber: The instance to unsubscribe. Nothing is done, if we are not already subscribed.
     */
    func unsubscribe(_ subscriber: RVS_BTDriver_ServiceSubscriberProtocol)
}
