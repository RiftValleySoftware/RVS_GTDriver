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
// MARK: - RVS_BTDriver_Base_Interface_BT_Classic -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_Interface_BT_Classic: RVS_BTDriver_Base_Interface {
    /* ###################################################################################################################################### */
    // MARK: - Internal Structs -
    /* ###################################################################################################################################### */
    /// This is a simple struct to transfer interface information between the interface and the vendor device implementation.
    internal struct DeviceInfoStruct {
        /// The peripheral (BLE)
        let peripheral: CBPeripheral
        /// The central BLE manager
        let centralManager: CBCentralManager
        /// Any advertising data supplied with the discovery.
        let advertisementData: [String: Any]
    }
    
    /* ###################################################################################################################################### */
    // MARK: - Internal Types -
    /* ###################################################################################################################################### */
    /// This is how we get the information for creating our device instance.
    /// The peripheral instance and the central manager instance are passed in.
    internal typealias DeviceInfo = DeviceInfoStruct
    
    /* ################################################################## */
    /**
     Holds our SINGLETON
    */
    internal static var internal_interface: RVS_BTDriver_InterfaceProtocol!
    
    /* ################################################################## */
    /**
     The manager instance associated with this interface. There is only one.
    */
    internal var centralManager: CBCentralManager!

    /* ################################################################## */
    /**
     This will create the SINGLETON, if it is not already created, or simply returns the one we have.
     */
    internal static var interface: RVS_BTDriver_InterfaceProtocol! {
        if nil == internal_interface {
            internal_interface = RVS_BTDriver_Interface_BT_Classic()
        }
        
        return internal_interface
    }
    
    /* ################################################################## */
    /**
     This will create the SINGLETON, if it is not already created, or simply returns the one we have.
     
     - parameter queue: The thread o use. Default is nil (main thread).
     */
    internal static func makeInterface(queue inQueue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol! {
        if nil == internal_interface {
            internal_interface = RVS_BTDriver_Interface_BT_Classic(queue: inQueue)
        }
        
        return internal_interface
    }
    
    /* ################################################################## */
    /**
     Start or stop the scan for new peripherals.
     */
    override internal var isScanning: Bool {
        get {
            #if DEBUG
                if nil == centralManager {
                    print("The Central Manager Instance is Nil")
                } else {
                    print("The Central Manager Instance is \(centralManager.isScanning ? "" : "not ")currently scanning.")
                }
            #endif
            return centralManager?.isScanning ?? false
        }
        
        set {
            if !(centralManager?.isScanning ?? false), newValue {
                var serviceUUIDs: [CBUUID]!
                
                // We supply any service UUIDs that we have on hand.
                if !serviceSignatures.isEmpty {
                    serviceUUIDs = serviceSignatures.compactMap {
                        CBUUID(string: $0)
                    }
                }
                
                // We check to see if we are going to be filtering out previous advertised devices (cuts down the noise).
                let options: [String: Any]! = rememberAdvertisedDevices ? [CBCentralManagerScanOptionAllowDuplicatesKey: 1] : nil
                
                centralManager?.scanForPeripherals(withServices: serviceUUIDs, options: options)
            } else if centralManager?.isScanning ?? false {
                centralManager?.stopScan()
            }
            
            #if DEBUG
                if nil == centralManager {
                    print("The Central Manager Instance is Nil")
                } else {
                    print("The Central Manager Instance is \(centralManager.isScanning ? "now" : "no longer") scanning.")
                }
            #endif
        }
    }

    /* ################################################################## */
    /**
     If true, then Bluetooth is available (powered on).
     */
    override internal var isBTAvailable: Bool {
        if  let centralManager = centralManager,
            .poweredOn == centralManager.state {
            #if DEBUG
                print("Central Manager State: \(centralManager.state)")
            #endif
            return true
        }
        #if DEBUG
            print("No Central Manager, or Manager State is: \(String(describing: centralManager?.state))")
        #endif

        return false
    }
    
    /* ################################################################## */
    /**
     Main initializer.
     
     - parameter queue: The thread o use. Default is nil (main thread).
    */
    init(queue inQueue: DispatchQueue! = nil) {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: inQueue)
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Interface_BT_Classic -
/* ###################################################################################################################################### */
/**
 This is an interface for Bluetooth Low Energy (BLE), using CoreBluetooth.
 */
extension RVS_BTDriver_Interface_BT_Classic: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Callback for when the central manager changes state.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
    */
    func centralManagerDidUpdateState(_ inCentral: CBCentralManager) {
        // We are allowed to not have a central manager set up quite yet, but if we do, it needs to be us.
        assert(nil == centralManager || inCentral === centralManager, "Central Manager Not Ours!")
        #if DEBUG
            if nil == centralManager {
                print("We have not yet initialized our own Central Manager.")
            }
            print("The Central Manager: \(inCentral) has changed state.")
        #endif
        switch inCentral.state {
        case .poweredOff:   // If we get a powered off event, that means there's "issues," and we should report an error.
            driver?.reportThisError(.bluetoothNotAvailable)
        default:
            driver?.sendInterfaceUpdate(self)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Device_BT_Classic -
/* ###################################################################################################################################### */
/**
 This is a specialized class for BLE devices (peripherals).
 */
class RVS_BTDriver_Device_BT_Classic: RVS_BTDriver_Device {
    /// The central manager that controls this peripheral.
    internal var centralManager: CBCentralManager!
    
    /// The peripheral instance associated with this device.
    var peripheral: CBPeripheral!
    
    /// The initial state (unititialized).
    private var _state: RVS_BTDriver_State_Machine_StateEnum = .uninitialized
    
    /// These are the services that we look up upon initialization connection.
    internal var internal_initalServiceDiscovery: [CBUUID] = []

    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_BLE_Device Internal Base Class Override Calculated Properties -
    /* ################################################################################################################################## */
    /**
     These need to be declared here, as they are overrides of stored properties.
     */
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    override public internal(set) var modelName: String! {
        get {
            if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.modelNumberString.rawValue)?.rawValue {
                return String(data: propertyValue, encoding: .utf8)
            }
            
            return nil
        }
        
        set {
            _ = newValue
        }
    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    override public internal(set) var manufacturerName: String! {
       get {
           if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.manufacturerNameString.rawValue)?.rawValue {
               return String(data: propertyValue, encoding: .utf8)
           }
           
           return nil
       }
       
       set {
           _ = newValue
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a serial number, it is available here.
     */
    override public internal(set) var serialNumber: String! {
       get {
           if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.serialNumberString.rawValue)?.rawValue {
               return String(data: propertyValue, encoding: .utf8)
           }
           
           return nil
       }
       
       set {
           _ = newValue
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    override public internal(set) var hardwareRevision: String! {
       get {
           if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.hardwareRevisionString.rawValue)?.rawValue {
               return String(data: propertyValue, encoding: .utf8)
           }
           
           return nil
       }
       
       set {
           _ = newValue
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    override public internal(set) var firmwareRevision: String! {
       get {
           if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.firmwareRevisionString.rawValue)?.rawValue {
               return String(data: propertyValue, encoding: .utf8)
           }
           
           return nil
       }
       
       set {
           _ = newValue
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    override public internal(set) var softwareRevision: String! {
       get {
           if let propertyValue = propertyInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.softwareRevisionString.rawValue)?.rawValue {
               return String(data: propertyValue, encoding: .utf8)
           }
           
           return nil
       }
       
       set {
           _ = newValue
       }
   }
    
    /* ################################################################## */
    /**
     Connection indicator.
     
     - returns: true, if the peripheral is currently connected.
     */
    override internal var isConnected: Bool {
        get {
            return .connected == peripheral.state
        }
        
        set {
            if newValue {
                connect()
            } else {
                disconnect()
            }
        }
    }

    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_BLE_Device Internal Base Class Override Methods -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called to initiate a connection.
    */
    override internal func connect() {
        if .disconnected == peripheral.state { // Must be completely disconnected
            #if DEBUG
                print("Connecting the device: \(String(describing: self))")
            #endif
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    /* ################################################################## */
    /**
     Called to close a connection.
    */
    override internal func disconnect() {
        if .disconnected != peripheral.state { // This applies everywhere except when explicitly disconnected.
            #if DEBUG
                print("Disonnecting the device: \(String(describing: self))")
            #endif
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_BLE_Device Internal Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device_BT_Classic {
    /* ################################################################## */
    /**
     This searches the device, and returns a service that "owns" the given characteristic.
     
     - parameter inCBCharacteristic: The CoreBluetooth Characteristic we are matching.
     
     - returns: The Service instance for the characteristic. Nil, if it can't be matched.
     */
    internal func serviceInstanceForCBCharacteristic(_ inCBCharacteristic: CBCharacteristic) -> RVS_BTDriver_Service_BLE! {
        for serviceInstance in internal_holding_pen {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    return serviceInstance
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    return serviceInstance
                }
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This searches the device, and returns a property that "owns" the given characteristic.
     
     - parameter inCBCharacteristic: The CoreBluetooth Characteristic we are matching.
     
     - returns: The Property instance for the characteristic. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBCharacteristic(_ inCBCharacteristic: CBCharacteristic) -> RVS_BTDriver_Property_BLE! {
        for serviceInstance in internal_holding_pen {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    return serviceInstance.propertyInstanceForCBCharacteristic(inCBCharacteristic)
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    return serviceInstance.propertyInstanceForCBCharacteristic(inCBCharacteristic)
                }
            }
        }

        return nil
    }
    
    /* ################################################################## */
    /**
     This searches the device, and returns a property that "owns" the given characteristic, identified by its UUID (as a String).
     
     - parameter inUUIDString: The CoreBluetooth Characteristic UID (as a String) we are matching.
     
     - returns: The Property instance for the UID. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBUUID(_ inUUIDString: String) -> RVS_BTDriver_Property_BLE! {
        for serviceInstance in internal_holding_pen {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if let propertyInstance = serviceInstance.propertyInstanceForCBUUID(inUUIDString) {
                    return propertyInstance
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if let propertyInstance = serviceInstance.propertyInstanceForCBUUID(inUUIDString) {
                    return propertyInstance
                }
            }
        }

        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - State Machine Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
extension RVS_BTDriver_Device_BT_Classic: RVS_BTDriver_State_Machine {
    /* ################################################################## */
    /**
     The current state of this instance.
     */
    internal var state: RVS_BTDriver_State_Machine_StateEnum {
        return _state
    }

    /* ################################################################## */
    /**
     Start initialization.
     */
    internal func startInit() {
        #if DEBUG
            print("Starting initialization of a BLE device: \(String(describing: self))")
        #endif
        _state = .initializationInProgress
        connect()
    }
    
    /* ################################################################## */
    /**
     Called if there was a connection, before initializing.
     */
    internal func connectedPreInit() {
        #if DEBUG
            print("CONNECTED (BLE Pre-Init)")
        #endif
        if .initializationInProgress == _state {
            // If we are initializing, then we create service objects for our services, and add them to the holding pen.
            internal_initalServiceDiscovery.forEach {
                switch $0.uuidString {
                case RVS_BTDriver_Interface_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue:
                    internal_holding_pen.append(RVS_BTDriver_Service_DeviceInfo_BLE(owner: self, uuid: $0.uuidString))
                    
                default:
                    internal_holding_pen.append(RVS_BTDriver_Service_BLE(owner: self, uuid: $0.uuidString))
                }
            }
            // Then we tell the device to discover these services.
            peripheral.discoverServices(internal_initalServiceDiscovery)
        }
    }
    
    /* ################################################################## */
    /**
     Called if there was a service discovery event, before initializing.
     */
    internal func discoveryPreInit() {
    }

    /* ################################################################## */
    /**
     Abort initialization.
     */
    internal func abortInit() {
    }
    
    /* ################################################################## */
    /**
     Called if there was a connection, after initializing.
     */
    func connectedPostInit() {
        #if DEBUG
            print("CONNECTED (BLE Post-Init)")
        #endif
        notifySubscribersOfStatusUpdate()
    }
    
    /* ################################################################## */
    /**
     Called if there was a disconnection, after initializing.
     */
    func disconnectedPostInit() {
        #if DEBUG
            print("DISCONNECTED (BLE Post-Init)")
        #endif
        notifySubscribersOfStatusUpdate()
    }
}

/* ###################################################################################################################################### */
// MARK: - Core Bluetooth Peripheral Delegate Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
extension RVS_BTDriver_Device_BT_Classic: CBPeripheralDelegate {
    /* ################################################################## */
    /**
     Called when we have discovered services for the peripheral.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverServices: Any errors that ocurred.
    */
    internal func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        assert(inPeripheral === peripheral, "Wrong Peripheral!")
        if let error = inError {
            #if DEBUG
                print("\n***> Service Discovery Error: \(String(describing: inError))\n")
            #endif
            reportThisError(.unknownPeripheralDiscoveryError(error: error))
        } else if let services = inPeripheral.services {
            #if DEBUG
                print("\n***> Services Discovered:\n\t\(String(describing: services))")
            #endif
            func getHoldingPenInstanceForThisService(_ inService: CBService) -> RVS_BTDriver_Service_BLE! {
                for serviceInstance in internal_holding_pen where serviceInstance.internal_uuid == inService.uuid.uuidString {
                    return serviceInstance as? RVS_BTDriver_Service_BLE ?? nil
                }
                return nil
            }
            
            for service in services {
                if let serviceInstance = getHoldingPenInstanceForThisService(service) {
                    serviceInstance.cbService = service
                    serviceInstance.internal_uuid = service.uuid.uuidString
                    serviceInstance.discoverInitialCharacteristics()
                }
            }
        } else {
            #if DEBUG
                print("\n***> No services.\n")
            #endif
        }
        
        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when the peripheral is ready.
     
     - parameter inPeripheral: The peripheral that owns this service.
     - parameter inService: The service with the characteristics that have been discovered.
     - parameter error: Any error that may have occurred. It can be nil.
    */
    func peripheral(_ inPeripheral: CBPeripheral, didDiscoverCharacteristicsFor inService: CBService, error inError: Error?) {
        assert(inPeripheral === peripheral, "Wrong Peripheral!")
        if let error = inError {
            #if DEBUG
                print("\n***> Characteristic Discovery Error: \(String(describing: inError))\n")
            #endif
            reportThisError(.unknownCharacteristicsDiscoveryError(error: error))
        } else if   let characteristics = inService.characteristics,
                    !characteristics.isEmpty {
            #if DEBUG
                print("\n***> Discovered Characteristics: \(String(describing: characteristics))\n")
            #endif
            
            for characteristic in characteristics {
                let property = RVS_BTDriver_Property_BLE()
                property.cbCharacteristic = characteristic
                #if DEBUG
                    print("\tNew Characteristic for \(inService): \(String(describing: characteristic))\n")
                #endif
                
                if let service = serviceInstanceForCBCharacteristic(characteristic) {
                    let property = RVS_BTDriver_Property_BLE()
                    #if DEBUG
                        print("Property Added: \(property) to Service: \(service).")
                    #endif
                    property.cbCharacteristic = characteristic
                    property.uuid = characteristic.uuid.uuidString
                    property.rawValue = characteristic.value
                    property.internal_owner = service
                    service.addPropertyToList(property)
                }
            }
        } else {
            #if DEBUG
                print("\n***> No characteristics.\n")
            #endif
        }

        #if DEBUG
            print("<***\n")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when the peripheral is ready.
     
    - parameter toSendWriteWithoutResponse: The peripheral that is ready.
    */
    internal func peripheralIsReady(toSendWriteWithoutResponse inPeripheral: CBPeripheral) {
        assert(inPeripheral === peripheral, "Wrong Peripheral!")
        #if DEBUG
            print("Peripheral Is Ready: \(inPeripheral)")
        #endif
    }
    
    /* ################################################################## */
    /**
    - parameter inPeripheral: The peripheral that owns this service.
    - parameter didUpdateValueFor: The characteristic that was updated.
    - parameter error: Any error that may have occurred. It can be nil.
    */
    func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        assert(inPeripheral === peripheral, "Wrong Peripheral!")
        #if DEBUG
            print("Peripheral  \(inPeripheral) Received an Update for This Characteristic: \(inCharacteristic), with this Error: \(String(describing: inError)).")
        #endif
        
        if let property = propertyInstanceForCBCharacteristic(inCharacteristic) {
            #if DEBUG
                print("Property Updated: \(property).")
            
                if property.isInitialized {
                    print("\tProperty Has Been Initialized.")
                } else {
                    print("\tProperty Has Not Yet Been Initialized.")
                }
            #endif
            
            property.executeUpdate()
        } else {
            assert(false, "Property Not Found for Characteristic: \(inCharacteristic)!")
        }
    }
}
