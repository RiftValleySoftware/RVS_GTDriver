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

/**
 These are ATXXX commands for the EML327 chipset.
 */

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_General Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 */
public enum RVS_BTDriver_OBD_Command_String_General: String {
    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /**
    This applies to the "General" group of commands.
    */
    /// Return the device description (no parameters)
    case getDeviceDescription               =   "AT@1"
    /// Return the device ID (no parameters)
    case getDeviceIdentifier                =   "AT@2"
    /// Set the device ID (Character String -Up to 12 ASCII Characters)
    case setDeviceIdentifier                =   "AT@3 %s"
    /// Set the Baud Rate Divisor (Up to 2 hex digits)
    case setBaudRateDivisor                 =   "ATBRD %2x"
    /// Set the Baud Rate Rate Handshake Timeout (Up to 2 hex digits)
    case setBaudRateHandshakeTimeout        =   "ATBRT %2x"
    /// Restore the OBD Device to Defaults (no parameters)
    case restoreToDefaults                  =   "ATD"
    /// Turn echo on (no parameters)
    case turnEchoOn                         =   "ATE1"
    /// Turn Echo Off (no parameters)
    case turnEchoOff                        =   "ATE0"
    /// Flush All Events (no parameters)
    case flushAllEvents                     =   "ATFE"
    /// Return the unit ID (no parameters)
    case getID                              =   "ATI"
    /// Turn on Linefeeds (no parameters)
    case turnLinefeedsOn                    =   "ATL1"
    /// Turn Off Linefeeds (no parameters)
    case turnLinefeedsOff                   =   "ATL0"
    /// Turn On Low Power Mode (no parameters)
    case turnLowPowerModeOn                 =   "ATLP"
    /// Turn On Memory (no parameters)
    case turnMemoryOn                       =   "ATM1"
    /// Turn Off Memory (no parameters)
    case turnMemoryOff                      =   "ATM0"
    /// Return Stored Data In Memory (no parameters)
    case fetchStoredData                    =   "ATRD"
    /// Store 1 Byte of Data in Memory (Up to 2 Hex Digits)
    case storeData                          =   "ATSD %2x"
    /// Perform a "Warm Start" (no parameters)
    case warmStart                          =   "ATWS"
    /// Reset All (no parameters)
    case resetAll                           =   "ATZ"

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /**
     This applies to the "OBD" group of commands.
     */
    /// Use Long (>7 Byte) Messages (no parameters)
    case useLongMessages                    =   "ATAL"
    /// Use Short <= 7Bytes) Messages (no parameters)
    case useShortMessages                   =   "ATNL"
    /// Enable Automatic Receive (no parameters)
    case autoReceive                        =   "ATAR"
    /// Enable Adaptive Timing Auto Mode 1 (no parameters)
    case useAdaptiveTimingMode1             =   "ATAT1"
    /// Enable Adaptive Timing Auto Mode 1 (no parameters)
    case useAdaptiveTimingMode2             =   "ATAT2"
    /// Turn Adaptive Timing Off (no parameters)
    case turnAdaptiveTimingOff              =   "ATAT0"
    /// Return a Buffer Dump (no parameters)
    case bufferDump                         =   "ATBD"
    /// Bypass the Initialization Sequence (no parameters)
    case bypassInitialization               =   "ATBI"
    /// Describe the Current Protocol (no parameters)
    case describeCurrentProtocol            =   "ATDP"
    /// Describe the Current Protocol as a Number (no parameters)
    case describeProtocolByNumber           =   "ATDPN"
    /// Turn Headers On (no parameters)
    case turnHeadersOn                      =   "ATH1"
    /// Turn Headers Off (no parameters)
    case turnHeadersOff                     =   "ATH0"
    /// Monitor All (no parameters)
    case monitorAll                         =   "ATMA"
    /// Set the Monitor for Receiver (Up to 2 Hex Digits)
    case setMonitorForReceiver              =   "ATMR %2x"
    /// Set the Monitor for Transmitter (Up to 2 Hex Digits)
    case setMonitorForTransmitter           =   "ATMT %2x"
    /// Set the Protocol (1 Hex Digit)
    case setProtocol                        =   "ATSP %1x"
    /// Set Protocol (Alternate -Try -1 Hex Digit)
    case setProtocol2                       =   "ATTP %x"
    /// Set Auto Protocol (1 hex Digit)
    case setAutoProtocol                    =   "ATSP A%1x"
    /// Set Auto Protocol (Alternate -Try -1 Hex Digit)
    case setAutoProtocol2                   =   "ATTP A%1x"
    /// Use Auto Protocol (no parameters)
    case useAutoProtocol                    =   "ATSP 00"
    /// Close the Protocol (no parameters)
    case closeProtocol                      =   "ATPC"
    /// Turn Responses On (no parameters)
    case turnResponsesOn                    =   "ATR1"
    /// Turn Responses Off (no parameters)
    case turnResponsesOff                   =   "ATR0"
    /// Set the Receive Address (Up to 2 Hex Digits)
    case setReceiveAddress                  =   "ATRA %2x"
    /// Set the Receive Address (Alternate Command -Up to 2 Hex Digits)
    case setReceiveAddress2                 =   "ATSR %2x"
    /// Turn On Print Spaces (no parameters)
    case turnPrintSpacesOn                  =   "ATS1"
    /// Turn Off Print Spaces (no parameters)
    case turnPrintSpacesOff                 =   "ATS0"
    /// Set Header (Up to 3 Hex Digits)
    case setHeader1                         =   "ATSH %3x"
    /// Set Header (3 Groups of 2 Hex Digits)
    case setHeader2                         =   "ATSH %2x %2x %2x"
    /// Set Standard (J1978) Search Order (no parameters)
    case useStandardSearchOrder             =   "ATSS"
    /// Set Tester Address (Up to 2 Hex Digits)
    case setTesterAddress                   =   "ATTA %2x"
    /// Set Timeout to Multiples of 4ms (Up to 2 Hex Digits)
    case setTimeOutBy4MillisecondIntervals  =   "ATST %2x"
    
    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /**
     This applies to the "CAN" group of commands.
     */
    /// Turn CAN Auto-Formatting On (no parameters)
    case turnCANAutoFormattingOn            =   "ATCAF1"
    /// Turn CAN Auto-Formatting Off (no parameters)
    case turnCANAutoFormattingOff           =   "ATCAF0"
    /// Turn on CAN Extended Addressing, and Set it to the Given Value (Up to 2 Hex Digits)
    case setCANExtendedAddressing           =   "ATCEA %2x"
    /// Turn CAN Extended Addressing Off (no parameters)
    case turnOffCANExtendedAddressing       =   "ATCEA"
    /// Set the ID Filter (3 Hex Digits -1, and 2)
    case setIDFilter1                       =   "ATCF %1x2x"
    /// Set the ID Filter (4 Groups of 2 Hex Digits)
    case setIDFilter2                       =   "ATCF %2x %2x %2x %2x"
    /// Turn CAN Flow Control On (no parameters)
    case turnCANFlowControlOn               =   "ATCFC1"
    /// Turn CAN Flow Control Off (no parameters)
    case turnCANFlowControlOff              =   "ATCFC0"
    /// Turn CAN Silent Mode On (no parameters)
    case turnCANSilentModeOn                =   "ATCSM1"
    /// Turn CAN Silent Mode Off (no parameters)
    case turnCANSilentModeOff               =   "ATCSM0"
    /// Turn DLC Display On (no parameters)
    case turnDLCDisplayOn                   =   "ATD0"
    /// Turn DLC Display Off (no parameters)
    case turnDLCDisplayOff                  =   "ATD1"
    /// Set the CAN Flow Control Data (Up to 5 Hex Bytes -10 Digits)
    case setFlowControlData                 =   "ATFC SD %10x"
    /// Set the CAN Flow Control Header (4 Groups of 2 Hex Digits)
    case setFlowControlHeader               =   "ATFC SH %2x %2x %2x %2x"
    /// Set the CAN Flow Control Mode (1 Hex Digit)
    case setFlowControlMode                 =   "ATFC SM %1x"
    /// Set the Protocol B Options and Baud Rate (2 Groups of 2 Hex Digits)
    case setProtocolBOptionsAndBaudRate     =   "ATPB %2x %2x"
    /// Send an RTR Message (no parameters)
    case rtrMessage                         =   "ATRTR"
    /// Turn the Variable DLC On (no parameters)
    case turnVariableDLCOn                  =   "ATV1"
    /// Turn the Variable DLC Off (no parameters)
    case turnVariableDLCOff                 =   "ATV0"

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /**
     This applies to the "Volts" group of commands.
     */
    /// Set the Calibration Volts (Fixed Decimal -2 Places)
    case setCalibratingVoltage              =   "ATCV %.2f"
    /// Reset the Calibration Voltage (no parameters)
    case resetCalibratingVoltage            =   "ATCV 0000"

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1939" group of commands.
     */
    /// Monitor for DM1 Messages (no parameters)
    case monitorForDM1Messages              =   "ATDM1"
    /// Use ELM Data Format (no parameters)
    case useElmDataFormat                   =   "ATJE"
    /// Use SAE Data Format (no parameters)
    case useSAEDataFormat                   =   "ATJS"
    /// Turn Header Formatting On (no parameters)
    case turnJ1939HeaderFormattingOn        =   "ATJHF1"
    /// Turn Header Formatting Off (no parameters)
    case turnJ1939HeaderFormattingOff       =   "ATJHF0"
    /// Use the 1X Timer Multiplier (no parameters)
    case use1XTimerMultiplier               =   "ATJTM1"
    /// Use the 5X Timer Multiplier (no parameters)
    case use5XTimerMultiplier               =   "ATJTM5"
    /// Set the PGN Monitor (Up to 4 Hex Digits)
    case setPGNMonitor1                     =   "ATMP %4x"
    /// Set the PGN Monitor (Up to six Hex Digits)
    case setPGNMonitor2                     =   "ATMP %6x"
    /// Set the PGN Monitor (Up to 4 Hex Digits, and 1 Hex Digit)
    case setPGNMonitorGetMessages           =   "ATMP %4x %1x"

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /**
     This applies to the "J1850" group of commands.
     */
    /// The IFR Value Should be Set From the Header (no parameters)
    case setIFRValueFromHeader              =   "ATIFR H"
    /// The IFR Value Should be Set From the Source (no parameters)
    case setIFRValueFromSource              =   "ATIFR S"
    /// Turn IFRs On (no parameters)
    case turnIFRsOn                         =   "ATIFR2"
    /// Turn On IFRs, and Set to Auto (no parameters)
    case useIFRsAuto                        =   "ATIFR1"
    /// Turn IFRs Off (no parameters)
    case turnIFRsOff                        =   "ATIFR0"

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /**
     This applies to the "ISO" group of commands.
     */
    /// Try to Set Baud Rate to 10400 (no parameters)
    case isoBaudRate10400                   =   "ATIB 10"
    /// Try to Set Baud Rate to 4800 (no parameters)
    case isoBaudRate4800                    =   "ATIB 48"
    /// Try to Set Baud Rate to 9600 (no parameters)
    case isoBaudRate9600                    =   "ATIB 96"
    /// Set the ISO Initial Address (Up to 2 Hex Digits)
    case setISOInitAddress                  =   "ATIIA %2x"
    /// Display Keywords (no parameters)
    case displayKeywords                    =   "ATKW"
    /// Turn Keyword Checking On (no parameters)
    case turnKeywordCheckingOn              =   "ATKW1"
    /// Turn Keyword Checking Off (no parameters)
    case turnKeywordCheckingOff             =   "ATKW0"
    /// Perform a Slow Initiation (no parameters)
    case performSlowInitiation              =   "ATSI"
    /// Set the Wakeup Interval to Multiple of 4ms (Up to 2 Hex Digits)
    case setWakeupIntervalMultiplerBy20ms   =   "ATSW %2x"
    /// Set the Wakeup Message (Up to 6 Bytes -12 Hex Digits)
    case setWakeupMessage                   =   "ATWM %12x"

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /**
     This applies to the "PPs" group of commands.
     */
    /// Turn On All Program Parameters (no parameters)
    case turnAllPPsProgParametersOn         =   "ATPP FF ON"
    /// Turn Off All Program Parameters (no parameters)
    case turnAllPPsProgParametersOff        =   "ATPP FF OFF"
    /// Turn On the Given Program Parameter (Up to 2 Hex Digits)
    case setPPsProgParameterOn              =   "ATPP %2x ON"
    /// Turn On the Given Program Parameter (Up to 2 Hex Digits)
    case setPPsProgParameterOff             =   "ATPP %2x OFF"
    /// Set the Given Program Parameter to the Given Value (2 Sets of 2 Hex Digits)
    case setPPsProgParameterValue           =   "ATPP %2x SV %2x"
    /// Return a PPs Summary (no parameters)
    case ppSummary                          =   "ATPPS"
}
