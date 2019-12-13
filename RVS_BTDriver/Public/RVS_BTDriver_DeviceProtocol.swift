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
// MARK: - RVS_BTDriver_DeviceType Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to help identify what the device is.
 */
public enum RVS_BTDriver_DeviceType {
    /// The goTenna Mesh device
    case goTennaMesh
    /// A generic OBD device
    case genericOBD
    /// An OBD device, based on the MHCP chipset.
    case mhcpOBD
    /// An OBD device, based on the VLINK chipset.
    case bt826n
    /// An OBD device, based on the LELink chipset.
    case leLink
    /// The device is unknown, and untested.
    case unTested
    /// The device is unknown.
    case unknown
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_DeviceSubscriberProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This is a protocol for classes, structs or enums that want to "subscribe" to a device.
 */
public protocol RVS_BTDriver_DeviceSubscriberProtocol: RVS_BTDriver_SubscriberProtocol {
    /* ################################################################## */
    /**
     REQUIRED: Error reporting method.
     
     - parameter device: The `RVS_BTDriver_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func device(_ device: RVS_BTDriver_DeviceProtocol, encounteredThisError: RVS_BTDriver.Errors)
    
    /* ################################################################## */
    /**
     OPTIONAL: Called When a service is added to the main list.
     
     - parameter device: The `RVS_BTDriver_DeviceProtocol` instance that has the service.
     - parameter serviceAdded: The `RVS_BTDriver_ServiceProtocol` service that was added.
     */
    func device(_ device: RVS_BTDriver_DeviceProtocol, serviceAdded: RVS_BTDriver_ServiceProtocol)
    
    /* ################################################################## */
    /**
     OPTIONAL: Called to indicate that the device's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The `RVS_BTDriver_DeviceProtocol` instance calling this.
     */
    func deviceStatusUpdate(_ device: RVS_BTDriver_DeviceProtocol)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_ServiceProtocol Default Implementations -
/* ###################################################################################################################################### */
extension RVS_BTDriver_DeviceSubscriberProtocol {
    /* ################################################################## */
    /**
     Default does nothing.
     */
    public func device(_ device: RVS_BTDriver_DeviceProtocol, serviceAdded: RVS_BTDriver_ServiceProtocol) { }
    
    /* ################################################################## */
    /**
     Default does nothing.
     */
    public func deviceStatusUpdate(_ device: RVS_BTDriver_DeviceProtocol) { }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_DeviceProtocol Protocol (Aggregates Services) -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_BTDriver_DeviceProtocol: class {
    /* ################################################################## */
    /**
     This refers to the driver instance that "owns" this device.
     */
    var owner: RVS_BTDriver! { get }
    
    /* ################################################################## */
    /**
     This is a String, containing a unique ID for this peripheral.
     */
    var uuid: String! { get }
    
    /* ################################################################## */
    /**
     A name for the device (may be the model name, may be something else).
     */
    var deviceName: String! { get }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    var modelName: String! { get }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    var manufacturerName: String! { get }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    var serialNumber: String! { get }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    var hardwareRevision: String! { get }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    var firmwareRevision: String! { get }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    var softwareRevision: String! { get }
    
    /* ################################################################## */
    /**
     This is the public read-only access to the service list.
     */
    var services: [RVS_BTDriver_ServiceProtocol] { get }
    
    /* ################################################################## */
    /**
     This is the public flag, determining whether or not the device is connected.
     */
    var isConnected: Bool { get set }
    
    /* ################################################################## */
    /**
     This is the public flag, displaying whether or not the device can be connected.
     */
    var canConnect: Bool { get }

    /* ################################################################## */
    /**
     This is the read-only count of services.
     */
    var count: Int { get }
    
    /* ################################################################## */
    /**
     This is the device type. Default is .unTested
     If the device is still being tested, then this will return .testing.
     .testing and .unTested can be considered the same as .unknown, but things may change, once testing is complete.
     */
    var deviceType: RVS_BTDriver_DeviceType { get }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the service list.
     */
    subscript(_ inIndex: Int) -> RVS_BTDriver_ServiceProtocol { get }
    
    /* ################################################################## */
    /**
     Test to see if a subscriber is already subscribed.
     
     - parameter subscriber: The subscriber to test.
     - returns: True, if the instance is subscribed.
     */
    func isThisInstanceASubscriber(_ subscriber: RVS_BTDriver_DeviceSubscriberProtocol) -> Bool

    /* ################################################################## */
    /**
     Add an observer of the device.
     
     It should be noted that subscribers are held as strong references (if they are classes).
     
     - parameter subscriber: The instance to subscribe. Nothing is done, if we are already subscribed.
     */
    func subscribe(_ subscriber: RVS_BTDriver_DeviceSubscriberProtocol)
    
    /* ################################################################## */
    /**
     remove a subscriber from the list. Nothing happens if the subscriber is not already subscribed.
     
     - parameter subscriber: The instance to unsubscribe. Nothing is done, if we are not already subscribed.
     */
    func unsubscribe(_ subscriber: RVS_BTDriver_DeviceSubscriberProtocol)
}
