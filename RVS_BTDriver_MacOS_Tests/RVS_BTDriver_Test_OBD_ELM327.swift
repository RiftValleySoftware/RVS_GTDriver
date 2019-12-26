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

import XCTest

/* ###################################################################################################################################### */
// MARK: - Testing OBD Commands -
/* ###################################################################################################################################### */
/**
 These are individual tests for the OBD ELM327 commands.
 */
class RVS_BTDriver_Test_OBD_ELM327: RVS_BTDriver_Test_OBD {
    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Return the device description
    */
	func test_getDeviceDescription() {
		
    }

    /* ################################################################## */
    /**
     Return the device ID
    */
	func test_getDeviceIdentifier() {
		
    }

    /* ################################################################## */
    /**
     Set the device ID
     
     - parameter id: A String, with up to 12 ASCII characters.
    */
	func test_setDeviceIdentifier(_ id: String) {
        
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Divisor
     
     - parameter divisor: 0-255, unsigned 8-bit integer.
    */
	func test_setBaudRateDivisor(_ divisor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Rate Handshake Timeout
     
     - parameter timeout: 0-255, unsigned 8-bit integer.
    */
	func test_setBaudRateHandshakeTimeout(_ timeout: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Restore the OBD Device to Defaults
    */
	func test_restoreToDefaults() {
		
    }

    /* ################################################################## */
    /**
     Turn echo on
    */
	func test_turnEchoOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Echo Off
    */
	func test_turnEchoOff() {
		
    }

    /* ################################################################## */
    /**
     Flush All Events
    */
	func test_flushAllEvents() {
		
    }

    /* ################################################################## */
    /**
     Return the unit ID
    */
	func test_getID() {
		
    }

    /* ################################################################## */
    /**
     Turn on Linefeeds
    */
	func test_turnLinefeedsOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Off Linefeeds
    */
	func test_turnLinefeedsOff() {
		
    }

    /* ################################################################## */
    /**
     Turn On Low Power Mode
    */
	func test_turnLowPowerModeOn() {
		
    }

    /* ################################################################## */
    /**
     Turn On Memory
    */
	func test_turnMemoryOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Off Memory
    */
	func test_turnMemoryOff() {
		
    }

    /* ################################################################## */
    /**
     Return Stored Data In Memory
    */
	func test_fetchStoredData() {
		
    }

    /* ################################################################## */
    /**
     Store 1 Byte of Data in Memory

     - parameter data: 0-255, unsigned 8-bit integer.
    */
	func test_storeData(_ data: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Perform a "Warm Start"
    */
	func test_warmStart() {
		
    }

    /* ################################################################## */
    /**
     Reset All
    */
	func test_resetAll() {
		
    }

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Use Long (>7 Byte) Messages
    */
	func test_useLongMessages() {
		
    }

    /* ################################################################## */
    /**
     Use Short (<= 7 Byte) Messages
    */
	func test_useShortMessages() {
		
    }

    /* ################################################################## */
    /**
     Enable Automatic Receive
    */
	func test_autoReceive() {
		
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
	func test_useAdaptiveTimingMode1() {
		
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
	func test_useAdaptiveTimingMode2() {
		
    }

    /* ################################################################## */
    /**
     Turn Adaptive Timing Off
    */
	func test_turnAdaptiveTimingOff() {
		
    }

    /* ################################################################## */
    /**
     Return a Buffer Dump
    */
	func test_bufferDump() {
		
    }

    /* ################################################################## */
    /**
     Bypass the Initialization Sequence
    */
	func test_bypassInitialization() {
		
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol
    */
	func test_describeCurrentProtocol() {
		
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol as a Number
    */
	func test_describeProtocolByNumber() {
		
    }

    /* ################################################################## */
    /**
     Turn Headers On
    */
	func test_turnHeadersOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Headers Off
    */
	func test_turnHeadersOff() {
		
    }

    /* ################################################################## */
    /**
     Monitor All
    */
	func test_monitorAll() {
		
    }

    /* ################################################################## */
    /**
     Set the Monitor for Receiver
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
	func test_setMonitorForReceiver(_ monitor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Monitor for Transmitter
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
	func test_setMonitorForTransmitter(_ monitor: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Protocol
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
	func test_setProtocol(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
	func test_setProtocol2(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (1 hex Digit)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
	func test_setAutoProtocol(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
	func test_setAutoProtocol2(_ protocolNumber: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Use Auto Protocol
    */
	func test_useAutoProtocol() {
		
    }

    /* ################################################################## */
    /**
     Close the Protocol
    */
	func test_closeProtocol() {
		
    }

    /* ################################################################## */
    /**
     Turn Responses On
    */
	func test_turnResponsesOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Responses Off
    */
	func test_turnResponsesOff() {
		
    }

    /* ################################################################## */
    /**
     Set the Receive Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
	func test_setReceiveAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Receive Address (Alternate Command)
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
	func test_setReceiveAddress2(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn On Print Spaces
    */
	func test_turnPrintSpacesOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Off Print Spaces
    */
	func test_turnPrintSpacesOff() {
		
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter pref: Prefix 0-7
     - parameter value: 0-255
    */
	func test_setHeader(_ pref: UInt8, _ value: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Header
     
     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
    */
	func test_setHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Standard (J1978) Search Order
    */
	func test_useStandardSearchOrder() {
		
    }

    /* ################################################################## */
    /**
     Set Tester Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
	func test_setTesterAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set Timeout to Multiples of 4ms
     
     - parameter timeout: 0-255 (8-bit unsigned integer)
    */
	func test_setTimeOutBy4MillisecondIntervals(_ timeout: UInt8) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting On
    */
	func test_turnCANAutoFormattingOn() {
		
    }

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting Off
    */
	func test_turnCANAutoFormattingOff() {
		
    }

    /* ################################################################## */
    /**
     Turn on CAN Extended Addressing, and Set it to the Given Value
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
	func test_setCANExtendedAddressing(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn CAN Extended Addressing Off
    */
	func test_turnOffCANExtendedAddressing() {
		
    }

    /* ################################################################## */
    /**
     Set the ID Filter
     
     - paramater pref: Prefix 0-7
     - parameter value: 0-255
    */
	func test_setIDFilter(_ pref: UInt8, _ value: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the ID Filter

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
	func test_setIDFilter(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control On
    */
	func test_turnCANFlowControlOn() {
		
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control Off
    */
	func test_turnCANFlowControlOff() {
		
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode On
    */
	func test_turnCANSilentModeOn() {
		
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode Off
    */
	func test_turnCANSilentModeOff() {
		
    }

    /* ################################################################## */
    /**
     Turn DLC Display On
    */
	func test_turnDLCDisplayOn() {
		
    }

    /* ################################################################## */
    /**
     Turn DLC Display Off
    */
	func test_turnDLCDisplayOff() {
		
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Data
     
     - parameter values: Up to 5 values of 0-255
    */
	func test_setFlowControlData(_ values: [UInt8]) {
        
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Header

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
	func test_setFlowControlHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Mode
     
     - parameter mode: 0-7
    */
	func test_setFlowControlMode(_ mode: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Protocol B Options and Baud Rate

     - parameter options: 0-255
     - parameter baudRate: 0-255
    */
	func test_setProtocolBOptionsAndBaudRate(_ options: UInt8, _ baudRate: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Send an RTR Message
    */
	func test_rtrMessage() {
		
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC On
    */
	func test_turnVariableDLCOn() {
		
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC Off
    */
	func test_turnVariableDLCOff() {
		
    }

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Set the Calibration Volts
     
     - parameter value: Calibrating voltage.
    */
	func test_setCalibratingVoltage(_ value: Float) {
        
    }

    /* ################################################################## */
    /**
     Reset the Calibration Voltage
    */
	func test_resetCalibratingVoltage() {
		
    }

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Monitor for DM1 Messages
    */
	func test_monitorForDM1Messages() {
		
    }

    /* ################################################################## */
    /**
     Use ELM Data Format
    */
	func test_useElmDataFormat() {
		
    }

    /* ################################################################## */
    /**
     Use SAE Data Format
    */
	func test_useSAEDataFormat() {
		
    }

    /* ################################################################## */
    /**
     Turn Header Formatting On
    */
	func test_turnJ1939HeaderFormattingOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Header Formatting Off
    */
	func test_turnJ1939HeaderFormattingOff() {
		
    }

    /* ################################################################## */
    /**
     Use the 1X Timer Multiplier
    */
	func test_use1XTimerMultiplier() {
		
    }

    /* ################################################################## */
    /**
     Use the 5X Timer Multiplier
    */
	func test_use5XTimerMultiplier() {
		
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
    */
	func test_setPGNMonitor(_ value: UInt64) {
        
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
     - parameter messages: 0-7 (the number of messages to receive)
    */
	func test_setPGNMonitorGetMessages(_ value: UInt64, _ messages: UInt8) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Header
    */
	func test_getIFRValueFromHeader() {
		
    }

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Source
    */
	func test_getIFRValueFromSource() {
		
    }

    /* ################################################################## */
    /**
     Turn IFRs On
    */
	func test_turnIFRsOn() {
		
    }

    /* ################################################################## */
    /**
     Turn On IFRs, and Set to Auto
    */
	func test_useIFRsAuto() {
		
    }

    /* ################################################################## */
    /**
     Turn IFRs Off
    */
	func test_turnIFRsOff() {
		
    }

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Try to Set Baud Rate to 10400
    */
	func test_isoBaudRate10400() {
		
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 4800
    */
	func test_isoBaudRate4800() {
		
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 9600
    */
	func test_isoBaudRate9600() {
		
    }

    /* ################################################################## */
    /**
     Set the ISO Initial Address
     
     - parameter address: 0-255
    */
	func test_setISOInitAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Display Keywords
    */
	func test_displayKeywords() {
		
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking On
    */
	func test_turnKeywordCheckingOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking Off
    */
	func test_turnKeywordCheckingOff() {
		
    }

    /* ################################################################## */
    /**
     Perform a Slow Initiation
    */
	func test_performSlowInitiation() {
		
    }

    /* ################################################################## */
    /**
     Set the Wakeup Interval to Multiple of 4ms
     
     - parameter multiplier: 0-255
    */
	func test_setWakeupIntervalMultiplerBy20ms(_ multiplier: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Wakeup Message
     
     - parameter message: Up to 6 0-255
    */
	func test_setWakeupMessage(_ message: [UInt8]) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn On All Program Parameters
    */
	func test_turnAllPPsProgParametersOn() {
		
    }

    /* ################################################################## */
    /**
     Turn Off All Program Parameters
    */
	func test_turnAllPPsProgParametersOff() {
		
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
	func test_setPPsProgParameterOnFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
	func test_setPPsProgParameterOffFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Given Program Parameter to the Given Value
     
     - parameter value: 0-255
     - parameter for: Parameter index 0-255
    */
	func test_setPPsProgParameterValue(_ value: UInt8, for: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Return a PPs Summary
    */
	func test_ppSummary() {
		
    }
}
