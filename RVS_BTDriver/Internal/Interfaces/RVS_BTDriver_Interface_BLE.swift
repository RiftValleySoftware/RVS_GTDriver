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
    /// This is how we get the information for creating our device instance.
    /// The peripheral instance and the central manager instance are passed in.
    typealias DeviceInfo = (peripheral: CBPeripheral, centralManager: CBCentralManager)
    
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
            let deviceInfo = DeviceInfo(peripheral: inPeripheral, centralManager: inCentral)
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
     Callback for a successful device connection.
     
     - parameter inCentral: The CoreBluetooth Central Manager instance calling this.
     - parameter connectionEventDidOccur: The connection event.
     - parameter for: The peripheral object that was connected.
    */
    internal func centralManager(_ inCentral: CBCentralManager, connectionEventDidOccur inEvent: CBConnectionEvent, for inPeripheral: CBPeripheral) {
        #if DEBUG
            print("Central Manager: \(inCentral) has received a connection event for this peripheral: \(inPeripheral).")
        #endif
        // Scan through the stored devices in the holding pen.
        for device in driver.internal_holding_pen where device is RVS_BTDriver_BLE_Device {
            if  let bleDevice = device as? RVS_BTDriver_BLE_Device,
                inCentral == centralManager,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
                bleDevice.continueInit()
                return
            }
        }
        
        // Scan through the stored devices
        for device in driver where device is RVS_BTDriver_BLE_Device {
            if  let bleDevice = device as? RVS_BTDriver_BLE_Device,
                inCentral == centralManager,
                bleDevice.centralManager == centralManager,
                bleDevice.peripheral == inPeripheral {
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
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_BLE_Device -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_BLE_Device: RVS_BTDriver_Device {
    /// The central manager that controls this peripheral.
    internal var centralManager: CBCentralManager!
    
    /// The peripheral instance associated with this device.
    var peripheral: CBPeripheral!
    
    /// The state machine callback.
    private var _callBackFunc: RVS_BTDriver_State_Machine.RVS_BTDriver_State_MachineCallback!
    
    /// The initial state (unititialized).
    private var _state: RVS_BTDriver_State_Machine_StateEnum = .uninitialized
    
    /// These are the services that we look up upon initialization connection.
    internal var internal_initalServiceDiscovery: [CBUUID] = []
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
     The state machine callback closure, supplied by the subscriber.
     */
    internal var callBack: RVS_BTDriver_State_Machine.RVS_BTDriver_State_MachineCallback! {
        get {
            return _callBackFunc
        }
        
        set {
            _callBackFunc = newValue
        }
    }
    
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
     Called periodically, while initializing.
     */
    internal func continueInit() {
        if .initializationInProgress == _state {
            peripheral.discoverServices(internal_initalServiceDiscovery)
        }
    }

    /* ################################################################## */
    /**
     Abort initialization.
     */
    internal func abortInit() {
    }
}
