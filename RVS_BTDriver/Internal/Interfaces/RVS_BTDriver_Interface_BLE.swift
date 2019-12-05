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
// MARK: - RVS_BTDriver_Base_Interface_BLE -
/* ###################################################################################################################################### */
/**
 This is an interface for Bluetooth Low Energy (BLE), using CoreBluetooth.
 */
internal class RVS_BTDriver_Interface_BLE: RVS_BTDriver_Base_Interface {
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
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the signal strength range. Optimal is -50.
     */
    private let _RSSI_range = -80..<(-30)
    
    /* ################################################################## */
    /**
     Holds our SINGLETON
    */
    internal static var internal_interface: RVS_BTDriver_InterfaceProtocol!

    /* ################################################################## */
    /**
     This will create the SINGLETON, if it is not already created, or simply returns the one we have.
     
     - parameter queue: The thread o use. Default is nil (main thread).
     */
    internal static func makeInterface(queue inQueue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol! {
        if nil == internal_interface {
            internal_interface = RVS_BTDriver_Interface_BLE(queue: inQueue)
        }
        
        return internal_interface
    }
    
    /* ################################################################## */
    /**
     The manager instance associated with this interface. There is only one.
    */
    internal var centralManager: CBCentralManager!
    
    /* ################################################################## */
    /**
     Main initializer.
     
     - parameter queue: The thread to use. Default is nil (main thread).
    */
    internal init(queue inQueue: DispatchQueue! = nil) {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: inQueue)
    }
    
    /* ################################################################## */
    /**
     Clean up after ourselves.
    */
    deinit {
        centralManager = nil
    }
    
    /* ################################################################## */
    /**
     If true, then Bluetooth is available (powered on).
     */
    override internal var isBTAvailable: Bool {
        if  let centralManager = centralManager,
            .poweredOn == centralManager.state {
            return true
        }
        
        return false
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
     Read-only accessor for the interface.
     
     - returns: An instance of the interface for this type of device. Can be nil, if `makeInterface(:)` has not yet been called.
     */
    internal var interface: RVS_BTDriver_InterfaceProtocol! {
        return type(of: self).internal_interface
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Base_Interface_BLE -
/* ###################################################################################################################################### */
/**
 This is an interface for Bluetooth Low Energy (BLE), using CoreBluetooth.
 */
extension RVS_BTDriver_Interface_BLE: CBCentralManagerDelegate {
    /* ################################################################## */
    /**
     Callback for when the central manager changes state.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
    */
    internal func centralManagerDidUpdateState(_ inCentral: CBCentralManager) {
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
    
    /* ################################################################## */
    /**
     Callback for a connection failing.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter didFailToConnect: The peripheral object that failed to connect.
     - parameter error: The error that occurred during the failure. May be nil.
    */
    internal func centralManager(_ inCentral: CBCentralManager, didFailToConnect inPeripheral: CBPeripheral, error inError: Error?) {
        #if DEBUG
            print("Central Manager: \(inCentral) failed to connect to: \(inPeripheral). The error was: \(String(describing: inError)).")
        #endif
    }
    
    /* ################################################################## */
    /**
     Callback for a device discovered during scanning.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter didDiscover: The peripheral object that was discovered.
     - parameter advertidementData: A String-keyed Dictionary of advertisement data for the peripheral.
     - parameter rssi: The signal strength of the Bluetooh signal, in dB.
    */
    internal func centralManager(_ inCentral: CBCentralManager, didDiscover inPeripheral: CBPeripheral, advertisementData inAdvertisementData: [String: Any], rssi inRSSI: NSNumber) {
        #if DEBUG
            print("Peripheral Discovered: \(String(describing: inPeripheral))")
            print("\tAdvertisement Data: \(String(describing: inAdvertisementData))")
            print("\tSignal Strength: \(inRSSI)dB")
        #endif
        
        // Check to make sure the signal is strong enough.
        guard _RSSI_range.contains(inRSSI.intValue) else {
            #if DEBUG
                print("\tSignal is out of range (\(inRSSI.intValue)) for peripheral: \(inPeripheral).")
            #endif
            return
        }
        
        // Check to make sure that we are connectable.
        guard 1 == inAdvertisementData[CBAdvertisementDataIsConnectable] as? Int else {
            #if DEBUG
                print("\tPeripheral: \(inPeripheral) is not connectable.")
                print("\tAdvertisement Data: \(String(describing: inAdvertisementData))")
            #endif
            return
        }
        
        // Make sure that we don't already have this peripheral in our main list.
        for device in driver {
            if  let device = device as? RVS_BTDriver_Device_BLE,
                device.uuid == inPeripheral.identifier.uuidString {
                #if DEBUG
                    print("\tWe already have this peripheral in the main list.")
                #endif
                return
            }
        }
        
        // Make sure that we don't already have this peripheral in our holding pen.
        for device in driver.internal_holding_pen {
            if  let device = device as? RVS_BTDriver_Device_BLE,
                device.uuid == inPeripheral.identifier.uuidString {
                #if DEBUG
                    print("\tWe already have this peripheral in the holding pen.")
                #endif
                return
            }
        }

        // If we made it here, we are a valid device, and ready for inspection.
        for vendor in vendors {
            if let device = vendor.makeDevice(DeviceInfo(peripheral: inPeripheral, centralManager: inCentral, advertisementData: inAdvertisementData)) {
                #if DEBUG
                    print("\tVendor: \(vendor) has created a device to handle this peripheral: \(inPeripheral).")
                #endif
                driver.addDiscoveredDevice(device)
                device.isConnected = true   // We connect, in order to start service discovery.
                break
            }
        }
    }
    
    /* ################################################################## */
    /**
     Called when a peripheral connects.

     - parameter inCentral: The manager instance.
     - parameter didConnect: The peripheral that was successfully connected.
    */
    internal func centralManager(_ inCentral: CBCentralManager, didConnect inPeripheral: CBPeripheral) {
        #if DEBUG
            print("Central Manager: \(inCentral) has connected to this peripheral: \(inPeripheral).")
        #endif
        
        // Scan through the instantiated (but not stored) devices in the holding pen.
        for device in driver.internal_holding_pen where device is RVS_BTDriver_Device_BLE {
            if  let bleDevice = device as? RVS_BTDriver_Device_BLE,
                inCentral == centralManager,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
                bleDevice.connectedPreInit()
                return
            }
        }
        
        // Scan through the stored devices
        for device in driver where device is RVS_BTDriver_Device_BLE {
            if  let bleDevice = device as? RVS_BTDriver_Device_BLE,
                inCentral == centralManager,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
                bleDevice.connectedPostInit()
            }
        }
    }

    /* ################################################################## */
    /**
     Callback for a disconnection.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter didDisconnectPeripheral: The peripheral object that was disconnected.
     - parameter error: Any error that occurred during the disconnection. May be nil.
    */
    internal func centralManager(_ inCentral: CBCentralManager, didDisconnectPeripheral inPeripheral: CBPeripheral, error inError: Error?) {
        #if DEBUG
            var suffix = ""
            if let errVal = inError {
                suffix = ", with this Error: \(String(describing: errVal))"
            }
            print("Central Manager: \(inCentral) has received a disconnection event for this peripheral: \(inPeripheral)\(suffix).")
        #endif
        // Scan through the stored devices
        for device in driver where device is RVS_BTDriver_Device_BLE {
            if  let bleDevice = device as? RVS_BTDriver_Device_BLE,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
                bleDevice.disconnectedPostInit()
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Device_BLE -
/* ###################################################################################################################################### */
/**
 This is a specialized class for BLE devices (peripherals).
 */
class RVS_BTDriver_Device_BLE: RVS_BTDriver_Device {
    /// The central manager that controls this peripheral.
    internal var centralManager: CBCentralManager!
    
    /// The peripheral instance associated with this device.
    var peripheral: CBPeripheral!
    
    /// The initial state (unititialized).
    private var _state: RVS_BTDriver_State_Machine_StateEnum = .uninitialized
    
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_BLE_Device Internal Base Class Override Computed Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     If the device has a Device Info service, we access the service instance here.
     */
    var deviceInfoService: RVS_BTDriver_Service_DeviceInfo_BLE! {
        return nil
    }

    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_BLE_Device Internal Base Class Override Computed Properties -
    /* ################################################################################################################################## */
    /**
     These need to be declared here, as they are overrides of stored properties.
     */
    /* ################################################################## */
    /**
     A name for the device (may be the model name, may be something else).
     */
    override public internal(set) var deviceName: String! {
        get {
            if let name = peripheral?.name {
                return name
            }
            
            return modelName
        }
        
        set {
            _ = newValue
        }
    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    override public internal(set) var modelName: String! {
        get {
            if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
                return service.modelName
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
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.manufacturerName
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
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.serialNumber
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
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.hardwareRevision
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
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.firmwareRevision
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
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.softwareRevision
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
        precondition(canConnect, "Device Cannot be Connected!")
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
                print("Disconnecting the device: \(String(describing: self))")
            #endif
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /* ################################################################## */
    /**
     This one does nothing. It should be overridden.
     */
    override public func discoverServices() {
        if .initializationInProgress == _state {
            // We tell the device to discover all services.
            #if DEBUG
                print("Discovering all services for the device: \(String(describing: self))")
            #endif
            peripheral.discoverServices(nil)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_BLE_Device Internal Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device_BLE {
    /* ################################################################## */
    /**
     This searches the device, and returns a service that "owns" the given characteristic.
     
     - parameter inCBCharacteristic: The CoreBluetooth Characteristic we are matching.
     
     - returns: The Service instance for the characteristic. Nil, if it can't be matched.
     */
    internal func serviceInstanceForCBCharacteristic(_ inCBCharacteristic: CBCharacteristic) -> RVS_BTDriver_Service_BLE! {
        for serviceInstance in internal_holding_pen {
            #if DEBUG
                print("\tHolding Pen Service: \(serviceInstance.uuid)")
            #endif
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    #if DEBUG
                        print("Service: \(serviceInstance) found in the holding pen for the characteristic: \(inCBCharacteristic)\n")
                    #endif
                    return serviceInstance
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            #if DEBUG
                print("\tMain List Service: \(serviceInstance.uuid)")
            #endif
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    #if DEBUG
                        print("Service: \(serviceInstance) found in main list for the characteristic: \(inCBCharacteristic)\n")
                    #endif
                    return serviceInstance
                }
            }
        }
        
        #if DEBUG
            print("No Service for this characteristic: \(inCBCharacteristic)\n")
        #endif
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This searches the device, and returns a service that has a certain UUID.
     
     - parameter inUUIDString: A String, with the UUID we are searching for.
     
     - returns: The Service instance for the UUID. Nil, if it can't be matched.
     */
    internal func serviceInstanceForCBUUID(_ inUUIDString: String) -> RVS_BTDriver_Service_BLE! {
        #if DEBUG
            print("Searching for a service instance for this UUID: \(inUUIDString)")
        #endif
        
        for serviceInstance in internal_holding_pen {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                #if DEBUG
                    print("\tHolding Pen Service: \(serviceInstance.uuid)")
                #endif
                if serviceInstance.uuid == inUUIDString {
                    #if DEBUG
                        print("Found Holding Pen Service: \(serviceInstance.uuid)\n")
                    #endif
                    return serviceInstance
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                #if DEBUG
                    print("\tMain List Service: \(serviceInstance.uuid)")
                #endif
                if serviceInstance.uuid == inUUIDString {
                    #if DEBUG
                        print("Found Main List Service: \(serviceInstance.uuid)\n")
                    #endif
                    return serviceInstance
                }
            }
        }
        
        #if DEBUG
            print("No Service for this UUID: \(inUUIDString)\n")
        #endif

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
            #if DEBUG
                print("\tHolding Pen Service: \(serviceInstance.uuid)")
            #endif
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    #if DEBUG
                        print("\tSearching For Holding Pen Property for Characteristic: \(inCBCharacteristic)\n")
                    #endif
                    
                    if let property = serviceInstance.propertyInstanceForCBCharacteristic(inCBCharacteristic) {
                        #if DEBUG
                            print("Found Holding Pen Property: \(property)\n")
                        #endif
                        return property
                    }
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            #if DEBUG
                print("\tMain List Service: \(serviceInstance.uuid)")
            #endif
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                if serviceInstance.cbService === inCBCharacteristic.service {
                    #if DEBUG
                        print("\tSearching For Main List Property for Characteristic: \(inCBCharacteristic)\n")
                    #endif
                    
                    if let property = serviceInstance.propertyInstanceForCBCharacteristic(inCBCharacteristic) {
                        #if DEBUG
                            print("Found Main List Property: \(property)\n")
                        #endif
                        return property
                    }
                }
            }
        }
        
        #if DEBUG
            print("No Property for this characteristic: \(inCBCharacteristic)\n")
        #endif

        return nil
    }
    
    /* ################################################################## */
    /**
     This searches the device, and returns a property that "owns" the given characteristic, identified by its UUID (as a String).
     
     - parameter inUUIDString: The CoreBluetooth Characteristic UID (as a String) we are matching.
     
     - returns: The Property instance for the UID. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBUUID(_ inUUIDString: String) -> RVS_BTDriver_Property_BLE! {
        #if DEBUG
            print("Searching for a property instance for this UUID: \(inUUIDString)\n")
        #endif
        
        for serviceInstance in internal_holding_pen {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                #if DEBUG
                    print("\tHolding Pen Service: \(serviceInstance.uuid)")
                #endif
                if let propertyInstance = serviceInstance.propertyInstanceForCBUUID(inUUIDString) {
                    #if DEBUG
                        print("Found Holding Pen Property: \(propertyInstance.uuid)")
                    #endif
                    return propertyInstance
                }
            }
        }
        
        for serviceInstance in internal_service_list {
            if let serviceInstance = serviceInstance as? RVS_BTDriver_Service_BLE {
                #if DEBUG
                    print("\tMain List Service: \(serviceInstance.uuid)")
                #endif
                if let propertyInstance = serviceInstance.propertyInstanceForCBUUID(inUUIDString) {
                    #if DEBUG
                        print("Found Main List Property: \(propertyInstance.uuid)\n")
                    #endif
                    return propertyInstance
                }
            }
        }
        
        #if DEBUG
            print("No property for this UUID: \(inUUIDString)\n")
        #endif

        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - State Machine Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
extension RVS_BTDriver_Device_BLE: RVS_BTDriver_State_Machine {
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
        discoverServices()
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
    internal func connectedPostInit() {
        #if DEBUG
            print("CONNECTED (BLE Post-Init)")
        #endif
        notifySubscribersOfStatusUpdate()
    }
    
    /* ################################################################## */
    /**
     Called if there was a disconnection, after initializing.
     */
    internal func disconnectedPostInit() {
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
extension RVS_BTDriver_Device_BLE: CBPeripheralDelegate {
    /* ################################################################## */
    /**
     Called when we have discovered services for the peripheral.

     - parameter inPeripheral: The peripheral we have received notification on.
     - parameter didDiscoverServices: Any errors that ocurred.
    */
    internal func peripheral(_ inPeripheral: CBPeripheral, didDiscoverServices inError: Error?) {
        /* ################################################################## */
        /**
         This searches the holding pen for instances of a given Service object.
         
         - parameter inService: The service object we're looking for.
         - returns: tre, if we already have the service.
        */
        func getHoldingPenInstanceForThisService(_ inService: CBService) -> RVS_BTDriver_Service_BLE! {
            for serviceInstance in internal_holding_pen where serviceInstance.internal_uuid == inService.uuid.uuidString {
                return serviceInstance as? RVS_BTDriver_Service_BLE
            }
            return nil
        }
        
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
            
            for service in services {
                var serviceInstance: RVS_BTDriver_Service_BLE!
                
                // If we have not discovered the service, we need to create a new instance of the service, and add it to the holding pen, first.
                if nil == getHoldingPenInstanceForThisService(service) {
                    if service.uuid.uuidString == RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue {
                        #if DEBUG
                            print("Creating DeviceInfo Service.")
                        #endif
                        serviceInstance = RVS_BTDriver_Service_DeviceInfo_BLE(owner: self, uuid: service.uuid.uuidString)
                        
                        serviceInstance.cbService = service
                    } else {
                        #if DEBUG
                            print("Creating Vendor-specific Service.")
                        #endif
                        serviceInstance = vendor?.makeService(service, forDevice: self) as? RVS_BTDriver_Service_BLE
                    }
                    
                    #if DEBUG
                        print("Discovering Initial Characteristics for this Service: \(String(describing: serviceInstance.internal_uuid))")
                    #endif
                    
                    internal_holding_pen.append(serviceInstance)
                } else {
                    // If we already have the service in our holding pen, we don't need to do anything more. Bug out.
                    #if DEBUG
                        print("Service already in holding pen.")
                    #endif
                }
            }
            
            // After we have catalogued everything, then we start the process of discovering characteristics.
            for serviceInstance in internal_holding_pen {
                serviceInstance.discoverInitialCharacteristics()
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
    internal func peripheral(_ inPeripheral: CBPeripheral, didDiscoverCharacteristicsFor inService: CBService, error inError: Error?) {
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
    internal func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        assert(inPeripheral === peripheral, "Wrong Peripheral!")
        #if DEBUG
            var suffix = ""
            if let errVal = inError {
                suffix = ", with this Error: \(String(describing: errVal))"
            }
            print("Peripheral  \(inPeripheral) Received an Update for This Characteristic: \(inCharacteristic)\(suffix).")
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
    override internal func discoverInitialCharacteristics() {
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

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for BLE -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Property_BLE: RVS_BTDriver_Property {
    /// The CB characteristic associated with this instance.
    internal var cbCharacteristic: CBCharacteristic!
    
    /* ################################################################## */
    /**
     - returns: The User description (if any) as a String. Nil, if none.
     */
    internal var descriptorString: String! {
        if let descriptors = cbCharacteristic?.descriptors {
            for descriptor in descriptors where CBUUIDCharacteristicUserDescriptionString == descriptor.uuid.uuidString {
                return descriptor.value as? String
            }
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is called when the property is updated.
     We use this to set the value.
     */
    override internal func executeUpdate() {
        rawValue = self.cbCharacteristic.value
        #if DEBUG
            print("Property : \(String(describing: self)) added a property: \(String(describing: rawValue)).")
        #endif
        super.executeUpdate()   // This will move the updated property from the holding pen (if it is still there), into the main array.
    }

    /* ################################################################## */
    /**
     - returns: The user description of the property, including any capabilities.
     */
    override public var description: String {
        var desc = super.description
        
        if  let descriptorString = descriptorString,
            !descriptorString.isEmpty {
            desc += "\n\tDescriptor: \"\(descriptorString))\""
        }

        if  let cbCharacteristic = cbCharacteristic {
            desc += "\n\tCharacteristic: \(cbCharacteristic))"

            if canBroadcast {
                desc += "\n\tCan Broadcast"
            }
            
            if canRead {
                desc += "\n\tCan Read"
            }
            
            if canWriteWithResponse {
                desc += "\n\tCan Write With Response"
            }
            
            if canWriteWithoutResponse {
                desc += "\n\tCan Write Without Response"
            }
            
            if canNotify {
                desc += "\n\tCan Notify"
            }
            
            if canIndicate {
                desc += "\n\tCan Indicate"
            }
            
            if canHaveAuthenticatedSignedWrites {
                desc += "\n\tCan Have Authenticated Signed Writes"
            }
            
            if isEncryptionRequiredForNotify {
                desc += "\n\tEncryption is Required for Notify"
            }
            
            if isEncryptionRequiredForIndication {
                desc += "\n\tEncryption is Required for Indicate"
            }
        }
        
        return desc
    }
    
    /* ################################################################## */
    /**
     True, if the characteristic can broadcast its value.
     */
    override public var canBroadcast: Bool {
        get { return cbCharacteristic.properties.contains(.broadcast) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be read.
     */
    override public var canRead: Bool {
        get { return cbCharacteristic.properties.contains(.read) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, with or without a response.
     */
    override public var canWrite: Bool {
        get { return canWriteWithResponse || canWriteWithoutResponse }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, with a response.
     */
    override public var canWriteWithResponse: Bool {
        get { return cbCharacteristic.properties.contains(.write) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can be written, without a response.
     */
    override public var canWriteWithoutResponse: Bool {
        get { return cbCharacteristic.properties.contains(.writeWithoutResponse) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can notify.
     */
    override public var canNotify: Bool {
        get { return cbCharacteristic.properties.contains(.notify) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can indicate. The driver need sto respond to indications.
     */
    override public var canIndicate: Bool {
        get { return cbCharacteristic.properties.contains(.indicate) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     True, if the characteristic can have authenticated signed writes, without a response.
     */
    override public var canHaveAuthenticatedSignedWrites: Bool {
        get { return cbCharacteristic.properties.contains(.authenticatedSignedWrites) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     Only trusted devices can subscribe to notifications of this property.
     */
    override public var isEncryptionRequiredForNotify: Bool {
        get { return cbCharacteristic.properties.contains(.notifyEncryptionRequired) }
        set { _ = newValue }
    }

    /* ################################################################## */
    /**
     Only trusted devices can see indications of this property.
     */
    override public var isEncryptionRequiredForIndication: Bool {
        get { return cbCharacteristic.properties.contains(.indicateEncryptionRequired) }
        set { _ = newValue }
    }
}

/* ###################################################################################################################################### */
// MARK: - Protocol Support for the various flags -
/* ###################################################################################################################################### */
/**
 These are condition/property flags for each characteristic/property.
 */
extension RVS_BTDriver_Property_BLE {
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Standard Device Info Service for BLE -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
class RVS_BTDriver_Service_DeviceInfo_BLE: RVS_BTDriver_Service_BLE {
    /* ################################################################## */
    /**
     This is a list of the UUIDs for the standard Device Info charateristics.
     */
    internal enum RVS_BLE_GATT_UUID: String, CaseIterable {
        /// This is the actual device info service ID
        case deviceInfoService      =   "180A"
        
        /// This characteristic represents a structure containing an Organizationally Unique Identifier (OUI) followed by a manufacturer-defined identifier and is unique for each individual instance of the product.
        case systemIDStruct         =   "2A23"
        /// This characteristic represents the model number that is assigned by the device vendor.
        case modelNumberString      =   "2A24"
        /// This characteristic represents the serial number for a particular instance of the device.
        case serialNumberString     =   "2A25"
        /// This characteristic represents the firmware revision for the firmware within the device.
        case firmwareRevisionString =   "2A26"
        /// This characteristic represents the hardware revision for the hardware within the device.
        case hardwareRevisionString =   "2A27"
        /// This characteristic represents the software revision for the software within the device.
        case softwareRevisionString =   "2A28"
        /// This characteristic represents the name of the manufacturer of the device.
        case manufacturerNameString =   "2A29"
        /// This characteristic represents regulatory and certification information for the product in a list defined in IEEE 11073-20601.
        case ieeRegulatoryList      =   "2A2A"
        /// The PnP_ID characteristic is a set of values used to create a device ID value that is unique for this device.
        case pnpIDSet               =   "2A50"
    }

    /* ################################################################## */
    /**
     Start a discovery process for basic characteristics (properties).
     */
    override internal func discoverInitialCharacteristics() {
        if let owner = internal_owner as? RVS_BTDriver_Device_BLE {
            owner.peripheral.discoverCharacteristics(nil, for: cbService)
        }
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    public var modelName: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.modelNumberString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .utf8)
        }
        return nil
    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    public var manufacturerName: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.manufacturerNameString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .utf8)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a serial number, it is available here.
     */
    public var serialNumber: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.serialNumberString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .utf8)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    public var hardwareRevision: String! {
       if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.hardwareRevisionString.rawValue)?.rawValue {
           return String(data: propertyValue, encoding: .utf8)
       }
       
       return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    public var firmwareRevision: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.firmwareRevisionString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .utf8)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    public var softwareRevision: String! {
        if let propertyValue = propertyInstanceForCBUUID(RVS_BLE_GATT_UUID.softwareRevisionString.rawValue)?.rawValue {
            return String(data: propertyValue, encoding: .utf8)
        }
        
        return nil
    }
}
