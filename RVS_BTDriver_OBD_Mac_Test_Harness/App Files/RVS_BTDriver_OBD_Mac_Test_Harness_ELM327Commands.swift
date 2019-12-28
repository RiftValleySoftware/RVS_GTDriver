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
 */
let commandDictionary: [String: String] = [
    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /**
    This applies to the "General" group of commands.
    */
	"getDeviceDescription": "Return the device description (no parameters)",
	"getDeviceIdentifier": "Return the device ID (no parameters)",
	"setDeviceIdentifier": "Set the device ID (Character String -Up to 12 ASCII Characters)",
	"setBaudRateDivisor": "Set the Baud Rate Divisor (Up to 2 hex digits)",
	"setBaudRateHandshakeTimeout": "Set the Baud Rate Rate Handshake Timeout (Up to 2 hex digits)",
	"restoreToDefaults": "Restore the OBD Device to Defaults (no parameters)",
	"turnEchoOn": "Turn echo on (no parameters)",
	"turnEchoOff": "Turn Echo Off (no parameters)",
	"flushAllEvents": "Flush All Events (no parameters)",
	"getID": "Return the unit ID (no parameters)",
	"turnLinefeedsOn": "Turn on Linefeeds (no parameters)",
	"turnLinefeedsOff": "Turn Off Linefeeds (no parameters)",
	"turnLowPowerModeOn": "Turn On Low Power Mode (no parameters)",
	"turnMemoryOn": "Turn On Memory (no parameters)",
	"turnMemoryOff": "Turn Off Memory (no parameters)",
	"fetchStoredData": "Return Stored Data In Memory (no parameters)",
	"storeData": "Store 1 Byte of Data in Memory (Up to 2 Hex Digits)",
	"warmStart": "Perform a \"Warm Start\" (no parameters)",
	"resetAll": "Reset All (no parameters)",

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /**
     This applies to the "OBD" group of commands.
     */
	"useLongMessages": "Use Long (>7 Byte) Messages (no parameters)",
	"useShortMessages": "Use Short <= 7Bytes) Messages (no parameters)",
	"autoReceive": "Enable Automatic Receive (no parameters)",
	"useAdaptiveTimingMode1": "Enable Adaptive Timing Auto Mode 1 (no parameters)",
	"useAdaptiveTimingMode2": "Enable Adaptive Timing Auto Mode 1 (no parameters)",
	"turnAdaptiveTimingOff": "Turn Adaptive Timing Off (no parameters)",
	"bufferDump": "Return a Buffer Dump (no parameters)",
	"bypassInitialization": "Bypass the Initialization Sequence (no parameters)",
	"describeCurrentProtocol": "Describe the Current Protocol (no parameters)",
	"describeProtocolByNumber": "Describe the Current Protocol as a Number (no parameters)",
	"turnHeadersOn": "Turn Headers On (no parameters)",
	"turnHeadersOff": "Turn Headers Off (no parameters)",
	"monitorAll": "Monitor All (no parameters)",
	"setMonitorForReceiver": "Set the Monitor for Receiver (Up to 2 Hex Digits)",
	"setMonitorForTransmitter": "Set the Monitor for Transmitter (Up to 2 Hex Digits)",
	"setProtocol": "Set the Protocol (1 Hex Digit)",
	"setProtocol2": "Set Protocol (Alternate Try -1 Hex Digit)",
	"setAutoProtocol": "Set Auto Protocol (1 hex Digit)",
	"setAutoProtocol2": "Set Auto Protocol (Alternate Try -1 Hex Digit)",
	"useAutoProtocol": "Use Auto Protocol (no parameters)",
	"closeProtocol": "Close the Protocol (no parameters)",
	"turnResponsesOn": "Turn Responses On (no parameters)",
	"turnResponsesOff": "Turn Responses Off (no parameters)",
	"setReceiveAddress": "Set the Receive Address (Up to 2 Hex Digits)",
	"setReceiveAddress2": "Set the Receive Address (Alternate Command -Up to 2 Hex Digits)",
	"turnPrintSpacesOn": "Turn On Print Spaces (no parameters)",
	"turnPrintSpacesOff": "Turn Off Print Spaces (no parameters)",
	"setHeader1": "Set Header (1 Hex Digit, and 2 Hex Digits)",
	"setHeader2": "Set Header (3 Groups of 2 Hex Digits)",
	"useStandardSearchOrder": "Set Standard (J1978) Search Order (no parameters)",
	"setTesterAddress": "Set Tester Address (Up to 2 Hex Digits)",
	"setTimeOutBy4MillisecondIntervals": "Set Timeout to Multiples of 4ms (Up to 2 Hex Digits)",
    
    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /**
     This applies to the "CAN" group of commands.
     */
	"turnCANAutoFormattingOn": "Turn CAN Auto-Formatting On (no parameters)",
	"turnCANAutoFormattingOff": "Turn CAN Auto-Formatting Off (no parameters)",
	"setCANExtendedAddressing": "Turn on CAN Extended Addressing, and Set it to the Given Value (Up to 2 Hex Digits)",
	"turnOffCANExtendedAddressing": "Turn CAN Extended Addressing Off (no parameters)",
	"setIDFilter1": "Set the ID Filter (3 Hex Digits -1, and 2)",
	"setIDFilter2": "Set the ID Filter (4 Groups of 2 Hex Digits)",
	"turnCANFlowControlOn": "Turn CAN Flow Control On (no parameters)",
	"turnCANFlowControlOff": "Turn CAN Flow Control Off (no parameters)",
	"turnCANSilentModeOn": "Turn CAN Silent Mode On (no parameters)",
	"turnCANSilentModeOff": "Turn CAN Silent Mode Off (no parameters)",
	"turnDLCDisplayOn": "Turn DLC Display On (no parameters)",
	"turnDLCDisplayOff": "Turn DLC Display Off (no parameters)",
	"setFlowControlData": "Set the CAN Flow Control Data (Up to 5 Hex Bytes -10 Digits)",
	"setFlowControlHeader": "Set the CAN Flow Control Header (4 Groups of 2 Hex Digits)",
	"setFlowControlMode": "Set the CAN Flow Control Mode (1 Hex Digit)",
	"setProtocolBOptionsAndBaudRate": "Set the Protocol B Options and Baud Rate (2 Groups of 2 Hex Digits)",
	"rtrMessage": "Send an RTR Message (no parameters)",
	"turnVariableDLCOn": "Turn the Variable DLC On (no parameters)",
	"turnVariableDLCOff": "Turn the Variable DLC Off (no parameters)",

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /**
     This applies to the "Volts" group of commands.
     */
	"setCalibratingVoltage": "Set the Calibration Volts (Fixed Decimal -2 Places)",
	"resetCalibratingVoltage": "Reset the Calibration Voltage (no parameters)",

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1939" group of commands.
     */
	"monitorForDM1Messages": "Monitor for DM1 Messages (no parameters)",
	"useElmDataFormat": "Use ELM Data Format (no parameters)",
	"useSAEDataFormat": "Use SAE Data Format (no parameters)",
	"turnJ1939HeaderFormattingOn": "Turn Header Formatting On (no parameters)",
	"turnJ1939HeaderFormattingOff": "Turn Header Formatting Off (no parameters)",
	"use1XTimerMultiplier": "Use the 1X Timer Multiplier (no parameters)",
	"use5XTimerMultiplier": "Use the 5X Timer Multiplier (no parameters)",
	"setPGNMonitor1": "Set the PGN Monitor (Up to 4 Hex Digits)",
	"setPGNMonitor2": "Set the PGN Monitor (Up to six Hex Digits)",
	"setPGNMonitorGetMessages": "Set the PGN Monitor (Up to 4 Hex Digits, and 1 Hex Digit)",

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1850" group of commands.
     */
	"getIFRValueFromHeader": "The IFR Value Should be Set From the Header (no parameters)",
	"getIFRValueFromSource": "The IFR Value Should be Set From the Source (no parameters)",
	"turnIFRsOn": "Turn IFRs On (no parameters)",
	"useIFRsAuto": "Turn On IFRs, and Set to Auto (no parameters)",
	"turnIFRsOff": "Turn IFRs Off (no parameters)",

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /**
     This applies to the "ISO" group of commands.
     */
	"isoBaudRate10400": "Try to Set Baud Rate to 10400 (no parameters)",
	"isoBaudRate4800": "Try to Set Baud Rate to 4800 (no parameters)",
	"isoBaudRate9600": "Try to Set Baud Rate to 9600 (no parameters)",
	"setISOInitAddress": "Set the ISO Initial Address (Up to 2 Hex Digits)",
	"displayKeywords": "Display Keywords (no parameters)",
	"turnKeywordCheckingOn": "Turn Keyword Checking On (no parameters)",
	"turnKeywordCheckingOff": "Turn Keyword Checking Off (no parameters)",
	"performSlowInitiation": "Perform a Slow Initiation (no parameters)",
	"setWakeupIntervalMultiplerBy20ms": "Set the Wakeup Interval to Multiple of 4ms (Up to 2 Hex Digits)",
	"setWakeupMessage": "Set the Wakeup Message (Up to 6 Bytes -12 Hex Digits)",

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /**
     This applies to the "PPs" group of commands.
     */
	"turnAllPPsProgParametersOn": "Turn On All Program Parameters (no parameters)",
	"turnAllPPsProgParametersOff": "Turn Off All Program Parameters (no parameters)",
	"setPPsProgParameterOn": "Turn On the Given Program Parameter (Up to 2 Hex Digits)",
	"setPPsProgParameterOff": "Turn On the Given Program Parameter (Up to 2 Hex Digits)",
	"setPPsProgParameterValue": "Set the Given Program Parameter to the Given Value (2 Sets of 2 Hex Digits)",
	"ppSummary": "Return a PPs Summary (no parameters)"
	]
