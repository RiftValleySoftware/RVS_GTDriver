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
// MARK: - RVS_BTDriver_OBD_Commands Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 */
internal enum RVS_BTDriver_OBD_Commands: String {
    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /**
    This applies to the "General" group of commands.
    */
    /// Return the device description (no parameters)
    case getDeviceDescription
    /// Return the device ID (no parameters)
    case getDeviceIdentifier
    /// Set the device ID (Character String -Up to 12 ASCII Characters)
    case setDeviceIdentifier
    /// Set the Baud Rate Divisor (Up to 2 hex digits)
    case setBaudRateDivisor
    /// Set the Baud Rate Rate Handshake Timeout (Up to 2 hex digits)
    case setBaudRateHandshakeTimeout
    /// Restore the OBD Device to Defaults (no parameters)
    case restoreToDefaults
    /// Turn echo on (no parameters)
    case turnEchoOn
    /// Turn Echo Off (no parameters)
    case turnEchoOff
    /// Flush All Events (no parameters)
    case flushAllEvents
    /// Return the unit ID (no parameters)
    case getID
    /// Turn on Linefeeds (no parameters)
    case turnLinefeedsOn
    /// Turn Off Linefeeds (no parameters)
    case turnLinefeedsOff
    /// Turn On Low Power Mode (no parameters)
    case turnLowPowerModeOn
    /// Turn On Memory (no parameters)
    case turnMemoryOn
    /// Turn Off Memory (no parameters)
    case turnMemoryOff
    /// Return Stored Data In Memory (no parameters)
    case fetchStoredData
    /// Store 1 Byte of Data in Memory (Up to 2 Hex Digits)
    case storeData
    /// Perform a "Warm Start" (no parameters)
    case warmStart
    /// Reset All (no parameters)
    case resetAll

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /**
     This applies to the "OBD" group of commands.
     */
    /// Use Long (>7 Byte) Messages (no parameters)
    case useLongMessages
    /// Use Short <= 7Bytes) Messages (no parameters)
    case useShortMessages
    /// Enable Automatic Receive (no parameters)
    case autoReceive
    /// Enable Adaptive Timing Auto Mode 1 (no parameters)
    case useAdaptiveTimingMode1
    /// Enable Adaptive Timing Auto Mode 1 (no parameters)
    case useAdaptiveTimingMode2
    /// Turn Adaptive Timing Off (no parameters)
    case turnAdaptiveTimingOff
    /// Return a Buffer Dump (no parameters)
    case bufferDump
    /// Bypass the Initialization Sequence (no parameters)
    case bypassInitialization
    /// Describe the Current Protocol (no parameters)
    case describeCurrentProtocol
    /// Describe the Current Protocol as a Number (no parameters)
    case describeProtocolByNumber
    /// Turn Headers On (no parameters)
    case turnHeadersOn
    /// Turn Headers Off (no parameters)
    case turnHeadersOff
    /// Monitor All (no parameters)
    case monitorAll
    /// Set the Monitor for Receiver (Up to 2 Hex Digits)
    case setMonitorForReceiver
    /// Set the Monitor for Transmitter (Up to 2 Hex Digits)
    case setMonitorForTransmitter
    /// Set the Protocol (1 Hex Digit)
    case setProtocol
    /// Set Protocol (Alternate Try -1 Hex Digit)
    case setProtocol2
    /// Set Auto Protocol (1 hex Digit)
    case setAutoProtocol
    /// Set Auto Protocol (Alternate Try -1 Hex Digit)
    case setAutoProtocol2
    /// Use Auto Protocol (no parameters)
    case useAutoProtocol
    /// Close the Protocol (no parameters)
    case closeProtocol
    /// Turn Responses On (no parameters)
    case turnResponsesOn
    /// Turn Responses Off (no parameters)
    case turnResponsesOff
    /// Set the Receive Address (Up to 2 Hex Digits)
    case setReceiveAddress
    /// Set the Receive Address (Alternate Command -Up to 2 Hex Digits)
    case setReceiveAddress2
    /// Turn On Print Spaces (no parameters)
    case turnPrintSpacesOn
    /// Turn Off Print Spaces (no parameters)
    case turnPrintSpacesOff
    /// Set Header (1 Hex Digit, and 2 Hex Digits)
    case setHeader1
    /// Set Header (3 Groups of 2 Hex Digits)
    case setHeader2
    /// Set Standard (J1978) Search Order (no parameters)
    case useStandardSearchOrder
    /// Set Tester Address (Up to 2 Hex Digits)
    case setTesterAddress
    /// Set Timeout to Multiples of 4ms (Up to 2 Hex Digits)
    case setTimeOutBy4MillisecondIntervals
    
    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /**
     This applies to the "CAN" group of commands.
     */
    /// Turn CAN Auto-Formatting On (no parameters)
    case turnCANAutoFormattingOn
    /// Turn CAN Auto-Formatting Off (no parameters)
    case turnCANAutoFormattingOff
    /// Turn on CAN Extended Addressing, and Set it to the Given Value (Up to 2 Hex Digits)
    case setCANExtendedAddressing
    /// Turn CAN Extended Addressing Off (no parameters)
    case turnOffCANExtendedAddressing
    /// Set the ID Filter (3 Hex Digits -1, and 2)
    case setIDFilter1
    /// Set the ID Filter (4 Groups of 2 Hex Digits)
    case setIDFilter2
    /// Turn CAN Flow Control On (no parameters)
    case turnCANFlowControlOn
    /// Turn CAN Flow Control Off (no parameters)
    case turnCANFlowControlOff
    /// Turn CAN Silent Mode On (no parameters)
    case turnCANSilentModeOn
    /// Turn CAN Silent Mode Off (no parameters)
    case turnCANSilentModeOff
    /// Turn DLC Display On (no parameters)
    case turnDLCDisplayOn
    /// Turn DLC Display Off (no parameters)
    case turnDLCDisplayOff
    /// Set the CAN Flow Control Data (Up to 5 Hex Bytes -10 Digits)
    case setFlowControlData
    /// Set the CAN Flow Control Header (4 Groups of 2 Hex Digits)
    case setFlowControlHeader
    /// Set the CAN Flow Control Mode (1 Hex Digit)
    case setFlowControlMode
    /// Set the Protocol B Options and Baud Rate (2 Groups of 2 Hex Digits)
    case setProtocolBOptionsAndBaudRate
    /// Send an RTR Message (no parameters)
    case rtrMessage
    /// Turn the Variable DLC On (no parameters)
    case turnVariableDLCOn
    /// Turn the Variable DLC Off (no parameters)
    case turnVariableDLCOff

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /**
     This applies to the "Volts" group of commands.
     */
    /// Set the Calibration Volts (Fixed Decimal -2 Places)
    case setCalibratingVoltage
    /// Reset the Calibration Voltage (no parameters)
    case resetCalibratingVoltage

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1939" group of commands.
     */
    /// Monitor for DM1 Messages (no parameters)
    case monitorForDM1Messages
    /// Use ELM Data Format (no parameters)
    case useElmDataFormat
    /// Use SAE Data Format (no parameters)
    case useSAEDataFormat
    /// Turn Header Formatting On (no parameters)
    case turnJ1939HeaderFormattingOn
    /// Turn Header Formatting Off (no parameters)
    case turnJ1939HeaderFormattingOff
    /// Use the 1X Timer Multiplier (no parameters)
    case use1XTimerMultiplier
    /// Use the 5X Timer Multiplier (no parameters)
    case use5XTimerMultiplier
    /// Set the PGN Monitor (Up to 4 Hex Digits)
    case setPGNMonitor1
    /// Set the PGN Monitor (Up to six Hex Digits)
    case setPGNMonitor2
    /// Set the PGN Monitor (Up to 4 Hex Digits, and 1 Hex Digit)
    case setPGNMonitorGetMessages

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1850" group of commands.
     */
    /// The IFR Value Should be Set From the Header (no parameters)
    case getIFRValueFromHeader
    /// The IFR Value Should be Set From the Source (no parameters)
    case getIFRValueFromSource
    /// Turn IFRs On (no parameters)
    case turnIFRsOn
    /// Turn On IFRs, and Set to Auto (no parameters)
    case useIFRsAuto
    /// Turn IFRs Off (no parameters)
    case turnIFRsOff

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /**
     This applies to the "ISO" group of commands.
     */
    /// Try to Set Baud Rate to 10400 (no parameters)
    case isoBaudRate10400
    /// Try to Set Baud Rate to 4800 (no parameters)
    case isoBaudRate4800
    /// Try to Set Baud Rate to 9600 (no parameters)
    case isoBaudRate9600
    /// Set the ISO Initial Address (Up to 2 Hex Digits)
    case setISOInitAddress
    /// Display Keywords (no parameters)
    case displayKeywords
    /// Turn Keyword Checking On (no parameters)
    case turnKeywordCheckingOn
    /// Turn Keyword Checking Off (no parameters)
    case turnKeywordCheckingOff
    /// Perform a Slow Initiation (no parameters)
    case performSlowInitiation
    /// Set the Wakeup Interval to Multiple of 4ms (Up to 2 Hex Digits)
    case setWakeupIntervalMultiplerBy20ms
    /// Set the Wakeup Message (Up to 6 Bytes -12 Hex Digits)
    case setWakeupMessage

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /**
     This applies to the "PPs" group of commands.
     */
    /// Turn On All Program Parameters (no parameters)
    case turnAllPPsProgParametersOn
    /// Turn Off All Program Parameters (no parameters)
    case turnAllPPsProgParametersOff
    /// Turn On the Given Program Parameter (Up to 2 Hex Digits)
    case setPPsProgParameterOn
    /// Turn On the Given Program Parameter (Up to 2 Hex Digits)
    case setPPsProgParameterOff
    /// Set the Given Program Parameter to the Given Value (2 Sets of 2 Hex Digits)
    case setPPsProgParameterValue
    /// Return a PPs Summary (no parameters)
    case ppSummary
}
