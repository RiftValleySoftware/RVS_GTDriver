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
// MARK: - RVS_BTDriver_Device -
/* ###################################################################################################################################### */
/**
 This is one "device," which maps to a bluetooth "peripheral."
 
 Must derive from NSObject, for purposes of being a delegate.
 */
class RVS_BTDriver_Device: NSObject, RVS_BTDriver_DeviceProtocol {
    /* ################################################################################################################################## */
    // MARK: - Subscriber Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the list of subscribers to this instance.
     */
    internal var internal_subscribers: [RVS_BTDriver_DeviceSubscriberProtocol] = []
    
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_Device Sequence-Style Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains instances that have not yet passed a credit check.
     */
    internal var internal_holding_pen: [RVS_BTDriver_Service] = []
    
    /* ################################################################## */
    /**
     This contains the service list for this instance of the driver.
     */
    internal var internal_service_list: [RVS_BTDriver_Service] = []
    
    /* ################################################################## */
    /**
     This is a read-only accessor for the object that "owns," this instance.
     */
    internal weak var internal_owner: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     The interface for this device
     */
    internal var interface: RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     The vendor handler for this device
     */
    internal var vendor: RVS_BTDriver_VendorProtocol!
    
    /* ################################################################## */
    /**
     This is just here to give a handle to subclasses. This class does nothing.
     */
    internal func connect() { }
    
    /* ################################################################## */
    /**
     This is just here to give a handle to subclasses. This class does nothing.
     */
    internal func disconnect() { }

    /* ################################################################## */
    /**
     The device initializer
     
     - parameter vendor: The vendor factory for the device.
     */
    internal init(vendor inVendor: RVS_BTDriver_VendorProtocol) {
        vendor = inVendor
    }
    
    /* ################################################################## */
    /**
     Make sure that we disconnect upon deinit.
     */
    deinit {
        disconnect()
    }
    
    /* ################################################################## */
    /**
     This is a String, containing a unique ID for this peripheral.
     */
    public internal(set) var uuid: String!
    
    /* ################################################################## */
    /**
     A name for the device (may be the model name, may be something else).
     */
    public internal(set) var deviceName: String!

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    public internal(set) var modelName: String!

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    public internal(set) var manufacturerName: String!
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a serial number, it is available here.
     */
    public internal(set) var serialNumber: String!
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    public internal(set) var hardwareRevision: String!
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    public internal(set) var firmwareRevision: String!
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    public internal(set) var softwareRevision: String!
    
    /* ################################################################## */
    /**
     This is the device type. Default is .unTested
     */
    public internal(set) var deviceType: RVS_BTDriver_DeviceType = .unTested

    /* ################################################################## */
    /**
     This is the public flag, determining whether or not the device is connected.
     */
    public var isConnected: Bool = false

    /* ################################################################## */
    /**
     This is true, if the device can be connected.
     */
    public internal(set) var canConnect: Bool  = false

    /* ################################################################## */
    /**
     This refers to the driver instance that "owns" this device.
     */
    var owner: RVS_BTDriver! {
        return internal_owner
    }
    
    /* ################################################################## */
    /**
     This displays a useful debug display of the device data.
     */
    override var description: String {
        var ret =   "Generic Device:\n"
                    + "\tDevice Name:\t\t\(deviceName ?? "NOT AVAILABLE")\n"
                    + "\tManufacturer Name:\t\(manufacturerName ?? "NOT AVAILABLE")\n"
                    + "\tModel Name:\t\t\t\(modelName ?? "NOT AVAILABLE")\n"
                    + "\tSerial Number:\t\t\(serialNumber ?? "NOT AVAILABLE")\n"
                    + "\tHardware Revision:\t\(hardwareRevision ?? "NOT AVAILABLE")\n"
                    + "\tFirmware Revision:\t\(firmwareRevision ?? "NOT AVAILABLE")\n"
                    + "\tSoftware Revision:\t\(softwareRevision ?? "NOT AVAILABLE")\n"
        
        for service in services {
            ret += "\n\tService (\(service.uuid)):\n\(String(describing: service))\n"
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Notifies subscribers of a new service.
     This is defined here, so we can override.

     - parameter inService: The service to notify.
     */
    internal func notifySubscribersOfNewService(_ inService: RVS_BTDriver_Service) {
        internal_subscribers.forEach {
            $0.device(self, serviceAdded: inService)
        }
    }

    /* ################################################################## */
    /**
     Notifies subscribers of a status update.
     This is defined here, so we can ovverride.
     */
    internal func notifySubscribersOfStatusUpdate() {
        internal_subscribers.forEach {
            $0.deviceStatusUpdate(self)
        }
    }
    
    /* ################################################################## */
    /**
     This is declared here, so it can be overridden.
     
     This one does nothing. It should be overridden.
     */
    public func discoverServices() {
        precondition(false, "Cannot Call the Base Instance!")
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Subscript -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     Simple "String Key" subscript, so we can treat the array as a dictionary.
     
     - parameter inStringKey: A String, containing the unique UUID of the service we are looking for.
     
     - returns: The service, or nil, if not found.
     */
    public subscript(_ inStringKey: String) -> RVS_BTDriver_ServiceProtocol! {
        for item in internal_service_list where  item.uuid == inStringKey {
            return item
        }
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Subscription Support Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     Test to see if a subscriber is already subscribed.
     
     - parameter inSubscriber: The subscriber to test.
     - returns: True, if the instance is subscribed.
     */
    public func isThisInstanceASubscriber(_ inSubscriber: RVS_BTDriver_DeviceSubscriberProtocol) -> Bool {
        return internal_subscribers.reduce(false) { (inCurrent, inNext) -> Bool in
            return inCurrent || inNext.uuid == inSubscriber.uuid
        }
    }
    
    /* ################################################################## */
    /**
     Add an observer of the device.
     
     It should be noted that subscribers are held as strong references (if they are classes).
     
     - parameter subscriber: The instance to subscribe. Nothing is done, if we are already subscribed.
     */
    public func subscribe(_ inSubscriber: RVS_BTDriver_DeviceSubscriberProtocol) {
        if !isThisInstanceASubscriber(inSubscriber) {
            internal_subscribers.append(inSubscriber)
        }
    }

    /* ################################################################## */
    /**
     remove a subscriber from the list. Nothing happens if the subscriber is not already subscribed.
     
     - parameter subscriber: The instance to unsubscribe. Nothing is done, if we are not already subscribed.
     */
    public func unsubscribe(_ inSubscriber: RVS_BTDriver_DeviceSubscriberProtocol) {
        if let index = internal_subscribers.firstIndex(where: {
            $0.uuid == inSubscriber.uuid
        }) {
            internal_subscribers.remove(at: index)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     This method will move a service from the holding pen to the main list.
     
     - parameter inService: The service object to be moved.
     */
    internal func moveServiceFromHoldingPenToMainList(_ inService: RVS_BTDriver_Service) {
        for service in internal_holding_pen where service === inService {
            if let index = internal_holding_pen.firstIndex(where: { (ser) -> Bool in
                return ser === inService
                }) {
                
                #if DEBUG
                print("Removing Service (\(inService.uuid)) at Index \(index) of the Holding Pen, and adding it to the main list at index \(internal_service_list.count).")
                #endif
                
                internal_holding_pen.remove(at: index)
                internal_service_list.append(service)
                
                notifySubscribersOfNewService(service)
                notifySubscribersOfStatusUpdate()
                break
            } else {
                assert(false, "Service was not found in the holding pen!")
                return
            }
        }
        
        if internal_holding_pen.isEmpty {
            #if DEBUG
                print("All Services Discovered.")
            #endif
            reportCompletion()
        }
    }
    
    /* ################################################################## */
    /**
     This method will remove a service from the holding pen or the main list.
     
     - parameter inService: The service object to be removed.
     */
    internal func removeThisService(_ inService: RVS_BTDriver_Service) {
        #if DEBUG
            var itWasRemoved = false
        #endif
        for service in internal_holding_pen where service === inService {
            if let index = internal_holding_pen.firstIndex(where: { (ser) -> Bool in
                return ser === inService
                }) {
                
                #if DEBUG
                    print("Removing Service at Index \(index) of the Holding Pen.")
                #endif
                
                internal_holding_pen.remove(at: index)
                #if DEBUG
                    itWasRemoved = true
                #endif
            }
        }
        
        // If we found it in the holding pen, this should not happen, but better safe than sorry...
        for service in internal_service_list where service === inService {
            if let index = internal_service_list.firstIndex(where: { (ser) -> Bool in
                return ser === inService
                }) {
                
                #if DEBUG
                    print("Removing Service at Index \(index) of the Main List.")
                #endif
                
                internal_service_list.remove(at: index)
                #if DEBUG
                    itWasRemoved = true
                #endif
            }
        }
        
        #if DEBUG
            assert(itWasRemoved, "The service was not found!")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called to report that our holding pen is empty.
     */
    internal func reportCompletion() {
        #if DEBUG
            print("The device is done with its initialization.")
        #endif
        
        internal_owner.moveDeviceFromHoldingPenToMainList(self)
        if !internal_owner.internal_stayConnected {
            disconnect()
        }
        notifySubscribersOfStatusUpdate()
    }
}

/* ###################################################################################################################################### */
// MARK: - Communicator Support -
/* ###################################################################################################################################### */
/**
 We establish a communicator chain, here.
 */
extension RVS_BTDriver_Device: RVS_BTDriverCommunicatorTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the subscribers, and up the chain.
     */
    public func reportThisError(_ inError: RVS_BTDriver.Errors) {
        internal_subscribers.forEach {
            $0.device(self, encounteredThisError: inError)
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
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     This is the public read-only access to the service list.
     */
    public var services: [RVS_BTDriver_ServiceProtocol] {
        return internal_service_list
    }
    
    /* ################################################################## */
    /**
     This is the read-only count of services.
     */
    public var count: Int {
        return internal_service_list.count
    }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the service list.
     */
    public subscript(_ inIndex: Int) -> RVS_BTDriver_ServiceProtocol {
        precondition((0..<count).contains(inIndex), "Index Out of Range")
        return services[inIndex]
    }
}
