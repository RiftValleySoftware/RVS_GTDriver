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
// MARK: - RVS_GTDeviceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol.
 */
public protocol RVS_GTDeviceDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDevice(_ device: RVS_GTDevice, errorEncountered: RVS_GTDriver.Errors)
    
    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     */
    func gtDeviceWillBeRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    func gtDeviceWasRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     */
    func gtDeviceWasConnected(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?)
    
    /* ################################################################## */
    /**
     Called when a device discovers a new service
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter discoveredService: The discovered service.
     */
    func gtDevice(_ device: RVS_GTDevice, discoveredService: RVS_GTService)
    
    /* ################################################################## */
    /**
     Called to indicate that the device's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    func gtDeviceStatusUpdate(_ device: RVS_GTDevice)
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDeviceDelegate Protocol Extension (Optional Methods) -
/* ###################################################################################################################################### */
extension RVS_GTDeviceDelegate {
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     */
    public func gtDeviceWillBeRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    public func gtDeviceWasRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     */
    public func gtDeviceWasConnected(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?) { }

    /* ################################################################## */
    /**
     Called when a device discovers a new service
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter discoveredService: The discovered service.
     */
    public func gtDevice(_ device: RVS_GTDevice, discoveredService: RVS_GTService) { }
    
    /* ################################################################## */
    /**
     Called to indicate that the device's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    public func gtDeviceStatusUpdate(_ device: RVS_GTDevice) { }
}

/* ###################################################################################################################################### */
// MARK: - Individual Device Instance Class -
/* ###################################################################################################################################### */
/**
 This class implements a single discovered goTenna device (in peripheral mode).
 
 This class deliberately doesn't implement a sequence protocol, because we want to keep the details opaque.
 
 The class will offer a complete object model to the API user. We need to abstract all CB stuff.
 
 Since this receives delegate callbacks from CB, it must derive from NSObject.
 */
public class RVS_GTDevice: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the Core Bluetooth peripheral instance that is associated with this object.
     */
    private var _peripheral: CBPeripheral!
    
    /* ################################################################## */
    /**
     This is the driver instance that "owns" this device instance.
     */
    private weak var _owner: RVS_GTDriver!
    
    /* ################################################################## */
    /**
     This is our delegate instance. It is a weak reference.
     */
    private var _delegate: RVS_GTDeviceDelegate!
    
    /* ################################################################## */
    /**
     This is a (yuck) semaphore, indicating that the initial device info connection was made.
     */
    private var _initialized = false
    
    /* ################################################################## */
    /**
     This is a "holding pen" for services that have been discovered, but not yet initialized. They need to be kept around, in order to remain viable.
     */
    private var _holdingPen: [RVS_GTService] = []
    
    /* ################################################################## */
    /**
     This is an Array of our discovered and initialized goTenna services, as represented by instances of RVS_GTService.
     */
    private var _services: [RVS_GTService] = []

    /* ################################################################## */
    /**
     This is the manufacturer name. It will be filled at initialization time.
     */
    private var _manufacturerName: String = ""
    
    /* ################################################################## */
    /**
     This is the "model number." It will be filled at initialization time.
     */
    private var _modelNumber: String = ""
    
    /* ################################################################## */
    /**
     This is the hardware revision. It will be filled at initialization time.
     */
    private var _hardwareRevision: String = ""
    
    /* ################################################################## */
    /**
     This is the firmware revision. It will be filled at initialization time.
     */
    private var _firmwareRevision: String = ""
    
    /* ################################################################## */
    /**
     This is a reference to our internal device info service.
     */
    private var _deviceInfoService: RVS_GTService!

    /* ################################################################## */
    /**
     This is a reference to our internal proprietary goTenna service.
     */
    private var _goTennaService: RVS_GTService!
    
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
     
     - parameter inPeripheral: The peripheral to associate with this instance. This is a strong reference. It cannot be nil or omitted.
     - parameter owner: The driver that "owns" this device. It is a weak reference. It cannot be nil or omitted.
     - parameter delegate: The RVS_GTDeviceDelegate instance. This is a weak reference, but is optional, and can be omitted
     */
    internal init(_ inPeripheral: CBPeripheral, owner inOwner: RVS_GTDriver, delegate inDelegate: RVS_GTDeviceDelegate! = nil) {
        super.init()
        _peripheral = inPeripheral
        _peripheral.delegate = self
        _owner = inOwner
        _delegate = inDelegate
        isConnected = true  // Start our first connection.
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Sequence Support Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    deinit {
        isConnected = false
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Calculated Instance Properties -
/* ###################################################################################################################################### */
extension RVS_GTDevice {
    /* ################################################################## */
    /**
     This returns our peripheral instance.
     */
    internal var peripheral: CBPeripheral! {
        return _peripheral
    }
    
    /* ################################################################## */
    /**
     This is the driver instance that "owns" this device instance.
     */
    internal var owner: RVS_GTDriver {
        return _owner
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice {
    /* ################################################################## */
    /**
     Called to send a connection message to the delegate for this device.
     */
    internal func reportSuccessfulConnection() {
        if !_initialized, nil == _deviceInfoService {  // If we have not yet been initialized, then we straightaway start looking for our device information, which is now available.
            discoverDeviceInfoService()
        } else if _initialized {
            delegate?.gtDeviceWasConnected(self)
        } else {
            reportThisError(.connectionAttemptFailed(error: nil))
        }
    }
    
    /* ################################################################## */
    /**
     Called to send a disconnection event to the device's delegate.
     
     - parameter inError: Any error that may have occurred. It is passed directly to the delegate.
     */
    internal func reportDisconnection(_ inError: Error?) {
        if nil == _goTennaService {  // If we haven't loaded the goTenna service yet, we grab that before reporting a disconnection.
            isConnected = true
        } else {
            delegate?.gtDevice(self, wasDisconnected: inError)
        }
    }
    
    /* ################################################################## */
    /**
     This discovers just the device info service.
     */
    internal func discoverDeviceInfoService() {
        discoverServices([CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoService.rawValue)])
    }
    
    /* ################################################################## */
    /**
     This discovers just the goTenna service.
     */
    internal func discoverGoTennaService() {
        discoverServices([CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary.rawValue)])
    }

    /* ################################################################## */
    /**
     Asks the device to discover specific _services.
     
     - parameter inServiceCBUUIDs: These are the specific UUIDs we are searching for.
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverServices(_ inServiceCBUUIDs: [CBUUID], startClean inStartClean: Bool = false) {
        if inStartClean {
            _services = [] // Start clean
        }
        peripheral.discoverServices(inServiceCBUUIDs)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of its _services.
     
     - parameter startClean: Optional (default is false). If true, then all cached services are cleared before discovery.
     */
    internal func discoverAllServices(startClean inStartClean: Bool = false) {
        if inStartClean {
            _services = [] // Start clean
        }
        peripheral.discoverServices(nil)
    }

    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_GTService) {
        peripheral.discoverCharacteristics(nil, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover all of the characteristics for a given service.
     
     - parameter inService: The service object.
     */
    internal func discoverAllCharacteristicsForService(_ inService: RVS_GTService) {
        peripheral.discoverCharacteristics(nil, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     Asks the device to discover specific characteristics for a given service.
     
     - parameter inService: The service object.
     - parameter characteristicCBUUIDs: An Array of CBUUIDs, with the specific characteristics we're looking for.
     */
    internal func discoverCharacteristicsForService(_ inService: RVS_GTService, characteristicCBUUIDs inUUIDs: [CBUUID]) {
        peripheral.discoverCharacteristics(inUUIDs, for: inService.service)
    }
    
    /* ################################################################## */
    /**
     This is called when a service is done initializing.
     
     - parameter inService: The service object.
     */
    internal func addServiceToList(_ inService: RVS_GTService) {
        #if DEBUG
            print("Adding Service: \(String(describing: inService)) To Our List at index \(_services.count).")
        #endif
        // Remove from the "holding pen."
        if let index = _holdingPen.firstIndex(where: { return $0.service == inService.service }) {
            #if DEBUG
                print("Removing Service: \(String(describing: inService)) From Holding Pen at index \(index).")
            #endif
            _holdingPen.remove(at: index)
        }
        
        _services.append(inService)

        // See if we will load one of our references with this service.
        if inService.service.uuid == CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoService.rawValue) {
            _deviceInfoService = inService
            setUpDeviceInfo()
            delegate?.gtDevice(self, discoveredService: inService)
            discoverGoTennaService()
        } else if inService.service.uuid == CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary.rawValue) {
            _goTennaService = inService
            setUpGoTennaInfo()
            delegate?.gtDevice(self, discoveredService: inService)
        }
        
        // If we are all done with both services, we wrap up the connection, and add ourselves to the driver in an "official" capacity.
        if !_initialized, _holdingPen.isEmpty, nil != _goTennaService, nil != _deviceInfoService {
            _initialized = true
            // We no longer need the device to be connected.
            isConnected = false
            owner.addDeviceToList(self)
        }
    }
    
    /* ################################################################## */
    /**
     This tells the driver to start updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func startNotifyForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.setNotifyValue(true, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to stop updating for the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func stopNotifyForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.setNotifyValue(false, for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This tells the driver to read the value for the given characteristic.
     
     - parameter inCharacteristic: The characteristic object.
     */
    internal func readValueForCharacteristic(_ inCharacteristic: RVS_GTCharacteristic) {
        _peripheral.readValue(for: inCharacteristic.characteristic)
    }
    
    /* ################################################################## */
    /**
     This goes through the device info service, and extracts the four basic device info fields.
     */
    internal func setUpDeviceInfo() {
        // Start by getting the device info object.
        if let deviceInfoService = serviceForThisUUID(CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoService.rawValue)) {
            guard   let manufacturerName = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoManufacturerName.rawValue))?.stringValue
            else {
                reportThisError(.characteristicValueMissing)
                return
            }
            
            #if DEBUG
                print("Read the Manufacturer Name: \(manufacturerName).")
            #endif
            _manufacturerName = manufacturerName
            
            guard   let modelNumber = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoModelName.rawValue))?.stringValue
            else {
                reportThisError(.characteristicValueMissing)
                return
            }
            
            #if DEBUG
                print("Read the Model Number: \(modelNumber).")
            #endif
            _modelNumber = modelNumber
            
            guard   let hardwareRevision = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoHardwareRevision.rawValue))?.stringValue
            else {
                reportThisError(.characteristicValueMissing)
                return
            }
            
            #if DEBUG
                print("Read the Hardware Revision: \(hardwareRevision).")
            #endif
            _hardwareRevision = hardwareRevision
            
            guard   let firmwareRevision = deviceInfoService.characteristicForThisUUID(CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoFirmwareRevision.rawValue))?.stringValue
            else {
                reportThisError(.characteristicValueMissing)
                return
            }
            
            #if DEBUG
                print("Read the Firmaware Revision: \(firmwareRevision).")
            #endif
            _firmwareRevision = firmwareRevision
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
// MARK: - RVS_GTDriverTools Instance Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice: RVS_GTDriverTools {
    /* ################################################################## */
    /**
     This method will "kick the can" up to the driver, where the error will finally be sent to the delegate.
     
     - parameter inError: The error to be sent to the delegate.
     */
    internal func reportThisError(_ inError: RVS_GTDriver.Errors) {
        if let delegate = delegate {    // If we have a delegate, they get first dibs.
            delegate.gtDevice(self, errorEncountered: inError)
        } else {
            owner.reportThisError(inError)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - CBPeripheralDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDevice: CBPeripheralDelegate {
    /* ################################################################## */
    /**
     This searches through our services for the chacarteristic instance that corresponds to the supplied characteristic.
     
     - parameter inCharacteristic: The CBCharacteristic that we want to match to its RVS_GTCharacteristic instance.
     - returns: The instance associated with the CBCharacteristic. Nil, if none.
     */
    internal func getCharacteristicInstanceForCharacteristic(_ inCharacteristic: CBCharacteristic) -> RVS_GTCharacteristic! {
        #if DEBUG
            print("Searching Main List for Characteristic: \(inCharacteristic)")
        #endif
        for service in _services {
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
        return _services.reduce(false) { (inCurrent, inElement) -> Bool in
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
    internal func serviceForThisService(_ inService: CBService) -> RVS_GTService? {
        for service in _services where inService == service.service {
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
    internal func serviceForThisUUID(_ inUUID: CBUUID) -> RVS_GTService? {
        #if DEBUG
            print("Searching for Service for \(String(describing: inUUID)).")
        #endif
        
        for service in _services where inUUID == service.service.uuid {
            #if DEBUG
                print("Service Found.")
            #endif
            return service
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     Called when the device changed its service listing.
     
     THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didModifyServices: Invalidated services (we need to nuke these).
    */
    public func peripheral(_ inPeripheral: CBPeripheral, didModifyServices inInvalidatedServices: [CBService]) {
        for cbService in inInvalidatedServices {
            if  let service = serviceForThisService(cbService),
                let index = _services.firstIndex(of: service) {
                _services.remove(at: index)
            }
            
            // Make sure that our delegates are updated.
            delegate?.gtDeviceStatusUpdate(self)
            owner.sendDeviceUpdateToDelegegate()
            discoverAllServices()   // We discover all services.
        }
    }
    
    /* ################################################################## */
    /**
     Called when we have discovered services for the peripheral.
     
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
            if 0 == services.count {    // We can't have no services.
                reportThisError(.unknownPeripheralDiscoveryError(error: nil))
            }
            for service in services where !containsThisService(service) && !holdingThisService(service) {
                #if DEBUG
                    print("\t***\n")
                    print("\tservice: \(String(describing: service))\n")
                #endif
                var sInstance: RVS_GTService!
                let deviceInfoUUID = CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoService.rawValue)
                let goTennaProprietaryServiceUUID = CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary.rawValue)
                let serviceUUID = service.uuid
                switch serviceUUID {
                case deviceInfoUUID:
                    let initialCharacteristics = [  CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoManufacturerName.rawValue),   // Manufacturer name
                                                    CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoModelName.rawValue),          // Model name
                                                    CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoHardwareRevision.rawValue),   // Hardware Revision
                                                    CBUUID(string: RVS_GT_BLE_GATT_UUID.deviceInfoFirmwareRevision.rawValue)    // Firmware Revision
                    ]
                    sInstance = RVS_GTService(service, owner: self, initialCharacteristics: initialCharacteristics)

                case goTennaProprietaryServiceUUID:
                    let initialCharacteristics = [  CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary001.rawValue),
                                                    CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary002.rawValue),
                                                    CBUUID(string: RVS_GT_BLE_GATT_UUID.goTennaProprietary003.rawValue)
                    ]
                    sInstance = RVS_GTService(service, owner: self, initialCharacteristics: initialCharacteristics)

                default:
                    break
                }
                if let sInstance = sInstance {
                    #if DEBUG
                        print("Adding Service: \(String(describing: sInstance)) To Holding Pen at index \(_holdingPen.count).")
                    #endif
                    _holdingPen.append(sInstance)   // In the holding pen, until we officially add it.
                }
            }
        }
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when we have discovered characteristics for a service.
     
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
    Called when a characteristic state has changed.
    
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
    Called when a characteristic state has changed.
    
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
        
        if let error = inError {
            reportThisError(.unknownCharacteristicsReadValueError(error: error))
        } else if let characteristic = getCharacteristicInstanceForCharacteristic(inCharacteristic) {
            #if DEBUG
                print("Adding Characteristic: \(String(describing: characteristic)) to its service.\n")
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
    Called when a peripheral's name has changed.
    
    THIS IS NOT MEANT FOR API USE. IT IS INTERNAL-USE ONLY.

    - parameter inPeripheral: The peripheral we have received notification on.
    */
    public func peripheralDidUpdateName(_ inPeripheral: CBPeripheral) {
        delegate?.gtDeviceStatusUpdate(self)
    }
}

/* ###################################################################################################################################### */
// MARK: - This is What We Tell the Kids -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the device. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 One other thing about this class, is that it conforms to Sequence, so you can iterate through it for services, or access services as subscripts.
 */
extension RVS_GTDevice {
    /* ################################################################################################################################## */
    // MARK: - Public Calculated Instance Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. It can be nil.
     */
    public var delegate: RVS_GTDeviceDelegate! {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
    
    /* ################################################################## */
    /**
     Return the simple description UUID.
     */
    override public var description: String {
        return String(describing: _manufacturerName + " " + _modelNumber)
    }

    /* ################################################################## */
    /**
     This manages and reports our connection. Changing this value will connect or disconnect this device.
     It is KVO-observable.
     */
    @objc dynamic public var isConnected: Bool {
        get {
            return .connected == peripheral.state
        }
        
        set {
            if newValue && .disconnected == peripheral.state {
                _owner.connectDevice(self)
            } else {
                _owner.disconnectDevice(self)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the manufacturer name. It will be filled at initialization time.
     It is KVO-observable.
     */
    @objc dynamic public var manufacturerName: String {
        return _manufacturerName
    }
    
    /* ################################################################## */
    /**
     This is the "model number." It will be filled at initialization time.
     It is KVO-observable.
     */
    @objc dynamic public var modelNumber: String {
        return _modelNumber
    }
    
    /* ################################################################## */
    /**
     This is the hardware revision. It will be filled at initialization time.
     It is KVO-observable.
     */
    @objc dynamic public var hardwareRevision: String {
        return _hardwareRevision
    }
    
    /* ################################################################## */
    /**
     This is the firmware revision. It will be filled at initialization time.
     It is KVO-observable.
     */
    @objc dynamic public var firmwareRevision: String {
        return _firmwareRevision
    }
    
    /* ################################################################## */
    /**
     This is the unique ID for the peripheral.
     It is KVO-observable.
     */
    @objc dynamic public var id: String {
        if let device = _peripheral {
            return device.identifier.uuidString
        }
        return ""
    }
    
    /* ################################################################## */
    /**
     This is the peripheral's name.
     It is KVO-observable.
     */
    @objc dynamic public var name: String {
        if let device = _peripheral {
            return device.name ?? ""
        }
        return ""
    }

    /* ################################################################## */
    /**
     If you call this, the driver will delete the device, and it will be eligible for rediscovery.
     
     We also call the delegate with the "before and after" calls.
     */
    public func goodbyeCruelWorld() {
        isConnected = false // Make sure that we're not connected anymore.
        delegate?.gtDeviceWillBeRemoved(self)
        owner.removeDeviceFromDriver(self)
        delegate?.gtDeviceWasRemoved(self)
    }
}
