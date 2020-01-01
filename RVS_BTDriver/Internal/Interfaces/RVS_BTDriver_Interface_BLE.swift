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
    internal override var isBTAvailable: Bool {
        if  let centralManager = centralManager,
            .poweredOn == centralManager.state {
            return true
        } else if nil == centralManager {
            #if DEBUG
                print("The Central Manager Instance is Nil")
            #endif
        } else {
            #if DEBUG
                var centralState = ""
                // The reason that we do this, is because the reflection doesn't go below the type, and if we want to display the value, we have to unwind the enum.
                switch centralManager.state {
                case .poweredOff:
                    centralState = "Powered Off"
                    
                case .resetting:
                    centralState = "Resetting"

                case .unauthorized:
                    centralState = "Unauthorized"
                    
                case .unsupported:
                    centralState = "Unsupported"

                case .poweredOn:
                    centralState = "Powered On"
                    
                default:
                    centralState = "Unknown"
                }
                print("The Central Manager State is \(centralState)")
            #endif
        }
        
        return false
    }

    /* ################################################################## */
    /**
     Start or stop the scan for new peripherals.
     */
    internal override var isScanning: Bool {
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
            let oldValue = centralManager.isScanning    // We do this, to see if anything actually changed.
            
            if  newValue,
                !(centralManager?.isScanning ?? false) {
                // We check to see if we are going to be filtering out previous advertised devices (cuts down the noise).
                let options: [String: Any]! = rememberAdvertisedDevices ? [CBCentralManagerScanOptionAllowDuplicatesKey: 1] : nil

                var services: [CBUUID]!
                
                if let vendors = driver?.internal_vendors {
                    for vendor in vendors where 0 < vendor.searchForTheseServices.count {
                        if nil == services {
                            services = vendor.searchForTheseServices
                        } else {
                            services += vendor.searchForTheseServices
                        }
                    }
                }
                
                #if DEBUG
                    print("Presenting these services for scan filtering: \(String(describing: services))")
                #endif
                
                centralManager?.scanForPeripherals(withServices: services, options: options)
            } else if   !newValue,
                        centralManager?.isScanning ?? false {
                centralManager?.stopScan()
            }
            
            #if DEBUG
                if nil == centralManager {
                    print("The Central Manager Instance is Nil")
                } else if newValue != oldValue {
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
        return Self.internal_interface
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
            if let serviceArray = inAdvertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
                print("\tAdvertised Services: \(serviceArray)")
            }
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

        // If we made it here, we are a valid device, and ready for inspection.
        if let device = vendors[0].makeDevice(DeviceInfo(peripheral: inPeripheral, centralManager: inCentral, advertisementData: inAdvertisementData)) {
            #if DEBUG
                print("\tNew generic device created to handle this peripheral: \(inPeripheral).")
            #endif
            driver.addDiscoveredDevice(device)
            device.isConnected = true   // We connect, in order to start service discovery.
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
