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
// MARK: - Individual Device Instance Class -
/* ###################################################################################################################################### */
/**
 This class models a single discovered BLE device (in [peripheral](https://developer.apple.com/documentation/corebluetooth/cbperipheral) mode).
 
 The class will offer a complete object model of the device to the API user. We need to abstract all [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth) stuff.

 This class deliberately doesn't conform to a sequence protocol, because we want to keep the details opaque.
 
 Since this receives delegate callbacks from [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth), it must derive from [NSObject](https://developer.apple.com/documentation/objectivec/1418956-nsobject?language=occ).
 */
public class RVS_BLEDevice: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a (yuck) semaphore, indicating that the initial device info connection was made.
     */
    private var _initialized = false
    
    /* ################################################################## */
    /**
     This is a "holding pen" for services that have been discovered, but not yet initialized. They need to be kept around, in order to remain viable.
     */
    private var _holdingPen: [RVS_BLEService] = []
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna services, as represented by instances of RVS_BLEService.
     */
    internal var internal_services: [RVS_BLEService] = []

    /* ################################################################## */
    /**
     This is a reference to our internal device info service.
     */
    internal var deviceInfoService: RVS_BLEService!

    /* ################################################################## */
    /**
     This is the Core Bluetooth peripheral instance that is associated with this object.
     */
    internal var internal_peripheral: CBPeripheral!
    
    /* ################################################################## */
    /**
     This is the driver instance that "owns" this device instance.
     */
    internal weak var internal_owner: RVS_BLEDriver!
    
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    internal var internal_delegate: RVS_BLEDeviceDelegate!
    
    /* ################################################################## */
    /**
     This is the manufacturer name. It will be filled at initialization time.
     */
    internal var internal_manufacturerName: String = ""
    
    /* ################################################################## */
    /**
     This is the "model number." It will be filled at initialization time.
     */
    internal var internal_modelNumber: String = ""
    
    /* ################################################################## */
    /**
     This is the hardware revision. It will be filled at initialization time.
     */
    internal var internal_hardwareRevision: String = ""
    
    /* ################################################################## */
    /**
     This is the firmware revision. It will be filled at initialization time.
     */
    internal var internal_firmwareRevision: String = ""
    
    /* ################################################################## */
    /**
     This is a flag that tells us to remain connected continuously, until explicitly disconnected by the user. Default is false.
     */
    internal var internal_stayConnected: Bool = false
    
    /* ################################################################################################################################## */
    // MARK: - Private Initializer
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     We declare this private, so we force the driver to instantiate with a peripheral and an owner.
     */
    private override init() { }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Initializers
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Initializer with a peripheral instance and an owner.
     
     - parameter inPeripheral: The Core Bluetooth peripheral to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The driver that "owns" this device. It is a weak reference. It cannot be nil or omitted.
     - parameter delegate: The RVS_BLEDeviceDelegate instance. This is a weak reference, but is optional, and can be omitted
     - parameter remainConnected: If true, then connections will persist until explicitly closed by the user. This is optional. Default is false.
     */
    internal init(_ inPeripheral: CBPeripheral, owner inOwner: RVS_BLEDriver, delegate inDelegate: RVS_BLEDeviceDelegate! = nil, remainConnected inRemainConnected: Bool = false) {
        super.init()
        internal_peripheral = inPeripheral
        internal_peripheral.delegate = self
        internal_owner = inOwner
        internal_delegate = inDelegate
        internal_stayConnected = inRemainConnected
        isConnected = true
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDevice: RVS_BLEDriverTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_BLEDriver.Errors) {
        if let delegate = delegate {    // If we have a delegate, they get first dibs.
            delegate.gtDevice(self, errorEncountered: inError)
        } else {
            internal_owner.reportThisError(inError)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Core Bluetooth Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDevice {
    /* ################################################################################################################################## */
    // MARK: - Internal Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called to send a connection message to the delegate for this device.
     */
    internal func reportSuccessfulConnection() {
        if !_initialized, nil == deviceInfoService {  // If we have not yet been initialized, then we straightaway start looking for our device information, which is now available.
            discoverDeviceInfoService()
        } else if _initialized {
            delegate?.gtDeviceWasConnected(self)
        }
    }
    
    /* ################################################################## */
    /**
     Called to send a disconnection event to the device's delegate.
     
     - parameter inError: Any error that may have occurred. It is passed directly to the delegate.
     */
    internal func reportDisconnection(_ inError: Error?) {
        delegate?.gtDevice(self, wasDisconnected: inError)
    }
    
    /* ################################################################## */
    /**
     This is called when a service is done initializing.
     
     - parameter inService: The service object.
     */
    internal func addServiceToList(_ inService: RVS_BLEService) {
        #if DEBUG
            print("Adding Service: \(String(describing: inService)) To Our List at index \(internal_services.count).")
        #endif
        // Remove from the "holding pen."
        if let index = _holdingPen.firstIndex(where: { return $0.service == inService.service }) {
            #if DEBUG
                print("Removing Service: \(String(describing: inService)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        
        internal_services.append(inService)

        // See if we will load one of our references with this service.
        if inService.service.uuid == CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) {
            deviceInfoService = inService
            setUpDeviceInfo()
        }
        
        // If we are all done with both services, we wrap up the connection, and add ourselves to the driver in an "official" capacity.
        if !_initialized, _holdingPen.isEmpty, nil != deviceInfoService {
            _initialized = true
            // We no longer need the device to be connected, but won't disconnect, if we are to stay connected.
            isConnected = shouldStayConnected
            internal_owner.addDeviceToList(self)
        }
    }
    
    /* ################################################################## */
    /**
     This tells the driver to start updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func startNotifyForCharacteristic(_ inCharacteristic: RVS_BLECharacteristic) {
        internal_peripheral.setNotifyValue(true, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to stop updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func stopNotifyForCharacteristic(_ inCharacteristic: RVS_BLECharacteristic) {
        internal_peripheral.setNotifyValue(false, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to read the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func readValueForCharacteristic(_ inCharacteristic: RVS_BLECharacteristic) {
        internal_peripheral.readValue(for: inCharacteristic.characteristic)
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Discovery Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This discovers just the device info service.
     */
    internal func discoverDeviceInfoService() {
        discoverServices([CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoService.rawValue)])
    }
    
    /* ################################################################## */
    /**
     This discovers just the goTenna service.
     */
    internal func discoverGoTennaService() {
        discoverServices([CBUUID(string: RVS_BLEDevice_DeviceSpec_goTenna.RVS_BLE_GATT_UUID.goTennaProprietary.rawValue)])
    }

    /* ################################################################## */
    /**
     Asks the device to discover specific internal_services.
     
     - parameter inServiceCBUUIDs: These are the specific UUIDs we are searching for.
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverServices(_ inServiceCBUUIDs: [CBUUID], startClean inStartClean: Bool = false) {
        if inStartClean {
            internal_services = [] // Start clean
        }
        internal_peripheral.discoverServices(inServiceCBUUIDs)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover specific characteristics for a given service.
     
     - parameter inService: The service object.
     - parameter characteristicCBUUIDs: An Array of CBUUIDs, with the specific characteristics we're looking for.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_BLEService, characteristicCBUUIDs inUUIDs: [CBUUID]) {
        internal_peripheral.discoverCharacteristics(inUUIDs, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of its internal_services.
     
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverAllServices(startClean inStartClean: Bool = false) {
        if inStartClean {
            internal_services = [] // Start clean
        }
        internal_peripheral.discoverServices(nil)
    }

    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_BLEService) {
        internal_peripheral.discoverCharacteristics(nil, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverAllCharacteristicsForService(_ inService: RVS_BLEService) {
        internal_peripheral.discoverCharacteristics(nil, for: inService.service)
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Service Setup Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This goes through the device info service, and extracts the four basic device info fields.
     */
    internal func setUpDeviceInfo() {
        // Start by getting the device info object.
        if let deviceInfoService = serviceForThisUUID(CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoService.rawValue)) {
            if let manufacturerName = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoManufacturerName.rawValue))?.stringValue {
                #if DEBUG
                    print("Read the Manufacturer Name: \(manufacturerName).")
                #endif
                internal_manufacturerName = manufacturerName
            }
            
            if let modelNumber = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoModelName.rawValue))?.stringValue {
                #if DEBUG
                    print("Read the Model Number: \(modelNumber).")
                #endif
                internal_modelNumber = modelNumber
            }
            
            if let hardwareRevision = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoHardwareRevision.rawValue))?.stringValue {
                #if DEBUG
                    print("Read the Hardware Revision: \(hardwareRevision).")
                #endif
                internal_hardwareRevision = hardwareRevision
            }
            
            if let firmwareRevision = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_BLE_DeviceInfo_Service.RVS_BLE_GATT_UUID.deviceInfoFirmwareRevision.rawValue))?.stringValue {
                #if DEBUG
                    print("Read the Firmaware Revision: \(firmwareRevision).")
                #endif
                internal_firmwareRevision = firmwareRevision
            }
        }
    }
    
    /* ################################################################## */
    /**
     This goes through the goTenna service and exctracts the information from it.
     */
    internal func setUpGoTennaInfo() {
        
    }
}

/* ###################################################################################################################################### */
// MARK: - CBPeripheralDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDevice: CBPeripheralDelegate {
    /* ################################################################################################################################## */
    // MARK: - Internal Utility Methods for Callbacks
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This searches through our services for the chacarteristic instance that corresponds to the supplied characteristic.
     
     - parameter inCharacteristic: The CBCharacteristic that we want to match to its RVS_BLECharacteristic instance.
     - returns: The instance associated with the CBCharacteristic. Nil, if none.
     */
    internal func getCharacteristicInstanceForCharacteristic(_ inCharacteristic: CBCharacteristic) -> RVS_BLECharacteristic! {
        #if DEBUG
            print("Searching Main List for Characteristic: \(inCharacteristic)")
        #endif
        for service in internal_services {
            if let characteristic = service.characteristicForThisCharacteristic(inCharacteristic) {
                #if DEBUG
                    print("Characteristic: \(inCharacteristic) Found in Main List.")
                #endif
                return characteristic
            }
        }
        
        #if DEBUG
            print("Searching Holding Pen for Characteristic: \(inCharacteristic)")
        #endif
        for service in _holdingPen {
            if let characteristic = service.characteristicForThisCharacteristic(inCharacteristic) {
                #if DEBUG
                    print("Characteristic: \(inCharacteristic) Found in Holding Pen.")
                #endif
                return characteristic
            }
        }

        #if DEBUG
            print("Characteristic Not Found.")
        #endif
        return nil
    }
    
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service, but it has not yet been added to our main cache.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: True, if the "holding pen" currently has an instance of the peripheral cached.
     */
    internal func holdingThisService(_ inService: CBService) -> Bool {
        return _holdingPen.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let service = inElement.service else { return inCurrent }
            return inService == service
        }
    }
    
    /* ################################################################## */
    /**
     Use this to see if we have already allocated and cached a service instance for the given service.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: True, if the driver currently has an instance of the peripheral cached.
     */
    internal func containsThisService(_ inService: CBService) -> Bool {
        return internal_services.reduce(false) { (inCurrent, inElement) -> Bool in
            guard !inCurrent, let service = inElement.service else { return inCurrent }
            return inService == service
        }
    }
    
    /* ################################################################## */
    /**
     Return the service from our cached Array that corresponds to the given service.
     This checks our "holding pen," as well as our main array.
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inService: The service we are looking for.
     - returns: The service. Nil, if not found.
     */
    internal func serviceForThisService(_ inService: CBService) -> RVS_BLEService? {
        for service in internal_services where inService == service.service {
            return service
        }
        
        for service in _holdingPen where inService == service.service {
            return service
        }

        return nil
    }
    
    /* ################################################################## */
    /**
     Return the service from our cached Array that corresponds to the given service.
     This DOES NOT check the "holding pen."
     This is contained here, because we are trying to encapsulate the "pure" CoreBluetooth stuff as much as possible.
     
     - parameter inUUID: The UUID of the service we are looking for.
     - returns: The service. Nil, if not found.
     */
    internal func serviceForThisUUID(_ inUUID: CBUUID) -> RVS_BLEService? {
        #if DEBUG
            print("Searching for Service for \(String(describing: inUUID)).")
        #endif
        
        for service in internal_services where inUUID == service.service.uuid {
            #if DEBUG
                print("Service Found.")
            #endif
            return service
        }
        
        return nil
    }

    /* ################################################################################################################################## */
    // MARK: - Public CBPeripheral Callbacks
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     :nodoc: Called when the device changed its service listing.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didModifyServices: Invalidated services (we need to nuke these).
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didModifyServices inInvalidatedServices: [CBService]) {
        for cbService in inInvalidatedServices {
            if  let service = serviceForThisService(cbService),
                let index = internal_services.firstIndex(of: service) {
                internal_services.remove(at: index)
            }
            
            // Make sure that our delegates are updated.
            delegate?.gtDeviceStatusUpdate(self)
            internal_owner.sendDeviceUpdateToDelegegate()
            discoverAllServices()   // We discover all services.
        }
    }
    
    /* ################################################################## */
    /**
     :nodoc: Called when we have discovered services for the peripheral.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverServices: Any errors that ocurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        #if DEBUG
            print("\n***> Services Discovered:\n\t\(String(describing: inPeripheral.services))")
            print("\terror: \(String(describing: inError))\n")
        #endif
        if let error = inError {
            reportThisError(.unknownPeripheralDiscoveryError(error: error))
        } else if let services = inPeripheral.services {
            for service in services where !containsThisService(service) && !holdingThisService(service) {
                #if DEBUG
                    print("\t***\n")
                    print("\tservice: \(String(describing: service))\n")
                #endif
                var sInstance: RVS_BLEService!
                
                for handler in RVS_BLEDriver.handlers {
                    if let service = handler.handleDiscoveredService(service, forPeripheral: inPeripheral, andDevice: self) {
                        sInstance = service
                    }
                }

                if let sInstance = sInstance {
                    #if DEBUG
                        print("Adding Service: \(String(describing: sInstance)) To Holding Pen at index \(_holdingPen.count).")
                    #endif
                    _holdingPen.append(sInstance)   // In the holding pen, until we officially add it.
                }
            }
        } else {
            #if DEBUG
                print("\tNo services. Just disconnecting.\n")
            #endif
            disconnect()
        }
        
        #if DEBUG
            print("<***\n")
        #endif
    }
    /* ################################################################## */
    /**
     :nodoc: Called when we have discovered services for the peripheral.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverIncludedServicesFor: The service that includes the services.
    - parameter error: Any error that ocurred.
    */
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor inService: CBService, error inError: Error?) {
        #if DEBUG
            print("\n***> Included Services Discovered:\n\t\(String(describing: inService.includedServices))")
            print("\terror: \(String(describing: inError))\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     :nodoc: Called when we have discovered characteristics for a service.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverCharacteristicsFor: The service object.
     - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didDiscoverCharacteristicsFor inService: CBService, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristics Detected:")
            print("\tdidDiscoverCharacteristicsFor: \(String(describing: inService))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        if let error = inError {
            reportThisError(.unknownCharacteristicsDiscoveryError(error: error))
        } else {
            // Make sure that we have at least one characteristic, and we can find our service.
            guard   let service = serviceForThisService(inService),
                    0 < (inService.characteristics?.count ?? 0) else {
                reportThisError(.unknownCharacteristicsDiscoveryError(error: nil))
                return
            }
            if let characteristics = inService.characteristics {
               for characteristic in characteristics where nil == service.characteristicForThisCharacteristic(characteristic) {
                   service.interimCharacteristic(characteristic)
               }
           }
        }
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     :nodoc: Called when a characteristic state has changed.
    
    THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

    - parameter inPeripheral: The peripheral we have received notification on.
    - parameter didUpdateNotificationStateFor: The characteristic object.
    - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didUpdateNotificationStateFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristic State Change Detected:")
            print("\tdidUpdateNotificationStateFor: \(String(describing: inCharacteristic))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        if let error = inError {
            reportThisError(.unknownCharacteristicsReadValueError(error: error))
        } else if let characteristic = getCharacteristicInstanceForCharacteristic(inCharacteristic) {
            characteristic.owner.addCharacteristic(characteristic)
        } else {
            reportThisError(.unknownCharacteristicsReadValueError(error: nil))
        }
    }
    
    /* ################################################################## */
    /**
    :nodoc: Called when a characteristic state has changed.
    
    THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

    - parameter inPeripheral: The peripheral we have received notification on.
    - parameter didUpdateNotificationStateFor: The characteristic object.
    - parameter error: Any errors that occurred.
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("\n***> Characteristic Value Updated:")
            print("\tdidUpdateValueFor: \(String(describing: inCharacteristic))\n")
            print("\t***\n")
            print("\terror: \(String(describing: inError))\n")
        #endif
        
        if  let nserror = inError as NSError? {
            reportThisError(.unknownCharacteristicsReadValueError(error: nserror))
        } else if let characteristic = getCharacteristicInstanceForCharacteristic(inCharacteristic) {
            #if DEBUG
                let chrDescription = characteristic.description
                print("Adding Characteristic: \(chrDescription) to its service.\n")
            #endif
            characteristic.owner.addCharacteristic(characteristic)
        } else {
            reportThisError(.unknownCharacteristicsReadValueError(error: nil))
        }
        
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
    :nodoc: Called when a peripheral's name has changed.
    
    THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

    - parameter inPeripheral: The peripheral we have received notification on.
    */
    public func peripheralDidUpdateName(_ inPeripheral: CBPeripheral) {
        delegate?.gtDeviceStatusUpdate(self)
    }
    
    /* ################################################################## */
    /**
     :nodoc: Return the simple description (Manufacturer name, model and ID).
     */
    override public var description: String {
        return String(describing: internal_manufacturerName + " " + internal_modelNumber + " " + id)
    }
}
