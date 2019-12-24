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
    internal static let initialQueryCommand = "ATZ\(crlf)"
    
    /* ################################################################## */
    /**
     This is the minimum supported ELM version.
     */
    internal static let minimumELMVersion: Float = 1.5
    
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
        sendCommandWithResponse(Self.initialQueryCommand)
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
            if  let value = inCharacteristic.value,
                let string = String(data: value, encoding: .utf8) {
                print("OBD ELM327 Device Characteristic Value As String: \(string)")
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
                    if let trimmedResponse = String(data: value, encoding: .utf8)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
                        if 9 < trimmedResponse.count {  // We need to have at least nine characters in the response.
                            let indexOfSubstring = trimmedResponse.index(trimmedResponse.startIndex, offsetBy: 8)
                            let substring = String(trimmedResponse[indexOfSubstring...])
                            if  let value = Float(substring),
                            Self.minimumELMVersion <= value {
                                #if DEBUG
                                    print("The ELM327 Version is \(substring)")
                                #endif
                                elm327Version = substring
                                super.reportCompletion()    // Now, we are ready to end the chapter.
                            } else {    // If we aren't up to the task, we nuke the device.
                                #if DEBUG
                                    print("The ELM327 Version of \(substring) is too low. It needs to be at least \(Self.minimumELMVersion).")
                                #endif
                                owner?.removeThisDevice(self)
                            }
                        } else {    // Anything else is an error.
                            #if DEBUG
                                print("The ELM327 Version string of \"\(trimmedResponse)\" is not valid.")
                            #endif
                            owner?.removeThisDevice(self)
                        }
                    } else {    // Bad data response means we nuke the device.
                        #if DEBUG
                            print("The ELM327 Version string is nil.")
                        #endif
                        owner?.removeThisDevice(self)
                    }
                // The response will always be a String, and we should trim the crust off it before we make our sandwich.
                } else if let trimmedResponse = String(data: value, encoding: .utf8)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
                    #if DEBUG
                        print("Sending \"\(trimmedResponse)\" up to the delegate.")
                    #endif
                    delegate?.device(self, returnedThisData: trimmedResponse.data(using: .utf8))
                } else {
                    reportThisError(RVS_BTDriver.Errors.unknownCharacteristicsReadValueError(error: nil))
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
    /**
    This applies to the "General" group of commands.
    */

    /* ################################################################## */
    /**
     Return the device description
    */
    func getDeviceDescription() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.getDeviceDescription.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Return the device ID
    */
    func getDeviceIdentifier() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.getDeviceIdentifier.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the device ID
     
     - parameter id: A String, with up to 12 ASCII characters.
    */
    func setDeviceIdentifier(_ id: String) {
        
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Divisor
     
     - parameter divisor: 0-255, unsigned 8-bit integer.
    */
    func setBaudRateDivisor(_ divisor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Rate Handshake Timeout
     
     - parameter timeout: 0-255, unsigned 8-bit integer.
    */
    func setBaudRateHandshakeTimeout(_ timeout: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Restore the OBD Device to Defaults
    */
    func restoreToDefaults() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.restoreToDefaults.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn echo on
    */
    func turnEchoOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnEchoOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Echo Off
    */
    func turnEchoOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnEchoOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Flush All Events
    */
    func flushAllEvents() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.flushAllEvents.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Return the unit ID
    */
    func getID() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.getID.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn on Linefeeds
    */
    func turnLinefeedsOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnLinefeedsOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Off Linefeeds
    */
    func turnLinefeedsOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnLinefeedsOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn On Low Power Mode
    */
    func turnLowPowerModeOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnLowPowerModeOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn On Memory
    */
    func turnMemoryOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnMemoryOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Off Memory
    */
    func turnMemoryOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnMemoryOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Return Stored Data In Memory
    */
    func fetchStoredData() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.fetchStoredData.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Store 1 Byte of Data in Memory

     - parameter data: 0-255, unsigned 8-bit integer.
    */
    func storeData(_ data: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Perform a "Warm Start"
    */
    func warmStart() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.warmStart.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Reset All
    */
    func resetAll() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.resetAll.rawValue + Self.crlf)
    }

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /**
     This applies to the "OBD" group of commands.
     */

    /* ################################################################## */
    /**
     Use Long (>7 Byte) Messages
    */
    func useLongMessages() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useLongMessages.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Use Short (<= 7 Byte) Messages
    */
    func useShortMessages() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useShortMessages.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Enable Automatic Receive
    */
    func autoReceive() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.autoReceive.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    func useAdaptiveTimingMode1() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode1.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    func useAdaptiveTimingMode2() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode2.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Adaptive Timing Off
    */
    func turnAdaptiveTimingOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnAdaptiveTimingOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Return a Buffer Dump
    */
    func bufferDump() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.bufferDump.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Bypass the Initialization Sequence
    */
    func bypassInitialization() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.bypassInitialization.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol
    */
    func describeCurrentProtocol() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.describeCurrentProtocol.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol as a Number
    */
    func describeProtocolByNumber() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.describeProtocolByNumber.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Headers On
    */
    func turnHeadersOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnHeadersOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Headers Off
    */
    func turnHeadersOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnHeadersOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Monitor All
    */
    func monitorAll() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.monitorAll.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the Monitor for Receiver
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    func setMonitorForReceiver(_ monitor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Monitor for Transmitter
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    func setMonitorForTransmitter(_ monitor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Protocol
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setProtocol(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setProtocol2(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (1 hex Digit)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setAutoProtocol(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setAutoProtocol2(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Use Auto Protocol
    */
    func useAutoProtocol() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useAutoProtocol.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Close the Protocol
    */
    func closeProtocol() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.closeProtocol.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Responses On
    */
    func turnResponsesOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnResponsesOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Responses Off
    */
    func turnResponsesOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnResponsesOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the Receive Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setReceiveAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Receive Address (Alternate Command)
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setReceiveAddress2(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn On Print Spaces
    */
    func turnPrintSpacesOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnPrintSpacesOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Off Print Spaces
    */
    func turnPrintSpacesOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnPrintSpacesOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter pref: Prefix 0-7
     - parameter value: 0-255
    */
    func setHeader(_ pref: UInt8, _ value: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
    */
    func setHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Standard (J1978) Search Order
    */
    func useStandardSearchOrder() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useStandardSearchOrder.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set Tester Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setTesterAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Timeout to Multiples of 4ms
     
     - parameter timeout: 0-255 (8-bit unsigned integer)
    */
    func setTimeOutBy4MillisecondIntervals(_ timeout: UInt8) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /**
     This applies to the "CAN" group of commands.
     */

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting On
    */
    func turnCANAutoFormattingOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting Off
    */
    func turnCANAutoFormattingOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn on CAN Extended Addressing, and Set it to the Given Value
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setCANExtendedAddressing(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn CAN Extended Addressing Off
    */
    func turnOffCANExtendedAddressing() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnOffCANExtendedAddressing.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the ID Filter
     
     - paramater pref: Prefix 0-7
     - parameter value: 0-255
    */
    func setIDFilter(_ pref: UInt8, _ value: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the ID Filter

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    func setIDFilter(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control On
    */
    func turnCANFlowControlOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANFlowControlOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control Off
    */
    func turnCANFlowControlOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANFlowControlOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode On
    */
    func turnCANSilentModeOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANSilentModeOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode Off
    */
    func turnCANSilentModeOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnCANSilentModeOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn DLC Display On
    */
    func turnDLCDisplayOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnDLCDisplayOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn DLC Display Off
    */
    func turnDLCDisplayOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnDLCDisplayOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Data
     
     - parameter values: Up to 5 values of 0-255
    */
    func setFlowControlData(_ values: [UInt8]) {
        
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Header

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    func setFlowControlHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Mode
     
     - parameter mode: 0-7
    */
    func setFlowControlMode(_ mode: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Protocol B Options and Baud Rate

     - parameter options: 0-255
     - parameter baudRate: 0-255
    */
    func setProtocolBOptionsAndBaudRate(_ options: UInt8, _ baudRate: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Send an RTR Message
    */
    func rtrMessage() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.rtrMessage.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC On
    */
    func turnVariableDLCOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnVariableDLCOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC Off
    */
    func turnVariableDLCOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnVariableDLCOff.rawValue + Self.crlf)
    }

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /**
     This applies to the "Volts" group of commands.
     */

    /* ################################################################## */
    /**
     Set the Calibration Volts
     
     - parameter value: Calibrating voltage.
    */
    func setCalibratingVoltage(_ value: Float) {
        
    }

    /* ################################################################## */
    /**
     Reset the Calibration Voltage
    */
    func resetCalibratingVoltage() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.resetCalibratingVoltage.rawValue + Self.crlf)
    }

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1939" group of commands.
     */

    /* ################################################################## */
    /**
     Monitor for DM1 Messages
    */
    func monitorForDM1Messages() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.monitorForDM1Messages.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Use ELM Data Format
    */
    func useElmDataFormat() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useElmDataFormat.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Use SAE Data Format
    */
    func useSAEDataFormat() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useSAEDataFormat.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Header Formatting On
    */
    func turnJ1939HeaderFormattingOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Header Formatting Off
    */
    func turnJ1939HeaderFormattingOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Use the 1X Timer Multiplier
    */
    func use1XTimerMultiplier() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.use1XTimerMultiplier.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Use the 5X Timer Multiplier
    */
    func use5XTimerMultiplier() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.use5XTimerMultiplier.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
    */
    func setPGNMonitor(_ value: UInt64) {
        
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
     - parameter messages: 0-7 (the number of messages to receive)
    */
    func setPGNMonitorGetMessages(_ value: UInt64, _ messages: UInt8) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1850" group of commands.
     */

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Header
    */
    func getIFRValueFromHeader() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.getIFRValueFromHeader.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Source
    */
    func getIFRValueFromSource() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.getIFRValueFromSource.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn IFRs On
    */
    func turnIFRsOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnIFRsOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn On IFRs, and Set to Auto
    */
    func useIFRsAuto() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.useIFRsAuto.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn IFRs Off
    */
    func turnIFRsOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnIFRsOff.rawValue + Self.crlf)
    }

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /**
     This applies to the "ISO" group of commands.
     */

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 10400
    */
    func isoBaudRate10400() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.isoBaudRate10400.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 4800
    */
    func isoBaudRate4800() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.isoBaudRate4800.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 9600
    */
    func isoBaudRate9600() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.isoBaudRate9600.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the ISO Initial Address
     
     - parameter address: 0-255
    */
    func setISOInitAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Display Keywords
    */
    func displayKeywords() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.displayKeywords.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking On
    */
    func turnKeywordCheckingOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking Off
    */
    func turnKeywordCheckingOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Perform a Slow Initiation
    */
    func performSlowInitiation() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.performSlowInitiation.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Set the Wakeup Interval to Multiple of 4ms
     
     - parameter multiplier: 0-255
    */
    func setWakeupIntervalMultiplerBy20ms(_ multiplier: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Wakeup Message
     
     - parameter message: Up to 6 0-255
    */
    func setWakeupMessage(_ message: [UInt8]) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /**
     This applies to the "PPs" group of commands.
     */

    /* ################################################################## */
    /**
     Turn On All Program Parameters
    */
    func turnAllPPsProgParametersOn() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOn.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn Off All Program Parameters
    */
    func turnAllPPsProgParametersOff() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOff.rawValue + Self.crlf)
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    func setPPsProgParameterOnFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    func setPPsProgParameterOffFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Given Program Parameter to the Given Value
     
     - parameter value: 0-255
     - parameter for: Parameter index 0-255
    */
    func setPPsProgParameterValue(_ value: UInt8, for: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Return a PPs Summary
    */
    func ppSummary() {
        sendCommandWithResponse(RVS_BTDriver_OBD_Command_String.ppSummary.rawValue + Self.crlf)
    }
}
