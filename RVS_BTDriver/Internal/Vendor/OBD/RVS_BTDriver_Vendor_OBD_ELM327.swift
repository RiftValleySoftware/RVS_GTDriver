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
// MARK: - RVS_BTDriver_Vendor_OBD_ELM327 -
/* ###################################################################################################################################### */
/**
 A base class for various OBD dongle handlers, based on the ELM327 chipset.
 */
class RVS_BTDriver_Vendor_OBD_ELM327: RVS_BTDriver_Vendor_OBD {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary OBD ELM327 BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID   =   "ELM327"
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
// MARK: - OBD ELM327 Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD ELM327 Devices.
 */
class RVS_BTDriver_Device_OBD_ELM327: RVS_BTDriver_Device_OBD {
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_OBD_ELM327_DeviceProtocol Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This will hold the ELM327 version string.
     */
    public var elm327Version: String = ""

    /* ################################################################################################################################## */
    // MARK: - Internal Static Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the command that we send to retrieve the version.
     */
    internal static let crlf = "\r\n"
    
    /* ################################################################## */
    /**
     This is the command that we send to retrieve the version.
     */
    internal static let initialQueryCommand = "ATZ"
    
    /* ################################################################## */
    /**
     This is the minimum supported ELM version.
     */
    internal static let minimumELMVersion: Float = 1.5
    
    /* ################################################################## */
    /**
     This is set to true, once we have explicitly set the echo on.
     */
    internal var echoTurnedOn = false
    
    /* ################################################################################################################################## */
    // MARK: - Internal Computed Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD_ELM327.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
    
    /* ################################################################## */
    /**
     This method should be called after all setup has been done, so that subclasses can do what needs doing.
     We use it to send an initial "ATZ" command.
     */
    internal override func initialSetup() {
        sendCommand(Self.initialQueryCommand + Self.crlf, rawCommand: Self.initialQueryCommand)
        super.initialSetup()
    }

    /* ################################################################################################################################## */
    // MARK: - Base Class Override -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a NOP, because we fetch the ELM version before closing the books.
     
     This needs to be done here, because we are overriding a non-objC method.
     */
    internal override func reportCompletion() { }
}

/* ###################################################################################################################################### */
// MARK: - Base Class Override -
/* ###################################################################################################################################### */
extension RVS_BTDriver_Device_OBD_ELM327 {
    /* ################################################################################################################################## */
    // MARK: - CBPeripheralDelegate Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
    - parameter inPeripheral: The peripheral that owns this service.
    - parameter didUpdateValueFor: The characteristic that was updated.
    - parameter error: Any error that may have occurred. It can be nil.
    */
    internal override func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("OBD ELM327 Device Callback: peripheral: \(inPeripheral) didUpdateValueFor (Characteristic): \(inCharacteristic).")
            print("OBD ELM327 Device Characteristic Value: \(String(describing: inCharacteristic.value))")
            if let stringData = inCharacteristic.value {
                if let str = String(data: stringData, encoding: .ascii) {
                    print("OBD ELM327 Device Characteristic Value As String: \(str)")
                }
            }
            
            if let error = inError {
                print("With Error: \(error)")
            }
        #endif
        
        // Make sure this is for us.
        if  nil == inError, // Can't have any errors.
            inPeripheral == peripheral {
            if  let value = inCharacteristic.value {
                if  elm327Version.isEmpty { // If we have not set up the version yet, we can't finish the initialization.
                    if let trimmedResponse = String(data: value, encoding: .ascii)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
                        if 9 < trimmedResponse.count {  // We need to have at least nine characters in the response.
                            cancelTimeout()
                            let indexOfSubstring = trimmedResponse.index(trimmedResponse.startIndex, offsetBy: 8)
                            // We make double-sure the string is trimmed. OBD devices can be messy; especially the cheap ones.
                            // We will handle this response completely manually. We expect it to be "whole."
                            let substring = String(trimmedResponse[indexOfSubstring...]).trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"]))
                            if  !substring.isEmpty,
                                let value = Float(substring),
                                Self.minimumELMVersion <= value {
                                #if DEBUG
                                    print("The ELM327 Version is \(substring)")
                                #endif
                                elm327Version = String(value)
                                currentTransaction = nil
                                turnEchoOn()    // Make sure that echo is turned on. This means that we will delete the first line of each command received. If we turn it off, it will mess us up.
                            } else {    // If we aren't up to the task, we nuke the device.
                                #if DEBUG
                                    print("The ELM327 Version of \(substring) is too low. It needs to be at least \(Self.minimumELMVersion).")
                                #endif
                                cancelTransactions()
                                disconnect()
                                owner?.removeThisDevice(self)
                            }
                        } else {    // Anything else is an error.
                            #if DEBUG
                                print("The ELM327 Version string of \"\(trimmedResponse)\" is not valid.")
                            #endif
                            cancelTransactions()
                            disconnect()
                            owner?.removeThisDevice(self)
                        }
                    } else {    // Bad data response means we nuke the device.
                        #if DEBUG
                            print("The ELM327 Version string is nil.")
                        #endif
                        cancelTransactions()
                        disconnect()
                        owner?.removeThisDevice(self)
                    }
                } else if !echoTurnedOn {   // We don't bother parsing the response. We know it's "OK."
                    #if DEBUG
                        print("Echo Is On.")
                    #endif
                    cancelTransactions()    // Make sure we start off clean.
                    echoTurnedOn = true
                    super.reportCompletion()    // Now, we are ready to end the chapter.
                } else {
                    receiveCommandData(value)
                }
            }
        } else {    // Otherwise, kick the can down the road.
            super.peripheral(inPeripheral, didUpdateValueFor: inCharacteristic, error: inError)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_ELM327_DeviceProtocol Methods -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD ELM327 Devices.
 */
extension RVS_BTDriver_Device_OBD_ELM327: RVS_BTDriver_OBD_ELM327_DeviceProtocol {
    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Return the device description
    */
    public func getDeviceDescription() {
        sendCommand(RVS_BTDriver_OBD_Command_String.getDeviceDescription.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.getDeviceDescription.rawValue)
    }

    /* ################################################################## */
    /**
     Return the device ID
    */
    public func getDeviceIdentifier() {
        sendCommand(RVS_BTDriver_OBD_Command_String.getDeviceIdentifier.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.getDeviceIdentifier.rawValue)
    }

    /* ################################################################## */
    /**
     Set the device ID
     
     - parameter id: A String, with up to 12 ASCII characters.
    */
    public func setDeviceIdentifier(_ id: String) {
        var dumpVal: String = id
        if 12 < id.count {
            let endIndex = id.index(id.startIndex, offsetBy: 11)
            dumpVal = String(id[id.startIndex...endIndex])
        }
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue, dumpVal) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Divisor
     
     - parameter divisor: 0-255, unsigned 8-bit integer.
    */
    public func setBaudRateDivisor(_ divisor: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue, divisor) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Rate Handshake Timeout
     
     - parameter timeout: 0-255, unsigned 8-bit integer.
    */
    public func setBaudRateHandshakeTimeout(_ timeout: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue, timeout) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue)
    }

    /* ################################################################## */
    /**
     Restore the OBD Device to Defaults
    */
    public func restoreToDefaults() {
        sendCommand(RVS_BTDriver_OBD_Command_String.restoreToDefaults.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.restoreToDefaults.rawValue)
    }

    /* ################################################################## */
    /**
     Turn echo on
    */
    public func turnEchoOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnEchoOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnEchoOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Echo Off
     
     We block this from the public, as we don't want to turn off the echo.
    */
    internal func turnEchoOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnEchoOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnEchoOff.rawValue)
    }

    /* ################################################################## */
    /**
     Flush All Events
    */
    public func flushAllEvents() {
        sendCommand(RVS_BTDriver_OBD_Command_String.flushAllEvents.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.flushAllEvents.rawValue)
    }

    /* ################################################################## */
    /**
     Return the unit ID
    */
    public func getID() {
        sendCommand(RVS_BTDriver_OBD_Command_String.getID.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.getID.rawValue)
    }

    /* ################################################################## */
    /**
     Turn on Linefeeds
    */
    public func turnLinefeedsOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnLinefeedsOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnLinefeedsOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Off Linefeeds
    */
    public func turnLinefeedsOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnLinefeedsOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnLinefeedsOff.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On Low Power Mode
    */
    public func turnLowPowerModeOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnLowPowerModeOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnLowPowerModeOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On Memory
    */
    public func turnMemoryOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnMemoryOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnMemoryOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Off Memory
    */
    public func turnMemoryOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnMemoryOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnMemoryOff.rawValue)
    }

    /* ################################################################## */
    /**
     Return Stored Data In Memory
    */
    public func fetchStoredData() {
        sendCommand(RVS_BTDriver_OBD_Command_String.fetchStoredData.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.fetchStoredData.rawValue)
    }

    /* ################################################################## */
    /**
     Store 1 Byte of Data in Memory

     - parameter data: 0-255, unsigned 8-bit integer.
    */
    public func storeData(_ data: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.storeData.rawValue, data) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.storeData.rawValue)
    }

    /* ################################################################## */
    /**
     Perform a "Warm Start"
    */
    public func warmStart() {
        sendCommand(RVS_BTDriver_OBD_Command_String.warmStart.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.warmStart.rawValue)
    }

    /* ################################################################## */
    /**
     Reset All
    */
    public func resetAll() {
        sendCommand(RVS_BTDriver_OBD_Command_String.resetAll.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.resetAll.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Use Long (>7 Byte) Messages
    */
    public func useLongMessages() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useLongMessages.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useLongMessages.rawValue)
    }

    /* ################################################################## */
    /**
     Use Short (<= 7 Byte) Messages
    */
    public func useShortMessages() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useShortMessages.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useShortMessages.rawValue)
    }

    /* ################################################################## */
    /**
     Enable Automatic Receive
    */
    public func autoReceive() {
        sendCommand(RVS_BTDriver_OBD_Command_String.autoReceive.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.autoReceive.rawValue)
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    public func useAdaptiveTimingMode1() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode1.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode1.rawValue)
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    public func useAdaptiveTimingMode2() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode2.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode2.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Adaptive Timing Off
    */
    public func turnAdaptiveTimingOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnAdaptiveTimingOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnAdaptiveTimingOff.rawValue)
    }

    /* ################################################################## */
    /**
     Return a Buffer Dump
    */
    public func bufferDump() {
        sendCommand(RVS_BTDriver_OBD_Command_String.bufferDump.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.bufferDump.rawValue)
    }

    /* ################################################################## */
    /**
     Bypass the Initialization Sequence
    */
    public func bypassInitialization() {
        sendCommand(RVS_BTDriver_OBD_Command_String.bypassInitialization.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.bypassInitialization.rawValue)
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol
    */
    public func describeCurrentProtocol() {
        sendCommand(RVS_BTDriver_OBD_Command_String.describeCurrentProtocol.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.describeCurrentProtocol.rawValue)
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol as a Number
    */
    public func describeProtocolByNumber() {
        sendCommand(RVS_BTDriver_OBD_Command_String.describeProtocolByNumber.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.describeProtocolByNumber.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Headers On
    */
    public func turnHeadersOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnHeadersOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnHeadersOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Headers Off
    */
    public func turnHeadersOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnHeadersOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnHeadersOff.rawValue)
    }

    /* ################################################################## */
    /**
     Monitor All
    */
    public func monitorAll() {
        sendCommand(RVS_BTDriver_OBD_Command_String.monitorAll.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.monitorAll.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Monitor for Receiver
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    public func setMonitorForReceiver(_ monitor: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue, monitor) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Monitor for Transmitter
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    public func setMonitorForTransmitter(_ monitor: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue, monitor) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Protocol
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    public func setProtocol(_ protocolNumber: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setProtocol.rawValue, protocolNumber) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setProtocol.rawValue)
    }

    /* ################################################################## */
    /**
     Set Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    public func setProtocol2(_ protocolNumber: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setProtocol2.rawValue, protocolNumber) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setProtocol2.rawValue)
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (1 hex Digit)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    public func setAutoProtocol(_ protocolNumber: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol.rawValue, protocolNumber) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setAutoProtocol.rawValue)
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    public func setAutoProtocol2(_ protocolNumber: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol2.rawValue, protocolNumber) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setAutoProtocol2.rawValue)
    }

    /* ################################################################## */
    /**
     Use Auto Protocol
    */
    public func useAutoProtocol() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useAutoProtocol.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useAutoProtocol.rawValue)
    }

    /* ################################################################## */
    /**
     Close the Protocol
    */
    public func closeProtocol() {
        sendCommand(RVS_BTDriver_OBD_Command_String.closeProtocol.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.closeProtocol.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Responses On
    */
    public func turnResponsesOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnResponsesOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnResponsesOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Responses Off
    */
    public func turnResponsesOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnResponsesOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnResponsesOff.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Receive Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    public func setReceiveAddress(_ address: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue, address) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Receive Address (Alternate Command)
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    public func setReceiveAddress2(_ address: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue, address) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On Print Spaces
    */
    public func turnPrintSpacesOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnPrintSpacesOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnPrintSpacesOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Off Print Spaces
    */
    public func turnPrintSpacesOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnPrintSpacesOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnPrintSpacesOff.rawValue)
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter pref: Prefix 0-7
     - parameter value: 0-255
    */
    public func setHeader(_ pref: UInt8, _ value: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, pref, value) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue)
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
    */
    public func setHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setHeader2.rawValue, value1, value2, value3) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setHeader2.rawValue)
    }

    /* ################################################################## */
    /**
     Set Standard (J1978) Search Order
    */
    public func useStandardSearchOrder() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useStandardSearchOrder.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useStandardSearchOrder.rawValue)
    }

    /* ################################################################## */
    /**
     Set Tester Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    public func setTesterAddress(_ address: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue, address) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue)
    }

    /* ################################################################## */
    /**
     Set Timeout to Multiples of 4ms
     
     - parameter timeout: 0-255 (8-bit unsigned integer)
    */
    public func setTimeOutBy4MillisecondIntervals(_ timeout: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue, timeout) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting On
    */
    public func turnCANAutoFormattingOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting Off
    */
    public func turnCANAutoFormattingOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOff.rawValue)
    }

    /* ################################################################## */
    /**
     Turn on CAN Extended Addressing, and Set it to the Given Value
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    public func setCANExtendedAddressing(_ address: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue, address) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Extended Addressing Off
    */
    public func turnOffCANExtendedAddressing() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnOffCANExtendedAddressing.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnOffCANExtendedAddressing.rawValue)
    }

    /* ################################################################## */
    /**
     Set the ID Filter
     
     - paramater pref: Prefix 0-7
     - parameter value: 0-255
    */
    public func setIDFilter(_ pref: UInt8, _ value: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, pref, value) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue)
    }

    /* ################################################################## */
    /**
     Set the ID Filter

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    public func setIDFilter(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setIDFilter2.rawValue, value1, value2, value3, value4) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setIDFilter2.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control On
    */
    public func turnCANFlowControlOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANFlowControlOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANFlowControlOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control Off
    */
    public func turnCANFlowControlOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANFlowControlOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANFlowControlOff.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode On
    */
    public func turnCANSilentModeOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANSilentModeOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANSilentModeOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode Off
    */
    public func turnCANSilentModeOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnCANSilentModeOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnCANSilentModeOff.rawValue)
    }

    /* ################################################################## */
    /**
     Turn DLC Display On
    */
    public func turnDLCDisplayOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnDLCDisplayOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnDLCDisplayOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn DLC Display Off
    */
    public func turnDLCDisplayOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnDLCDisplayOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnDLCDisplayOff.rawValue)
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Data
     
     - parameter inValues: Up to 5 values of 0-255
    */
    public func setFlowControlData(_ inValues: [UInt8]) {
        var values: [UInt8] = [0, 0, 0, 0, 0]
        precondition(0 < values.count, "Must have at least one value")
        
        for index in 0..<5 where index < inValues.count {
            values[index] = inValues[index]
        }
        
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setFlowControlData.rawValue, values[0], values[1], values[2], values[3], values[4]) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setFlowControlData.rawValue)
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Header

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    public func setFlowControlHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setFlowControlHeader.rawValue, value1, value2, value3, value4) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setFlowControlHeader.rawValue)
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Mode
     
     - parameter mode: 0-7
    */
    public func setFlowControlMode(_ mode: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setFlowControlMode.rawValue, mode) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setFlowControlMode.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Protocol B Options and Baud Rate

     - parameter options: 0-255
     - parameter baudRate: 0-255
    */
    public func setProtocolBOptionsAndBaudRate(_ options: UInt8, _ baudRate: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setProtocolBOptionsAndBaudRate.rawValue, options, baudRate) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setProtocolBOptionsAndBaudRate.rawValue)
    }

    /* ################################################################## */
    /**
     Send an RTR Message
    */
    public func rtrMessage() {
        sendCommand(RVS_BTDriver_OBD_Command_String.rtrMessage.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.rtrMessage.rawValue)
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC On
    */
    public func turnVariableDLCOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnVariableDLCOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnVariableDLCOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC Off
    */
    public func turnVariableDLCOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnVariableDLCOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnVariableDLCOff.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Set the Calibration Volts
     
     - parameter value: Calibrating voltage.
    */
    public func setCalibratingVoltage(_ value: Float) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setCalibratingVoltage.rawValue, value) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setCalibratingVoltage.rawValue)
    }

    /* ################################################################## */
    /**
     Reset the Calibration Voltage
    */
    public func resetCalibratingVoltage() {
        sendCommand(RVS_BTDriver_OBD_Command_String.resetCalibratingVoltage.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.resetCalibratingVoltage.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Monitor for DM1 Messages
    */
    public func monitorForDM1Messages() {
        sendCommand(RVS_BTDriver_OBD_Command_String.monitorForDM1Messages.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.monitorForDM1Messages.rawValue)
    }

    /* ################################################################## */
    /**
     Use ELM Data Format
    */
    public func useElmDataFormat() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useElmDataFormat.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useElmDataFormat.rawValue)
    }

    /* ################################################################## */
    /**
     Use SAE Data Format
    */
    public func useSAEDataFormat() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useSAEDataFormat.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useSAEDataFormat.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Header Formatting On
    */
    public func turnJ1939HeaderFormattingOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Header Formatting Off
    */
    public func turnJ1939HeaderFormattingOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOff.rawValue)
    }

    /* ################################################################## */
    /**
     Use the 1X Timer Multiplier
    */
    public func use1XTimerMultiplier() {
        sendCommand(RVS_BTDriver_OBD_Command_String.use1XTimerMultiplier.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.use1XTimerMultiplier.rawValue)
    }

    /* ################################################################## */
    /**
     Use the 5X Timer Multiplier
    */
    public func use5XTimerMultiplier() {
        sendCommand(RVS_BTDriver_OBD_Command_String.use5XTimerMultiplier.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.use5XTimerMultiplier.rawValue)
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
    */
    public func setPGNMonitor(_ value: UInt64) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setPGNMonitor1.rawValue, value) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setPGNMonitor1.rawValue)
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
     - parameter messages: 0-7 (the number of messages to receive)
    */
    public func setPGNMonitorGetMessages(_ value: UInt64, _ messages: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setPGNMonitor2.rawValue, value, messages) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setPGNMonitor2.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Header
    */
    public func getIFRValueFromHeader() {
        sendCommand(RVS_BTDriver_OBD_Command_String.getIFRValueFromHeader.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.getIFRValueFromHeader.rawValue)
    }

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Source
    */
    public func getIFRValueFromSource() {
        sendCommand(RVS_BTDriver_OBD_Command_String.getIFRValueFromSource.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.getIFRValueFromSource.rawValue)
    }

    /* ################################################################## */
    /**
     Turn IFRs On
    */
    public func turnIFRsOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnIFRsOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnIFRsOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On IFRs, and Set to Auto
    */
    public func useIFRsAuto() {
        sendCommand(RVS_BTDriver_OBD_Command_String.useIFRsAuto.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.useIFRsAuto.rawValue)
    }

    /* ################################################################## */
    /**
     Turn IFRs Off
    */
    public func turnIFRsOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnIFRsOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnIFRsOff.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Try to Set Baud Rate to 10400
    */
    public func isoBaudRate10400() {
        sendCommand(RVS_BTDriver_OBD_Command_String.isoBaudRate10400.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.isoBaudRate10400.rawValue)
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 4800
    */
    public func isoBaudRate4800() {
        sendCommand(RVS_BTDriver_OBD_Command_String.isoBaudRate4800.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.isoBaudRate4800.rawValue)
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 9600
    */
    public func isoBaudRate9600() {
        sendCommand(RVS_BTDriver_OBD_Command_String.isoBaudRate9600.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.isoBaudRate9600.rawValue)
    }

    /* ################################################################## */
    /**
     Set the ISO Initial Address
     
     - parameter address: 0-255
    */
    public func setISOInitAddress(_ address: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setISOInitAddress.rawValue, address) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setISOInitAddress.rawValue)
    }

    /* ################################################################## */
    /**
     Display Keywords
    */
    public func displayKeywords() {
        sendCommand(RVS_BTDriver_OBD_Command_String.displayKeywords.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.displayKeywords.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking On
    */
    public func turnKeywordCheckingOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking Off
    */
    public func turnKeywordCheckingOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOff.rawValue)
    }

    /* ################################################################## */
    /**
     Perform a Slow Initiation
    */
    public func performSlowInitiation() {
        sendCommand(RVS_BTDriver_OBD_Command_String.performSlowInitiation.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.performSlowInitiation.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Wakeup Interval to Multiple of 4ms
     
     - parameter multiplier: 0-255
    */
    public func setWakeupIntervalMultiplerBy20ms(_ multiplier: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setWakeupIntervalMultiplerBy20ms.rawValue, multiplier) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setWakeupIntervalMultiplerBy20ms.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Wakeup Message
     
     - parameter message: Up to 6 0-255
    */
    public func setWakeupMessage(_ inMessage: [UInt8]) {
        var values: [UInt8] = [0, 0, 0, 0, 0, 0]
        precondition(0 < values.count, "Must have at least one value")
        
        for index in 0..<6 where index < inMessage.count {
            values[index] = inMessage[index]
        }
        
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setWakeupMessage.rawValue, values[0], values[1], values[2], values[3], values[4], values[5]) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setWakeupMessage.rawValue)
    }

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn On All Program Parameters
    */
    public func turnAllPPsProgParametersOn() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOn.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn Off All Program Parameters
    */
    public func turnAllPPsProgParametersOff() {
        sendCommand(RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOff.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOff.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    public func setPPsProgParameterOnFor(_ index: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setPPsProgParameterOn.rawValue, index) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setPPsProgParameterOn.rawValue)
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    public func setPPsProgParameterOffFor(_ index: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setPPsProgParameterOff.rawValue, index) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setPPsProgParameterOff.rawValue)
    }

    /* ################################################################## */
    /**
     Set the Given Program Parameter to the Given Value
     
     - parameter inValue: 0-255
     - parameter for: Parameter index 0-255
    */
    public func setPPsProgParameterValue(_ inValue: UInt8, for inIndex: UInt8) {
        sendCommand(String(format: RVS_BTDriver_OBD_Command_String.setPPsProgParameterValue.rawValue, inValue, inIndex) + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.setPPsProgParameterValue.rawValue)
    }

    /* ################################################################## */
    /**
     Return a PPs Summary
    */
    public func ppSummary() {
        sendCommand(RVS_BTDriver_OBD_Command_String.ppSummary.rawValue + Self.crlf, rawCommand: RVS_BTDriver_OBD_Command_String.ppSummary.rawValue)
    }
}
