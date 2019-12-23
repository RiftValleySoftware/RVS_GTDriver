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
 These should all be preceded by "AT".
 */

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_General Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "General" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_General: String {
    case getDeviceDescription               =   "@1"
    case getDeviceIdentifier                =   "@2"
    case setDeviceIdentifier                =   "@3 %s"
    case setBaudRateDivisor                 =   "BRD %s"
    case setBaudRateHandshakeTimeout        =   "BRT %s"
    case restoreToDefaults                  =   "D"
    case turnEchoOn                         =   "E1"
    case turnEchoOff                        =   "E0"
    case flushAllEvents                     =   "FE"
    case getID                              =   "I"
    case turnLinefeedsOn                    =   "L1"
    case turnLinefeedsOff                   =   "L0"
    case turnLowPowerModeOn                 =   "LP"
    case turnMemoryOn                       =   "M1"
    case turnMemoryOff                      =   "M0"
    case fetchStoredData                    =   "RD"
    case storeData                          =   "SD"
    case warmStart                          =   "WS"
    case resetAll                           =   "Z"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_OBD Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "OBD" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_OBD: String {
    case useLongMessages                    =   "AL"
    case useShortMessages                   =   "NL"
    case autoReceive                        =   "AR"
    case useAdaptiveTimingMode1             =   "AT1"
    case useAdaptiveTimingMode2             =   "AT2"
    case turnAdaptiveTimingOff              =   "AT0"
    case bufferDump                         =   "BD"
    case bypassInitialization               =   "BI"
    case describeCurrentProtocol            =   "DP"
    case describeProtocolByNumber           =   "DPN"
    case turnHeadersOn                      =   "H1"
    case turnHeadersOff                     =   "H0"
    case monitorAll                         =   "MA"
    case setMonitorForReceiver              =   "MR %s"
    case setMonitorForTransmitter           =   "MT %s"
    case setProtocol                        =   "SP %s"
    case setAutoProtocol                    =   "SP A"
    case useAutoProtocol                    =   "SP 00"
    case closeProtocol                      =   "PC"
    case turnResponsesOn                    =   "R1"
    case turnResponsesOff                   =   "R0"
    case setReceiveAddress                  =   "RA %s"
    case setReceiveAddress2                 =   "SR %s"
    case turnPrintSpacesOn                  =   "S1"
    case turnPrintSpacesOff                 =   "S0"
    case setHeader                          =   "SH %s"
    case useStandardSearchOrder             =   "SS"
    case setTimeOutBy4MillisecondIntervals  =   "ST %s"
    case setTesterAddress                   =   "TA %s"
    case tryProtocol                        =   "TP %s"
    case tryAutoProtocol                    =   "TP A"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_CAN Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "CAN" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_CAN: String {
    case turnCANAutoFormattingOn            =   "CAF1"
    case turnCANAutoFormattingOff           =   "CAF0"
    case setCANExtendedAddressing           =   "CEA %s"
    case turnOffCANExtendedAddressing       =   "CEA"
    case setIDFilter                        =   "CF %s"
    case turnCANFlowControlOn               =   "CFC1"
    case turnCANFlowControlOff              =   "CFC0"
    case turnCANSilentModeOn                =   "CSM1"
    case turnCANSilentModeOff               =   "CSM0"
    case turnDLCDisplayOn                   =   "D0"
    case turnDLCDisplayOff                  =   "D1"
    case setFlowControlData                 =   "FC SD %s"
    case setFlowControlHeader               =   "FC SH %s"
    case setFlowControlMode                 =   "FC SM %s"
    case setProtocolBOptionsAndBaudRate     =   "PB %s"
    case rtrMessage                         =   "RTR"
    case turnVariableDLCOn                  =   "V1"
    case turnVariableDLCOff                 =   "V0"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_Volts Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "Volts" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_Volts: String {
    case setCalibratingVoltage              =   "CV %s"
    case resetCalibratingVoltage            =   "CV 0000"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_J1939 Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "J1939" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_J1939: String {
    case monitorForDM1Messages              =   "DM1"
    case useElmDataFormat                   =   "JE"
    case useSAEDataFormat                   =   "JS"
    case turnJ1939HeaderFormattingOn        =   "JHF1"
    case turnJ1939HeaderFormattingOff       =   "JHF0"
    case use1XTimerMultiplier               =   "JTM1"
    case use5XTimerMultiplier               =   "JTM5"
    case setPGNMonitor                      =   "MP %s"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_J1850 Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "J1850" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_J1850: String {
    case setIFRValueFromHeader              =   "IFR H"
    case setIFRValueFromSource              =   "IFR S"
    case turnIFRsOn                         =   "IFR2"
    case useIFRsAuto                        =   "IFR1"
    case turnIFRsOff                        =   "IFR0"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_ISO Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "ISO" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_ISO: String {
    case isoBaudRate10400                   =   "IB 10"
    case isoBaudRate4800                    =   "IB 48"
    case isoBaudRate9600                    =   "IB 96"
    case setISOInitAddress                  =   "IIA %s"
    case displayKeywords                    =   "KW"
    case turnKeywordCheckingOn              =   "KW1"
    case turnKeywordCheckingOff             =   "KW0"
    case performSlowInitiation              =   "SI"
    case setWakeupIntervalMultiplerBy20ms   =   "SW %s"
    case setWakeupMessage                   =   "WM %s"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_String_PPs Enum -
/* ###################################################################################################################################### */
/**
 This enum is used to define OBD Commands As Strings.
 This applies to the "PPs" group of commands.
 */
public enum RVS_BTDriver_OBD_Command_String_PPs: String {
    case turnAllPPsProgParametersOn         =   "PP FF ON"
    case turnAllPPsProgParametersOff        =   "PP FF OFF"
    case setPPsProgParameterOn              =   "PP %s ON"
    case setPPsProgParameterOff             =   "PP %s OFF"
    case setPPsProgParameterValue           =   "PP %s SV %s"
    case ppSummary                          =   "PPS"
}
