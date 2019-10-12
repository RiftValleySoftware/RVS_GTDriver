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
public protocol RVS_BTDriver_ServiceSubscriberProtocol {
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_ServiceProtocol {
    /* ################################################################## */
    /**
     This is the public read-only access to the properties list.
     */
    var properties: [RVS_BTDriver_PropertyProtocol] { get }
    
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
