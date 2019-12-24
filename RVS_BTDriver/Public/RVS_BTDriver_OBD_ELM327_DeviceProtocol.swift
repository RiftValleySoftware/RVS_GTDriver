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

import Foundation

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_ELM327_DeviceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This is a specialization for the common ELM327 chipset.
 */
public protocol RVS_BTDriver_OBD_ELM327_DeviceProtocol: RVS_BTDriver_OBD_DeviceProtocol {
    /* ################################################################## */
    /**
     This returns the ELM327 chipset version for the device.
     */
    var elm327Version: String { get }
    
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
    func getDeviceDescription()

    /* ################################################################## */
    /**
     Return the device ID
    */
    func getDeviceIdentifier()

    /* ################################################################## */
    /**
     Set the device ID
     
     - parameter id: A String, with up to 12 ASCII characters.
    */
    func setDeviceIdentifier(_ id: String)

    /* ################################################################## */
    /**
     Set the Baud Rate Divisor
     
     - parameter divisor: 0-255, unsigned 8-bit integer.
    */
    func setBaudRateDivisor(_ divisor: UInt8)

    /* ################################################################## */
    /**
     Set the Baud Rate Rate Handshake Timeout
     
     - parameter timeout: 0-255, unsigned 8-bit integer.
    */
    func setBaudRateHandshakeTimeout(_ timeout: UInt8)

    /* ################################################################## */
    /**
     Restore the OBD Device to Defaults
    */
    func restoreToDefaults()

    /* ################################################################## */
    /**
     Turn echo on
    */
    func turnEchoOn()

    /* ################################################################## */
    /**
     Turn Echo Off
    */
    func turnEchoOff()

    /* ################################################################## */
    /**
     Flush All Events
    */
    func flushAllEvents()

    /* ################################################################## */
    /**
     Return the unit ID
    */
    func getID()

    /* ################################################################## */
    /**
     Turn on Linefeeds
    */
    func turnLinefeedsOn()

    /* ################################################################## */
    /**
     Turn Off Linefeeds
    */
    func turnLinefeedsOff()

    /* ################################################################## */
    /**
     Turn On Low Power Mode
    */
    func turnLowPowerModeOn()

    /* ################################################################## */
    /**
     Turn On Memory
    */
    func turnMemoryOn()

    /* ################################################################## */
    /**
     Turn Off Memory
    */
    func turnMemoryOff()

    /* ################################################################## */
    /**
     Return Stored Data In Memory
    */
    func fetchStoredData()

    /* ################################################################## */
    /**
     Store 1 Byte of Data in Memory

     - parameter data: 0-255, unsigned 8-bit integer.
    */
    func storeData(_ data: UInt8)

    /* ################################################################## */
    /**
     Perform a "Warm Start"
    */
    func warmStart()

    /* ################################################################## */
    /**
     Reset All
    */
    func resetAll()

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
    func useLongMessages()

    /* ################################################################## */
    /**
     Use Short <= 7Bytes) Messages
    */
    func useShortMessages()

    /* ################################################################## */
    /**
     Enable Automatic Receive
    */
    func autoReceive()

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    func useAdaptiveTimingMode1()

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
    func useAdaptiveTimingMode2()

    /* ################################################################## */
    /**
     Turn Adaptive Timing Off
    */
    func turnAdaptiveTimingOff()

    /* ################################################################## */
    /**
     Return a Buffer Dump
    */
    func bufferDump()

    /* ################################################################## */
    /**
     Bypass the Initialization Sequence
    */
    func bypassInitialization()

    /* ################################################################## */
    /**
     Describe the Current Protocol
    */
    func describeCurrentProtocol()

    /* ################################################################## */
    /**
     Describe the Current Protocol as a Number
    */
    func describeProtocolByNumber()

    /* ################################################################## */
    /**
     Turn Headers On
    */
    func turnHeadersOn()

    /* ################################################################## */
    /**
     Turn Headers Off
    */
    func turnHeadersOff()

    /* ################################################################## */
    /**
     Monitor All
    */
    func monitorAll()

    /* ################################################################## */
    /**
     Set the Monitor for Receiver
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    func setMonitorForReceiver(_ monitor: UInt8)

    /* ################################################################## */
    /**
     Set the Monitor for Transmitter
     
     - parameter monitor: 0-255 (8-bit unsigned integer)
    */
    func setMonitorForTransmitter(_ monitor: UInt8)

    /* ################################################################## */
    /**
     Set the Protocol
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setProtocol(_ protocolNumber: UInt8)

    /* ################################################################## */
    /**
     Set Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setProtocol2(_ protocolNumber: UInt8)

    /* ################################################################## */
    /**
     Set Auto Protocol (1 hex Digit)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setAutoProtocol(_ protocolNumber: UInt8)

    /* ################################################################## */
    /**
     Set Auto Protocol (Alternate Try)
     
     - parameter protocolNumber: 0-7 (unsigned integer)
    */
    func setAutoProtocol2(_ protocolNumber: UInt8)

    /* ################################################################## */
    /**
     Use Auto Protocol
    */
    func useAutoProtocol()

    /* ################################################################## */
    /**
     Close the Protocol
    */
    func closeProtocol()

    /* ################################################################## */
    /**
     Turn Responses On
    */
    func turnResponsesOn()

    /* ################################################################## */
    /**
     Turn Responses Off
    */
    func turnResponsesOff()

    /* ################################################################## */
    /**
     Set the Receive Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setReceiveAddress(_ address: UInt8)

    /* ################################################################## */
    /**
     Set the Receive Address (Alternate Command)
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setReceiveAddress2(_ address: UInt8)

    /* ################################################################## */
    /**
     Turn On Print Spaces
    */
    func turnPrintSpacesOn()

    /* ################################################################## */
    /**
     Turn Off Print Spaces
    */
    func turnPrintSpacesOff()

    /* ################################################################## */
    /**
     Set Header
     
     - parameter pref: Prefix 0-7
     - parameter value: 0-255
    */
    func setHeader(_ pref: UInt8, _ value: UInt8)

    /* ################################################################## */
    /**
     Set Header
     
     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
    */
    func setHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8)

    /* ################################################################## */
    /**
     Set Standard (J1978) Search Order
    */
    func useStandardSearchOrder()

    /* ################################################################## */
    /**
     Set Tester Address
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setTesterAddress(_ address: UInt8)

    /* ################################################################## */
    /**
     Set Timeout to Multiples of 4ms
     
     - parameter timeout: 0-255 (8-bit unsigned integer)
    */
    func setTimeOutBy4MillisecondIntervals(_ timeout: UInt8)

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
    func turnCANAutoFormattingOn()

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting Off
    */
    func turnCANAutoFormattingOff()

    /* ################################################################## */
    /**
     Turn on CAN Extended Addressing, and Set it to the Given Value
     
     - parameter address: 0-255 (8-bit unsigned integer)
    */
    func setCANExtendedAddressing(_ address: UInt8)

    /* ################################################################## */
    /**
     Turn CAN Extended Addressing Off
    */
    func turnOffCANExtendedAddressing()

    /* ################################################################## */
    /**
     Set the ID Filter
     
     - paramater pref: Prefix 0-7
     - parameter value: 0-255
    */
    func setIDFilter(_ pref: UInt8, _ value: UInt8)

    /* ################################################################## */
    /**
     Set the ID Filter

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    func setIDFilter(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8)

    /* ################################################################## */
    /**
     Turn CAN Flow Control On
    */
    func turnCANFlowControlOn()

    /* ################################################################## */
    /**
     Turn CAN Flow Control Off
    */
    func turnCANFlowControlOff()

    /* ################################################################## */
    /**
     Turn CAN Silent Mode On
    */
    func turnCANSilentModeOn()

    /* ################################################################## */
    /**
     Turn CAN Silent Mode Off
    */
    func turnCANSilentModeOff()

    /* ################################################################## */
    /**
     Turn DLC Display On
    */
    func turnDLCDisplayOn()

    /* ################################################################## */
    /**
     Turn DLC Display Off
    */
    func turnDLCDisplayOff()

    /* ################################################################## */
    /**
     Set the CAN Flow Control Data
     
     - parameter values: Up to 5 values of 0-255
    */
    func setFlowControlData(_ values: [UInt8])

    /* ################################################################## */
    /**
     Set the CAN Flow Control Header

     - parameter value1: 0-255
     - parameter value2: 0-255
     - parameter value3: 0-255
     - parameter value4: 0-255
    */
    func setFlowControlHeader(_ value1: UInt8, _ value2: UInt8, _ value3: UInt8, _ value4: UInt8)

    /* ################################################################## */
    /**
     Set the CAN Flow Control Mode
     
     - parameter mode: 0-7
    */
    func setFlowControlMode(_ mode: UInt8)

    /* ################################################################## */
    /**
     Set the Protocol B Options and Baud Rate

     - parameter options: 0-255
     - parameter baudRate: 0-255
    */
    func setProtocolBOptionsAndBaudRate(_ options: UInt8, _ baudRate: UInt8)

    /* ################################################################## */
    /**
     Send an RTR Message
    */
    func rtrMessage()

    /* ################################################################## */
    /**
     Turn the Variable DLC On
    */
    func turnVariableDLCOn()

    /* ################################################################## */
    /**
     Turn the Variable DLC Off
    */
    func turnVariableDLCOff()

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
    func setCalibratingVoltage(_ value: Float)

    /* ################################################################## */
    /**
     Reset the Calibration Voltage
    */
    func resetCalibratingVoltage()

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
    func monitorForDM1Messages()

    /* ################################################################## */
    /**
     Use ELM Data Format
    */
    func useElmDataFormat()

    /* ################################################################## */
    /**
     Use SAE Data Format
    */
    func useSAEDataFormat()

    /* ################################################################## */
    /**
     Turn Header Formatting On
    */
    func turnJ1939HeaderFormattingOn()

    /* ################################################################## */
    /**
     Turn Header Formatting Off
    */
    func turnJ1939HeaderFormattingOff()

    /* ################################################################## */
    /**
     Use the 1X Timer Multiplier
    */
    func use1XTimerMultiplier()

    /* ################################################################## */
    /**
     Use the 5X Timer Multiplier
    */
    func use5XTimerMultiplier()

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
    */
    func setPGNMonitor(_ value: UInt64)

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
     - parameter messages: 0-7 (the number of messages to receive)
    */
    func setPGNMonitorGetMessages(_ value: UInt64, _ messages: UInt8)

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
    func getIFRValueFromHeader()

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Source
    */
    func getIFRValueFromSource()

    /* ################################################################## */
    /**
     Turn IFRs On
    */
    func turnIFRsOn()

    /* ################################################################## */
    /**
     Turn On IFRs, and Set to Auto
    */
    func useIFRsAuto()

    /* ################################################################## */
    /**
     Turn IFRs Off
    */
    func turnIFRsOff()

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
    func isoBaudRate10400()

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 4800
    */
    func isoBaudRate4800()

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 9600
    */
    func isoBaudRate9600()

    /* ################################################################## */
    /**
     Set the ISO Initial Address
     
     - parameter address: 0-255
    */
    func setISOInitAddress(_ address: UInt8)

    /* ################################################################## */
    /**
     Display Keywords
    */
    func displayKeywords()

    /* ################################################################## */
    /**
     Turn Keyword Checking On
    */
    func turnKeywordCheckingOn()

    /* ################################################################## */
    /**
     Turn Keyword Checking Off
    */
    func turnKeywordCheckingOff()

    /* ################################################################## */
    /**
     Perform a Slow Initiation
    */
    func performSlowInitiation()

    /* ################################################################## */
    /**
     Set the Wakeup Interval to Multiple of 4ms
     
     - parameter multiplier: 0-255
    */
    func setWakeupIntervalMultiplerBy20ms(_ multiplier: UInt8)

    /* ################################################################## */
    /**
     Set the Wakeup Message
     
     - parameter message: Up to 6 0-255
    */
    func setWakeupMessage(_ message: [UInt8])

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
    func turnAllPPsProgParametersOn()

    /* ################################################################## */
    /**
     Turn Off All Program Parameters
    */
    func turnAllPPsProgParametersOff()

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    func setPPsProgParameterOnFor(_ index: UInt8)

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
    func setPPsProgParameterOffFor(_ index: UInt8)

    /* ################################################################## */
    /**
     Set the Given Program Parameter to the Given Value
     
     - parameter value: 0-255
     - parameter for: Parameter index 0-255
    */
    func setPPsProgParameterValue(_ value: UInt8, for: UInt8)

    /* ################################################################## */
    /**
     Return a PPs Summary
    */
    func ppSummary()
}
