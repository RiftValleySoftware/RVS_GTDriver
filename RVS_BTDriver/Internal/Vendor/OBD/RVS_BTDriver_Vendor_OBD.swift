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
 
 OBD devices handle communications in a single-threaded manner, so we use a queue to hold transactions. As a transaction completes, the next one is
 sent out.
 
 This allows us to match responses with commands, so we keep the transactions in a struct that is sent to the delegate, so the delegate gets to
 have access to the sent command, as well as the response.
 */
class RVS_BTDriver_Device_OBD: RVS_BTDriver_Device_BLE, RVS_BTDriver_OBD_DeviceProtocol {
    /* ################################################################## */
    /**
     This is how many seconds we wait for a command to finish.
     */
    static internal let timeoutInterval: TimeInterval = 10.0
    
    /* ################################################################## */
    /**
     This contains the staged transactions in a queue.
     */
    internal var transactionQueue = RVS_FIFOQueue<RVS_BTDriver_OBD_Device_TransactionStruct>()

    /* ################################################################## */
    /**
     This contains the current transaction. It may be nil, for no transaction.
     */
    internal var currentTransaction: RVS_BTDriver_OBD_Device_TransactionStruct!
    
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
     This method will send a command to the OBD unit.
     This variant of the method will fectch any command in the _currentTransaction property. If none, then nothing happens.
     */
    internal func sendCommand() {
        if  let commandString = currentTransaction?.completeCommand {   // Get the command string.
            precondition(nil == currentTransaction?.responseData, "The response data is not nil!")// Make sure that we have not yet gotten a response
            if  nil != commandReceiveFunc { // In case of test, we simply send it straight to the tester.
                commandReceiveFunc(commandString)
                currentTransaction = transactionQueue.dequeue()
            } else if  let readProperty = readProperty as? RVS_BTDriver_Property_BLE,
                let writeProperty = writeProperty as? RVS_BTDriver_Property_BLE,
                let data = commandString.data(using: .ascii) {
                readProperty.canNotify = true
                startTimeout(Self.timeoutInterval)
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
     This method will send a command to the OBD unit.
     
     - parameter inCommandString: The String for the command.
     - parameter rawCommand: The command String, without data or the appended CRLF.
     */
    public func sendCommand(_ inCommandString: String, rawCommand inRawCommand: String) {
        #if DEBUG
            print("Storing transaction")
        #endif
        transactionQueue.enqueue(RVS_BTDriver_OBD_Device_TransactionStruct(device: self, rawCommand: inRawCommand, completeCommand: inCommandString))
        if  isConnected,
            nil == currentTransaction,
            let currentTransaction = transactionQueue.dequeue() {
            self.currentTransaction = currentTransaction
            #if DEBUG
                print("Sending transaction: \(currentTransaction)")
            #endif
            sendCommand()
        } else if !isConnected {
            #if DEBUG
                print("Peripheral was disconnected. Reconnecting.")
            #endif
            currentTransaction = nil
            isConnected = true
        }
    }
    
    /* ################################################################## */
    /**
     Called to send the data to the delegate.
     
     - parameter inData: The data received.
     */
    internal func receiveCommandData(_ inData: Data) {
        if nil != currentTransaction {
            if nil == currentTransaction.responseData {
                currentTransaction?.responseData = inData
            } else {
                currentTransaction?.responseData += inData
            }
            
            // All OBD responses end with a less-than sign, so we wait for that before wrapping up.
            if  let currTrans = currentTransaction,
                let stringValueData = currTrans.responseData,
                let stringValue = String(data: stringValueData, encoding: .ascii),
                ">" == stringValue.last {
                cancelTimeout()
                
                let parser = RVS_BTDriver_Vendor_OBD_Parser(transaction: currTrans)

                if let cleanedString = parser.transaction?.parsedData {
                    #if DEBUG
                        print("Adding \"\(cleanedString)\" to the transaction.")
                    #endif
                    
                    currentTransaction.parsedData = cleanedString
                } else {
                    #if DEBUG
                        print("Unable to produce a cleaned string.")
                    #endif
                }
                
                #if DEBUG
                    print("Sending \"\(currentTransaction.description)\" up to the delegate.")
                #endif
                
                delegate?.deviceUpdatedTransaction(currentTransaction)

                // Get the next transaction.
                currentTransaction = transactionQueue.dequeue()
                sendCommand()   // See if there's another one waiting for us.
            }
        }
    }
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
    
    /* ################################################################## */
    /**
     This cancels all I/O, and flushes the transaction queue.
     You may get a response from the last transaction, but it will not be sent to the delegate.
     */
    public func cancelTransactions() {
        #if DEBUG
            print("Canceling All Transactions.")
        #endif
        cancelTimeout()
        transactionQueue.removeAll()
        currentTransaction = nil
    }
    
    /* ################################################################## */
    /**
     This is the timer timeout handler. When called, it will send an error to the delegate.
     
     This should be overridden, so that subclasses can provide meaninful data.
     
     - parameter inTimer: The timer object calling this.
     */
    override internal func timeoutHandler(_ inTimer: Timer) {
        #if DEBUG
            print("OBD Timeout!")
        #endif
        let transaction = currentTransaction    // Saved, because we are about to nuke all the transactions.
        cancelTransactions()
        reportThisError(RVS_BTDriver.Errors.commandTimeout(commandData: transaction))
    }
    
    /* ################################################################## */
    /**
     Called if there was a disconnection, after initializing.
     We use this to cancel any open timeout, and re-queue any incomplete transaction.
     */
    internal override func disconnectedPostInit() {
        #if DEBUG
            print("DISCCONNECTED (OBD Post-Init)")
        #endif
        
        cancelTimeout()
        
        // If we are in a transaction now, we shove it back into the queue, as we'll try it again.
        if let deferredTransaction = currentTransaction {
            currentTransaction = nil
            transactionQueue.cutTheLine(deferredTransaction)
        }
    }
    
    /* ################################################################## */
    /**
     Called if there was a connection, after initializing.
     If we had a command in the queue, we retry it.
     */
    internal override func connectedPostInit() {
        #if DEBUG
            print("CONNECTED (OBD Post-Init)")
        #endif
        
        // If we are not currently sending something, but we have something in the pipeline, then send that.
        if  nil == currentTransaction,
            let deferredTransaction = transactionQueue.dequeue() {
            currentTransaction = deferredTransaction
        }
        
        // See if we are sending something.
        if let deferredTransaction = transactionQueue.dequeue() {
            #if DEBUG
                print("Sending deferred transaction: \(deferredTransaction)")
            #endif
            sendCommand()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Device Delegate Handler -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device_OBD {
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
                let string = String(data: value, encoding: .ascii) {
                print("OBD Device Characteristic Value As String: \(string)")
            } else {
                print("OBD Device Characteristic Value Cannot Be Expressed As A String.")
            }
        
            if let error = inError {
                print("With Error: \(error)")
            }
        #endif
            
        cancelTimeout()
        if  inPeripheral == peripheral, // Make sure this is for us.
            let value = inCharacteristic.value {    // If we didn't get a value, then we don't send anything to the delegate.
            receiveCommandData(value)
        } else {    // Otherwise, kick the can down the road.
            super.peripheral(inPeripheral, didUpdateValueFor: inCharacteristic, error: inError)
            currentTransaction = transactionQueue.dequeue()
            sendCommand()   // See if there's another one waiting for us.
        }
    }
}
