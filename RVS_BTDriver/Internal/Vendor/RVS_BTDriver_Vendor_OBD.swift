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
// MARK: - Enums for Proprietary OBD BLE Service and Characteristic UUIDs -
/* ###################################################################################################################################### */
/**
 This is a wrapper for further exploration of the OBD type.
 */
public enum RVS_BTDriver_Vendor_OBD_Types: Equatable {
    /// The adapter uses the [ELM327 chipset](https://en.wikipedia.org/wiki/ELM327)
    case elm327(model: String)
    /// The adapter is not a known type.
    case unknown
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Vendor_OBD -
/* ###################################################################################################################################### */
/**
 A base class for various OBD dongle handlers.
 */
class RVS_BTDriver_Vendor_OBD: RVS_BTDriver_Vendor_GenericBLE {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary OBD BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID   =   "OBD"
    }
    
    /* ################################################################## */
    /**
     REQUIRED: Factory method for creating an instance of the vendor device.
     
       - parameter inDeviceRecord: The peripheral and central manager instances for this device.
       - returns: a device instance. Can be nil, if this vendor can't instantiate the device.
       */
     internal override func makeDevice(_ inDeviceRecord: Any?) -> RVS_BTDriver_Device! {
        precondition(false, "Cannot Call Base Class Method!")
        return nil
    }
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD Devices.
 */
class RVS_BTDriver_Device_OBD: RVS_BTDriver_Device_BLE, RVS_BTDriver_OBD_DeviceProtocol {
    /* ################################################################## */
    /**
     This contains the current transaction. It may be nil, for no transaction.
     */
    private var _currentTransaction: RVS_BTDriver_OBD_Device_TransactionStruct!
    
    /* ################################################################## */
    /**
     This contains the staged transactions in a queue.
     */
    private var _transactionQueue = RVS_FIFOQueue<RVS_BTDriver_OBD_Device_TransactionStruct>()

    /* ################################################################## */
    /**
     This is a weak reference to the instance delegate.
     */
    public weak var delegate: RVS_BTDriver_OBD_DeviceDelegate!
    
    /* ################################################################## */
    /**
     This property is one that the driver uses to receive responses from the OBD unit.
     */
    public var readProperty: RVS_BTDriver_PropertyProtocol!
    
    /* ################################################################## */
    /**
     This property is one that the driver uses to send commands to the OBD unit.
     */
    public var writeProperty: RVS_BTDriver_PropertyProtocol!
    
    /* ################################################################## */
    /**
     This menthod will send a command to the OBD unit.
     */
    internal func sendCommand() {
        if  let commandString = _currentTransaction.completeCommand {
            if  nil != commandReceiveFunc { // In case of test, we simply send it straight to the tester.
                commandReceiveFunc(commandString)
                _currentTransaction = nil
            } else if  let readProperty = readProperty as? RVS_BTDriver_Property_BLE,
                let writeProperty = writeProperty as? RVS_BTDriver_Property_BLE,
                let data = commandString.data(using: .utf8) {
                readProperty.canNotify = true
                // If we are in a unit test, then we intercept the commands, and run them through the unit tests.
                if writeProperty.canWriteWithResponse {
                    #if DEBUG
                        print("Sending data: \(commandString) for: \(writeProperty), and expecting a response.")
                    #endif
                    peripheral.writeValue(data, for: writeProperty.cbCharacteristic, type: .withResponse)
                } else {
                    #if DEBUG
                        print("Sending data: \(commandString) for: \(writeProperty), and not expecting a response.")
                    #endif
                    peripheral.writeValue(data, for: writeProperty.cbCharacteristic, type: .withoutResponse)
                }
            }
        }
    }

    /* ################################################################## */
    /**
     This menthod will send a command to the OBD unit.
     
     - parameter inCommandString: The Sting for the command.
     - parameter rawCommand: The command string, without data or the appended CRLF.
     */
    public func sendCommand(_ inCommandString: String, rawCommand inRawCommand: String) {
        #if DEBUG
            print("Storing transaction")
        #endif
        _transactionQueue.enqueue(RVS_BTDriver_OBD_Device_TransactionStruct(device: self, rawCommand: inRawCommand))
        if nil == _currentTransaction,
            let currentTransaction = _transactionQueue.dequeue() {
            _currentTransaction = currentTransaction
            #if DEBUG
                print("Sending transaction")
            #endif
            sendCommand()
        }
    }
    
    /* ################################################################## */
    /**
     Called to send the data to the delegate.
     
     - parameter inData: The data received.
     */
    internal func receiveCommandData(_ inData: Data) {
        delegate?.device(self, returnedThisData: inData)
    }
    
    /* ################################################################## */
    /**
    - parameter inPeripheral: The peripheral that owns this service.
    - parameter didUpdateValueFor: The characteristic that was updated.
    - parameter error: Any error that may have occurred. It can be nil.
    */
    internal override func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("OBD Device Callback: peripheral: \(inPeripheral) didUpdateValueFor (Characteristic): \(inCharacteristic).")
            print("OBD Device Characteristic Value: \(String(describing: inCharacteristic.value))")
            if  let value = inCharacteristic.value,
                let string = String(data: value, encoding: .utf8) {
                print("OBD Device Characteristic Value As String: \(string)")
            } else {
                print("OBD Device Characteristic Value Cannot Be Expressed As A String.")
            }
            
            if let error = inError {
                print("With Error: \(error)")
            }
        #endif
            
        if  inPeripheral == peripheral, // Make sure this is for us.
            let value = inCharacteristic.value {    // If we didn't get a value, then we don't send anything to the delegate.
            receiveCommandData(value)
        } else {    // Otherwise, kick the can down the road.
            super.peripheral(inPeripheral, didUpdateValueFor: inCharacteristic, error: inError)
        }
    }
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}
