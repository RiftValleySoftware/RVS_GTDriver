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
    // MARK: - Enums for Proprietary goTenna BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    internal enum RVS_BLE_GATT_UUID: String {
        /// The standard GATT Device Info service.
        case deviceInfoService  =   "180A"
    }

    /// This is a simple struct to transfer interface information between the interface and the vendor device implementation.
    struct DeviceInfoStruct {
        /// The peripheral (BLE)
        let peripheral: CBPeripheral
        /// The central BLE manager
        let centralManager: CBCentralManager
        /// Any advertising data supplied with the discovery.
        let advertisementData: [String: Any]
    }
    
    /// This is how we get the information for creating our device instance.
    /// The peripheral instance and the central manager instance are passed in.
    typealias DeviceInfo = DeviceInfoStruct
    
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
     This will create the SINGLETON, if it is not already created, or simply returns the one we have.
     */
    internal static func makeInterface(queue inQueue: DispatchQueue!) -> RVS_BTDriver_InterfaceProtocol! {
        if nil == internal_interface {
            let interface = RVS_BTDriver_Interface_BLE()
            internal_interface = interface
            interface.centralManager = CBCentralManager(delegate: interface, queue: inQueue)
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
     If true, then Bluetooth is available (powered on).
     */
    override internal var isBTAvailable: Bool {
        return centralManager.state == .poweredOn
    }
    
    /* ################################################################## */
    /**
     Start or stop the scan for new peripherals.
     */
    override internal var isScanning: Bool {
        get {
            return centralManager.isScanning
        }
        
        set {
            if !centralManager.isScanning, newValue {
                var serviceUUIDs: [CBUUID]!
                
                // We supply any service UUIDs that we have on hand.
                if !serviceSignatures.isEmpty {
                    serviceUUIDs = serviceSignatures.compactMap {
                        CBUUID(string: $0)
                    }
                }
                
                // We check to see if we are going to be filtering out previous advertised devices (cuts down the noise).
                let options: [String: Any]! = rememberAdvertisedDevices ? nil : [CBCentralManagerScanOptionAllowDuplicatesKey: 1]
                
                centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
            } else if centralManager.isScanning {
                centralManager.stopScan()
            }
        }
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
        assert(inCentral === centralManager, "Central Manager Not Ours!")
        #if DEBUG
            print("Central Manager: \(inCentral) has changed state to: \(inCentral.state).")
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
            #endif
            return
        }
        
        // If we made it here, we are a valid device, and ready for inspection.
        for vendor in vendors {
            let deviceInfo = DeviceInfo(peripheral: inPeripheral, centralManager: inCentral, advertisementData: inAdvertisementData)
            if let device = vendor.makeDevice(deviceInfo) {
                #if DEBUG
                    print("\tVendor: \(vendor) has created a device to handle this peripheral.")
                #endif
                driver.addDiscoveredDevice(device)
                break
            }
        }
    }
    
    /* ################################################################## */
    /**
     Callback for a connection event (as opposed to just a connection).
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter connectionEventDidOccur: The connection event.
     - parameter for: The peripheral object that was connected.
    */
    internal func centralManager(_ inCentral: CBCentralManager, connectionEventDidOccur inEvent: CBConnectionEvent, for inPeripheral: CBPeripheral) {
        #if DEBUG
            print("Central Manager: \(inCentral) has received a connection event: \(inEvent), for this peripheral: \(inPeripheral).")
        #endif
        centralManager(inCentral, didConnect: inPeripheral)
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
        
        // Scan through the stored devices in the holding pen.
        for device in driver.internal_holding_pen where device is RVS_BTDriver_BLE_Device {
            if  let bleDevice = device as? RVS_BTDriver_BLE_Device,
                inCentral == centralManager,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
                bleDevice.connectedPreInit()
                return
            }
        }
        
        // Scan through the stored devices
        for device in driver where device is RVS_BTDriver_BLE_Device {
            if  let bleDevice = device as? RVS_BTDriver_BLE_Device,
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
            print("Central Manager: \(inCentral) has received a disconnection event for this peripheral: \(inPeripheral), with this error: \(String(describing: inError)).")
        #endif
    }
    
    /* ################################################################## */
    /**
     Callback for updating ANCS authorization.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter didUpdateANCSAuthorizationFor: The peripheral object.
    */
    internal func centralManager(_ inCentral: CBCentralManager, didUpdateANCSAuthorizationFor inPeripheral: CBPeripheral) {
        #if DEBUG
            print("Central Manager: \(inCentral) didUpdateANCSAuthorizationFor for this peripheral: \(inPeripheral).")
        #endif
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_BLE_Device -
/* ###################################################################################################################################### */
/**
 This is a specialized class for BLE devices (peripherals).
 */
class RVS_BTDriver_BLE_Device: RVS_BTDriver_Device {
    /// The central manager that controls this peripheral.
    internal var centralManager: CBCentralManager!
    
    /// The peripheral instance associated with this device.
    var peripheral: CBPeripheral!
    
    /// The initial state (unititialized).
    private var _state: RVS_BTDriver_State_Machine_StateEnum = .uninitialized
    
    /// These are the services that we look up upon initialization connection.
    internal var internal_initalServiceDiscovery: [CBUUID] = []
    
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
}

/* ###################################################################################################################################### */
// MARK: - State Machine Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
extension RVS_BTDriver_BLE_Device: RVS_BTDriver_State_Machine {
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
        /* ############################################################## */
        /**
         Searches the device services for the one corresponding to the given ID.
         
         - parameter inIDString: The UUID of the service, as a String.
         
         - returns: The CBService for that ID. Nil, if not found.
         */
        func cbServiceForThisID(_ inIDString: String) -> CBService! {
            if let services = peripheral?.services {
                for service in services where service.uuid == CBUUID(string: inIDString) {
                    return service
                }
            }
            
            return nil
        }
        
        for service in internal_holding_pen {
            if  let serviceObject = cbServiceForThisID(service.internal_uuid),
                let serviceInstance = service as? RVS_BTDriver_Service_BLE {
                serviceInstance.cbService = serviceObject
                moveServiceFromHoldingPenToMainList(serviceInstance)
            }
        }
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
    }
}

/* ###################################################################################################################################### */
// MARK: - Core Bluetooth Peripheral Delegate Support -
/* ###################################################################################################################################### */
/**
 This implements a way for the driver to track our initialization progress.
 */
extension RVS_BTDriver_BLE_Device: CBPeripheralDelegate {
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
                    moveServiceFromHoldingPenToMainList(serviceInstance)
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
                inPeripheral.readValue(for: characteristic)
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
    var cbService: CBService!
    
    /* ################################################################## */
    /**
     Start a discovery process for all characteristics (properties).
     */
    override internal func discoverInitialCharacteristics() {
        if let owner = internal_owner as? RVS_BTDriver_BLE_Device {
            owner.peripheral.discoverCharacteristics(nil, for: cbService)
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
    var cbCharacteristic: CBCharacteristic!
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
     */
    internal var internal_modelNumberString: String! {
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    internal var internal_serialNumberString: String! {
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    internal var internal_firmwareRevisionString: String! {
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    internal var internal_hardwareRevisionString: String! {
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    internal var internal_softwareRevisionString: String! {
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    internal var internal_manufacturerNameString: String! {
        return nil
    }

    /* ################################################################## */
    /**
     Start a discovery process for basic characteristics (properties).
     */
    override internal func discoverInitialCharacteristics() {
        if let owner = internal_owner as? RVS_BTDriver_BLE_Device {
            owner.peripheral.discoverCharacteristics(nil, for: cbService)
        }
    }
}
