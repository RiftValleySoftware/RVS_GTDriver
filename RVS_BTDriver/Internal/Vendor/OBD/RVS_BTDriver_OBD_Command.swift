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
 These are standard OBD commands
 */

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs show the current state of the vehicle.
 */
internal enum RVS_BTDriver_OBD_Command_Service_01_PIDs: String, CaseIterable {
    /// This returns a bitmask of supported PIDs (see the `RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask` type to understand these).
    case returnSupportedPIDs    = "0100"
    /// This returns a set of flags, denoting the monitor status, since the DTCs were last cleared (see the `RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask` type to understand these).
    case returnMonitorStatus    = "0101"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_02_PIDs Enum -
/* ###################################################################################################################################### */
/**
 This is the same as the first set of PIDs, except with freeze-frame data.
 */
internal enum RVS_BTDriver_OBD_Command_Service_02_PIDs: String, CaseIterable {
    /// This returns a bitmask of supported PIDs (see the `RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask` type to understand these).
    case returnSupportedPIDs    = "0200"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_03_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs ask to return stored trouble codes.
 */
internal enum RVS_BTDriver_OBD_Command_Service_03_PIDs: String, CaseIterable {
    case returnStoredCodes    = "0300"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_04_PIDs Enum -
/* ###################################################################################################################################### */
/**
 This is a "one-shot" PID to clear test results, and reset the "check engine" light.
 */
internal enum RVS_BTDriver_OBD_Command_Service_04_PIDs: String, CaseIterable {
    case clearStoredCodes    = "0400"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_05_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are for test results that include non-CAN oxygen sensor test reults.
 */
internal enum RVS_BTDriver_OBD_Command_Service_05_PIDs: String, CaseIterable {
    case returnMonitorIDs           = "050100"
    case set_01_Bank_01_Sensor_01   = "050101"
    case set_01_Bank_01_Sensor_02   = "050102"
    case set_01_Bank_01_Sensor_03   = "050103"
    case set_01_Bank_01_Sensor_04   = "050104"
    case set_01_Bank_02_Sensor_01   = "050105"
    case set_01_Bank_02_Sensor_02   = "050106"
    case set_01_Bank_02_Sensor_03   = "050107"
    case set_01_Bank_02_Sensor_04   = "050108"
    case set_01_Bank_03_Sensor_01   = "050109"
    case set_01_Bank_03_Sensor_02   = "05010A"
    case set_01_Bank_03_Sensor_03   = "05010B"
    case set_01_Bank_03_Sensor_04   = "05010C"
    case set_01_Bank_04_Sensor_01   = "05010D"
    case set_01_Bank_04_Sensor_02   = "05010E"
    case set_01_Bank_04_Sensor_03   = "05010F"
    case set_01_Bank_04_Sensor_04   = "050110"
    case set_02_Bank_01_Sensor_01   = "050201"
    case set_02_Bank_01_Sensor_02   = "050202"
    case set_02_Bank_01_Sensor_03   = "050203"
    case set_02_Bank_01_Sensor_04   = "050204"
    case set_02_Bank_02_Sensor_01   = "050205"
    case set_02_Bank_02_Sensor_02   = "050206"
    case set_02_Bank_02_Sensor_03   = "050207"
    case set_02_Bank_02_Sensor_04   = "050208"
    case set_02_Bank_03_Sensor_01   = "050209"
    case set_02_Bank_03_Sensor_02   = "05020A"
    case set_02_Bank_03_Sensor_03   = "05020B"
    case set_02_Bank_03_Sensor_04   = "05020C"
    case set_02_Bank_04_Sensor_01   = "05020D"
    case set_02_Bank_04_Sensor_02   = "05020E"
    case set_02_Bank_04_Sensor_03   = "05020F"
    case set_02_Bank_04_Sensor_04   = "050210"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_06_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are for test results that include CAN oxygen sensor tests.
 */
internal enum RVS_BTDriver_OBD_Command_Service_06_PIDs: String, CaseIterable {
    case returnMonitorIDs           = "060100"
    case set_01_Bank_01_Sensor_01   = "060101"
    case set_01_Bank_01_Sensor_02   = "060102"
    case set_01_Bank_01_Sensor_03   = "060103"
    case set_01_Bank_01_Sensor_04   = "060104"
    case set_01_Bank_02_Sensor_01   = "060105"
    case set_01_Bank_02_Sensor_02   = "060106"
    case set_01_Bank_02_Sensor_03   = "060107"
    case set_01_Bank_02_Sensor_04   = "060108"
    case set_01_Bank_03_Sensor_01   = "060109"
    case set_01_Bank_03_Sensor_02   = "06010A"
    case set_01_Bank_03_Sensor_03   = "06010B"
    case set_01_Bank_03_Sensor_04   = "06010C"
    case set_01_Bank_04_Sensor_01   = "06010D"
    case set_01_Bank_04_Sensor_02   = "06010E"
    case set_01_Bank_04_Sensor_03   = "06010F"
    case set_01_Bank_04_Sensor_04   = "060110"
    case set_02_Bank_01_Sensor_01   = "060201"
    case set_02_Bank_01_Sensor_02   = "060202"
    case set_02_Bank_01_Sensor_03   = "060203"
    case set_02_Bank_01_Sensor_04   = "060204"
    case set_02_Bank_02_Sensor_01   = "060205"
    case set_02_Bank_02_Sensor_02   = "060206"
    case set_02_Bank_02_Sensor_03   = "060207"
    case set_02_Bank_02_Sensor_04   = "060208"
    case set_02_Bank_03_Sensor_01   = "060209"
    case set_02_Bank_03_Sensor_02   = "06020A"
    case set_02_Bank_03_Sensor_03   = "06020B"
    case set_02_Bank_03_Sensor_04   = "06020C"
    case set_02_Bank_04_Sensor_01   = "06020D"
    case set_02_Bank_04_Sensor_02   = "06020E"
    case set_02_Bank_04_Sensor_03   = "06020F"
    case set_02_Bank_04_Sensor_04   = "060210"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_07_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs are for pending diagnostic codes.
 */
internal enum RVS_BTDriver_OBD_Command_Service_07_PIDs: String, CaseIterable {
    case nop = "06700"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_08_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs are for On-Board Component control.
 */
internal enum RVS_BTDriver_OBD_Command_Service_08_PIDs: String, CaseIterable {
    case nop = "0800"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_09_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are Vehicle information PIDs
 */
internal enum RVS_BTDriver_OBD_Command_Service_09_PIDs: String, CaseIterable {
    case returnSupportedPIDs                = "0900"
    case vinMessageCount                    = "0901"
    case vin                                = "0902"
    case calibrationIDCountAsMultipleOf4    = "0903"
    case calibrationIDs                     = "0904"
    case cvnCount                           = "0905"
    case cvns                               = "0906"
    case inUsePerformanceTrackingCount      = "0907"
    case inUsePerformanceTrackingSpark      = "0908"
    case ecuNameMessageCount                = "0909"
    case ecuName                            = "090A"
    case inUsePerformanceTrackingCompress   = "090B"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_0A_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are permanent disgnostic test PIDs
 */
internal enum RVS_BTDriver_OBD_Command_Service_0A_PIDs: String, CaseIterable {
    case nop = "0A00"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Services Enum -
/* ###################################################################################################################################### */
/**
 These are the "wrapper" enum cases for the various OBD PIds.
 */
internal enum RVS_BTDriver_OBD_Command_Services {
    /// Show current data
    case service_01_ShowCurrentDataService(pid: RVS_BTDriver_OBD_Command_Service_01_PIDs)
    /// Show Freeze Frame Data
    case service_02_ShowFreezeFrameDataService(pid: RVS_BTDriver_OBD_Command_Service_02_PIDs)
    /// Show Stored Trouble Codes
    case service_03_ShowStoredTroubleCodes(pid: RVS_BTDriver_OBD_Command_Service_03_PIDs)
    /// Clear Stored Codes and Values
    case service_04_ClearStoredValuesAndCodes(pid: RVS_BTDriver_OBD_Command_Service_04_PIDs)
    /// Get Test Results (and non-CAN Oxygen Sensor Results)
    case service_05_TestResultsOxygenNonCAN(pid: RVS_BTDriver_OBD_Command_Service_05_PIDs)
    /// Get Test Results (and CAN Oxygen Sensor Results)
    case service_06_TestResultsOxygenCAN(pid: RVS_BTDriver_OBD_Command_Service_06_PIDs)
    /// Show Pending Diagnostic Codes
    case service_07_ShowPendingDiagnosticCodes(pid: RVS_BTDriver_OBD_Command_Service_07_PIDs)
    /// Control On-Board Components
    case service_08_ControlOnBoardComponents(pid: RVS_BTDriver_OBD_Command_Service_08_PIDs)
    /// Get Vehicle Information
    case service_09_RequestVehicleInformation(pid: RVS_BTDriver_OBD_Command_Service_09_PIDs)
    /// Permanent Diagnostic Trouble Codes
    case service_0A_PermanentDTCs(pid: RVS_BTDriver_OBD_Command_Service_0A_PIDs)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMaskOptionSet Protocol -
/* ###################################################################################################################################### */
/**
 */
internal protocol RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMaskOptionSet: OptionSet {
    /* ################################################################## */
    /**
     This returns an Array of Strings, reflecting which PIDs will return data to be decoded by this mask set.
     */
    static var pidCommands: [String] { get }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0100 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask: RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMaskOptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt32
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue
    
    /* ################################################################## */
    /**
     This will be used for the first PID of Service 01 and 02.
     */
    static var pidCommands: [String] {
        return [RVS_BTDriver_OBD_Command_Service_01_PIDs.returnSupportedPIDs.rawValue,
                RVS_BTDriver_OBD_Command_Service_02_PIDs.returnSupportedPIDs.rawValue]
    }
    
    /// PID [01|02]01
    static let pid01 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x80000000)
    /// PID [01|02]02
    static let pid02 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x40000000)
    /// PID [01|02]03
    static let pid03 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x20000000)
    /// PID [01|02]04
    static let pid04 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x10000000)
    /// PID [01|02]05
    static let pid05 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x08000000)
    /// PID [01|02]06
    static let pid06 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x04000000)
    /// PID [01|02]07
    static let pid07 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x02000000)
    /// PID [01|02]08
    static let pid08 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x01000000)
    /// PID [01|02]09
    static let pid09 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00800000)
    /// PID [01|02]0A
    static let pid0A = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00400000)
    /// PID [01|02]0B
    static let pid0B = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00200000)
    /// PID [01|02]0C
    static let pid0C = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00100000)
    /// PID [01|02]0D
    static let pid0D = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00080000)
    /// PID [01|02]0E
    static let pid0E = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00040000)
    /// PID [01|02]0F
    static let pid0F = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00020000)
    /// PID [01|02]10
    static let pid10 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00010000)
    /// PID [01|02]11
    static let pid11 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00008000)
    /// PID [01|02]12
    static let pid12 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00004000)
    /// PID [01|02]13
    static let pid13 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00002000)
    /// PID [01|02]14
    static let pid14 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00001000)
    /// PID [01|02]15
    static let pid15 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000800)
    /// PID [01|02]16
    static let pid16 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000400)
    /// PID [01|02]17
    static let pid17 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000200)
    /// PID [01|02]18
    static let pid18 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000100)
    /// PID [01|02]19
    static let pid19 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000080)
    /// PID [01|02]1A
    static let pid1A = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000040)
    /// PID [01|02]1B
    static let pid1B = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000020)
    /// PID [01|02]1C
    static let pid1C = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000010)
    /// PID [01|02]1D
    static let pid1D = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000008)
    /// PID [01|02]1E
    static let pid1E = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000004)
    /// PID [01|02]1F
    static let pid1F = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000002)
    /// PID [01|02]20
    static let pid20 = RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask(rawValue: 0x00000001)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0101 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask: RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMaskOptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt32
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue
    
    /* ################################################################## */
    /**
     This will be used by the second PID of service 01.
     */
    static var pidCommands: [String] {
        return [RVS_BTDriver_OBD_Command_Service_01_PIDs.returnMonitorStatus.rawValue]
    }

    // MARK: ABCD A = 0xFF000000, B = 0x00FF0000, C = 0x0000FF00, D = 0x000000FF
    
    // MARK: A
    /// CE/MIL on
    static let mil = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                             0x80000000)
    /// Number of Emissions-related DTCs
    static let dtcCount = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        0x7F000000)
    
    // MARK: B
    /// Reserved
    static let reserved = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        0x00800000)
    /// This is on, if the motor is compression (diesel).
    static let diesel = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                          0x00080000)
    
    /// Components system test available
    static let componentsAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             0x00004000)
    /// Components system test still in progress
    static let componentsIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            0x00040000)
    /// Fuel system test available
    static let fuelSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             0x00002000)
    /// Fuel system test still in progress
    static let fuelSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            0x00020000)
    /// Misfire test available
    static let misfireAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                0x00001000)
    /// Misfire test still in progress
    static let misfireIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               0x00010000)
    /// EGR System test available
    static let egrSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              0x00008000)
    /// EGR System test still in progress
    static let egrSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             0x00000080)
    /// Catalyst test available
    static let catalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               0x00000100)
    /// Catalyst test still in progress
    static let catalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              0x00000001)

    // MARK: C-D (Spark) Only valid if .diesel is off
    /// Oxygen sensor heater test available
    static let oxygenSensorHeaterAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     0x00004000)
    /// Oxygen sensor heater test still in progress
    static let oxygenSensorHeaterIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    0x00000040)
    /// Oxygen sensor test available
    static let oxygenSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:           0x00002000)
    /// Oxygen sensor test still in progress
    static let oxygenSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          0x00000020)
    /// A/C refrigerant test available
    static let acRefrigerantAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          0x00001000)
    /// A/C refrigerant test still in progress
    static let acRefrigerantIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         0x00000010)
    /// Secondary air system test available
    static let sasAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                    0x00000800)
    /// Secondary air system test still in progress
    static let sasIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                   0x00000008)
    /// Evaporative system test available
    static let evaporativeSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:      0x00000400)
    /// Evaporative system test still in progress
    static let evaporativeSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     0x00000004)
    /// Heated catalyst test available
    static let heatedCatalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         0x00000200)
    /// Heated catalyst test still in progress
    static let heatedCatalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:        0x00000002)
    
    // MARK: C-D (Diesel) Only valid if .diesel is on
    /// PM filter monitoring test available
    static let pmFilterMonitoringAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     0x00004000)
    /// PM filter monitoring test still in progress
    static let pmFilterMonitoringIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    0x00000040)
    /// Exhaust gas test available
    static let exhaustSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          0x00002000)
    /// Exhaust gas test still in progress
    static let exhaustSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         0x00000020)
    /// Reserved
    static let reserved01Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             0x00001000)
    /// Reserved
    static let reserved01Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            0x00000010)
    /// Boost pressure test available
    static let boostPressureAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          0x00000800)
    /// Boost pressure test still in progress
    static let boostPressureIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         0x00000008)
    /// Reserved
    static let reserved02Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             0x00000400)
    /// Reserved
    static let reserved02Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            0x00000004)
    /// NOx/SCR Monitor test available
    static let noxSCRAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                 0x00000200)
    /// NOx/SCR Monitor test still in progress
    static let noxSCRIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                0x00000002)
}
