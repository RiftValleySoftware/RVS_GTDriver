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
// MARK: - RVS_BTDriver_Device_BLE -
/* ###################################################################################################################################### */
/**
 This is a specialized class for BLE devices (peripherals).
 */
class RVS_BTDriver_Device_BLE: RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     This holds the device info we were created with.
     */
    private var _deviceInfoStruct: RVS_BTDriver_Interface_BLE.DeviceInfo!
    
    /* ################################################################## */
    /**
     The initial state (unititialized).
     */
    private var _state: RVS_BTDriver_State_Machine_StateEnum = .uninitialized

    /* ################################################################## */
    /**
     This is a property that is set to a command receive for a mock.
     */
    var commandReceiveFunc: ((_ command: String) -> Void)!
    
    /* ################################################################## */
    /**
     The central manager that controls this peripheral.
     */
    internal var centralManager: CBCentralManager! {
        return deviceInfoStruct?.centralManager
    }
    
    /* ################################################################## */
    /**
     The peripheral instance associated with this device.
    */
    internal var peripheral: CBPeripheral! {
        return deviceInfoStruct?.peripheral
    }
    
    /* ################################################################## */
    /**
     The UUID comes directly from the peripheral.
     */
    internal override var uuid: String! {
        get {
            return peripheral?.identifier.uuidString
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property!")
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Timeout Handling -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a property that is set to a countdown timer when a timeout period begins. It should be canceled and niled, when not in use.
     */
    internal var timeoutTimer: Timer? = nil

    /* ################################################################## */
    /**
     This is the timer timeout handler. When called, it will send an error to the delegate.
     
     This shoul be overridden, so that subclasses can provide meaninful data.
     
     - parameter inTimer: The timer object calling this.
     */
    @objc internal func timeoutHandler(_ inTimer: Timer) {
        cancelTimeout()
        reportThisError(RVS_BTDriver.Errors.commandTimeout(commandData: nil))
    }
    
    /* ################################################################## */
    /**
     Begin the timeout ticker.
     
     - parameter inTimeoutInSeconds: A Double-precision floating-point number, containing the number of seconds to wait.
     */
    internal func startTimeout(_ inTimeoutInSeconds: TimeInterval) {
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: inTimeoutInSeconds, repeats: false, block: timeoutHandler)
    }
    
    /* ################################################################## */
    /**
     This stops the timeout ticker, and clears the decks.
     */
    internal func cancelTimeout() {
        if  let timer = timeoutTimer,
            timer.isValid {
            timer.invalidate()
        }
        timeoutTimer = nil
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
    public override internal(set) var deviceName: String! {
        get {
            if let name = peripheral?.name {
                return name
            }
            
            return modelName
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property!")
        }

    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a model name, it is available here.
     */
    public override internal(set) var modelName: String! {
        get {
            if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
                return service.modelName
            }

            return nil
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property!")
        }

    }

    /* ################################################################## */
    /**
     If the device has a Device Info Service with a manufacturer name, it is available here.
     */
    public override internal(set) var manufacturerName: String! {
       get {
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.manufacturerName
           }

           return nil
       }
       
       set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a serial number, it is available here.
     */
    public override internal(set) var serialNumber: String! {
       get {
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.serialNumber
           }

           return nil
       }
       
       set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a hardware revision, it is available here.
     */
    public override internal(set) var hardwareRevision: String! {
       get {
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.hardwareRevision
           }

           return nil
       }
       
       set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a firmware revision, it is available here.
     */
    public override internal(set) var firmwareRevision: String! {
       get {
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.firmwareRevision
           }

           return nil
       }
       
       set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
   }
    
    /* ################################################################## */
    /**
     If the device has a Device Info Service with a software revision, it is available here.
     */
    public override internal(set) var softwareRevision: String! {
       get {
           if let service = serviceInstanceForCBUUID(RVS_BTDriver_Service_DeviceInfo_BLE.RVS_BLE_GATT_UUID.deviceInfoService.rawValue) as? RVS_BTDriver_Service_DeviceInfo_BLE {
               return service.softwareRevision
           }

           return nil
       }
       
       set {
           _ = newValue
           precondition(false, "Cannot Set This Property!")
       }
   }
    
    /* ################################################################## */
    /**
     Connection indicator.
     
     - returns: true, if the peripheral is currently connected.
     */
    internal override var isConnected: Bool {
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
    
    /* ################################################################## */
    /**
     Connectable indicator.
     
     - returns: true, if the peripheral is connectable.
     */
    public override var canConnect: Bool {
        get {
            return 1 == (deviceInfoStruct.advertisementData[CBAdvertisementDataIsConnectable] as? Int ?? 0)
        }
        
        set {
            _ = newValue
            precondition(false, "Cannot Set This Property")
        }
    }

    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_BLE_Device Internal Base Class Override Methods -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called to initiate a connection.
    */
    internal override func connect() {
        precondition(canConnect, "Device Cannot be Connected!")
        if .disconnected == peripheral.state { // Must be completely disconnected
            #if DEBUG
                print("Connecting the BLE device: \(String(describing: self))")
            #endif
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    /* ################################################################## */
    /**
     Called to close a connection.
    */
    internal override func disconnect() {
        if .disconnected != peripheral.state { // This applies everywhere except when explicitly disconnected.
            #if DEBUG
                print("Disconnecting the BLE device: \(String(describing: self))")
            #endif
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /* ################################################################## */
    /**
     This one does nothing. It should be overridden.
     */
    public override func discoverServices() {
        if .initializationInProgress == _state {
            // We tell the device to discover all services.
            #if DEBUG
                print("Discovering all services for the device: \(String(describing: self))")
            #endif
            peripheral.discoverServices(nil)
        }
    }
    
    /* ################################################################## */
    /**
     Accessor for our device info structure. It will be nil, if none assigned yet.
     */
    internal var deviceInfoStruct: RVS_BTDriver_Interface_BLE.DeviceInfo! {
        get {
            return _deviceInfoStruct
        }
        
        set {
            _deviceInfoStruct = newValue
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
    
    /* ################################################################## */
    /**
     This searches the device, and returns a property that "owns" the given characteristic, identified by its UUID (as a String).
     
     This method will search only the main (final) list. It will not search the holding pen.
     
     - parameter inUUIDString: The CoreBluetooth Characteristic UID (as a String) we are matching.
     
     - returns: The Property instance for the UID. Nil, if it can't be matched.
     */
    internal func propertyInstanceForCBUUIDInMainList(_ inUUIDString: String) -> RVS_BTDriver_Property_BLE! {
        #if DEBUG
            print("Searching for a property instance for this UUID in the main list: \(inUUIDString)\n")
        #endif
        
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
     
     - parameter inPeripheral: The peripheral for this device.
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
    - parameter inPeripheral: The peripheral for this device.
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
    
    /* ################################################################## */
    /**
    - parameter inPeripheral: The peripheral for this device.
    */
    internal func peripheralDidUpdateName(_ inPeripheral: CBPeripheral) {
        #if DEBUG
            print("OBD Device Callback: peripheral: \(inPeripheral) updated its name.")
        #endif
        notifySubscribersOfStatusUpdate()
    }
}
