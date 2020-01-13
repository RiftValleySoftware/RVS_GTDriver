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
    case returnSupportedPIDs            = "0100"
    /// This returns a set of flags, denoting the monitor status, since the DTCs were last cleared (see the `RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask` type to understand these).
    case returnMonitorStatus            = "0101"
    /// This returns a set of flags, for the monitor satus for this cycle drive.
    case returnMonitorStatusThisCycle   = "0141"
    /// This returns a set of values for Bank One of the exaust gas temperature (EGT).
    case egt_Bank_01                    = "0178"
    /// This returns a set of values for Bank Two of the exaust gas temperature (EGT).
    case egt_Bank_02                    = "0179"
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
    /// Return the stored diagnostic codes.
    case returnStoredCodes    = "0300"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_04_PIDs Enum -
/* ###################################################################################################################################### */
/**
 This is a "one-shot" PID to clear test results, and reset the "check engine" light.
 */
internal enum RVS_BTDriver_OBD_Command_Service_04_PIDs: String, CaseIterable {
    /// This service just has the one PID, where it clears all stored codes.
    case clearStoredCodes    = "0400"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_05_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are for test results that include non-CAN oxygen sensor test reults.
 */
internal enum RVS_BTDriver_OBD_Command_Service_05_PIDs: String, CaseIterable {
    /// Returns all the monotor IDs available.
    case returnMonitorIDs           = "050100"
    /// Set 01, Bank 01, Sensor 01.
    case set_01_Bank_01_Sensor_01   = "050101"
    /// Set 01, Bank 01, Sensor 02.
    case set_01_Bank_01_Sensor_02   = "050102"
    /// Set 01, Bank 01, Sensor 03.
    case set_01_Bank_01_Sensor_03   = "050103"
    /// Set 01, Bank 01, Sensor 04.
    case set_01_Bank_01_Sensor_04   = "050104"
    /// Set 01, Bank 02, Sensor 01.
    case set_01_Bank_02_Sensor_01   = "050105"
    /// Set 01, Bank 02, Sensor 02.
    case set_01_Bank_02_Sensor_02   = "050106"
    /// Set 01, Bank 02, Sensor 03.
    case set_01_Bank_02_Sensor_03   = "050107"
    /// Set 01, Bank 02, Sensor 04.
    case set_01_Bank_02_Sensor_04   = "050108"
    /// Set 01, Bank 03, Sensor 01.
    case set_01_Bank_03_Sensor_01   = "050109"
    /// Set 01, Bank 03, Sensor 02.
    case set_01_Bank_03_Sensor_02   = "05010A"
    /// Set 01, Bank 03, Sensor 03.
    case set_01_Bank_03_Sensor_03   = "05010B"
    /// Set 01, Bank 03, Sensor 04.
    case set_01_Bank_03_Sensor_04   = "05010C"
    /// Set 01, Bank 04, Sensor 01.
    case set_01_Bank_04_Sensor_01   = "05010D"
    /// Set 01, Bank 04, Sensor 02.
    case set_01_Bank_04_Sensor_02   = "05010E"
    /// Set 01, Bank 04, Sensor 03.
    case set_01_Bank_04_Sensor_03   = "05010F"
    /// Set 01, Bank 04, Sensor 04.
    case set_01_Bank_04_Sensor_04   = "050110"
    /// Set 02, Bank 01, Sensor 01.
    case set_02_Bank_01_Sensor_01   = "050201"
    /// Set 02, Bank 01, Sensor 02.
    case set_02_Bank_01_Sensor_02   = "050202"
    /// Set 02, Bank 01, Sensor 03.
    case set_02_Bank_01_Sensor_03   = "050203"
    /// Set 02, Bank 01, Sensor 04.
    case set_02_Bank_01_Sensor_04   = "050204"
    /// Set 02, Bank 02, Sensor 01.
    case set_02_Bank_02_Sensor_01   = "050205"
    /// Set 02, Bank 02, Sensor 02.
    case set_02_Bank_02_Sensor_02   = "050206"
    /// Set 02, Bank 02, Sensor 03.
    case set_02_Bank_02_Sensor_03   = "050207"
    /// Set 02, Bank 02, Sensor 04.
    case set_02_Bank_02_Sensor_04   = "050208"
    /// Set 02, Bank 03, Sensor 01.
    case set_02_Bank_03_Sensor_01   = "050209"
    /// Set 02, Bank 03, Sensor 02.
    case set_02_Bank_03_Sensor_02   = "05020A"
    /// Set 02, Bank 03, Sensor 03.
    case set_02_Bank_03_Sensor_03   = "05020B"
    /// Set 02, Bank 03, Sensor 04.
    case set_02_Bank_03_Sensor_04   = "05020C"
    /// Set 02, Bank 04, Sensor 01.
    case set_02_Bank_04_Sensor_01   = "05020D"
    /// Set 02, Bank 04, Sensor 02.
    case set_02_Bank_04_Sensor_02   = "05020E"
    /// Set 02, Bank 04, Sensor 03.
    case set_02_Bank_04_Sensor_03   = "05020F"
    /// Set 02, Bank 04, Sensor 04.
    case set_02_Bank_04_Sensor_04   = "050210"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_06_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are for test results that include CAN oxygen sensor tests.
 */
internal enum RVS_BTDriver_OBD_Command_Service_06_PIDs: String, CaseIterable {
    /// Returns all the monotor IDs available.
    case returnMonitorIDs           = "060100"
    /// Set 01, Bank 01, Sensor 01.
    case set_01_Bank_01_Sensor_01   = "060101"
    /// Set 01, Bank 01, Sensor 02.
    case set_01_Bank_01_Sensor_02   = "060102"
    /// Set 01, Bank 01, Sensor 03.
    case set_01_Bank_01_Sensor_03   = "060103"
    /// Set 01, Bank 01, Sensor 04.
    case set_01_Bank_01_Sensor_04   = "060104"
    /// Set 01, Bank 02, Sensor 01.
    case set_01_Bank_02_Sensor_01   = "060105"
    /// Set 01, Bank 02, Sensor 02.
    case set_01_Bank_02_Sensor_02   = "060106"
    /// Set 01, Bank 02, Sensor 03.
    case set_01_Bank_02_Sensor_03   = "060107"
    /// Set 01, Bank 02, Sensor 04.
    case set_01_Bank_02_Sensor_04   = "060108"
    /// Set 01, Bank 03, Sensor 01.
    case set_01_Bank_03_Sensor_01   = "060109"
    /// Set 01, Bank 03, Sensor 02.
    case set_01_Bank_03_Sensor_02   = "06010A"
    /// Set 01, Bank 03, Sensor 03.
    case set_01_Bank_03_Sensor_03   = "06010B"
    /// Set 01, Bank 03, Sensor 04.
    case set_01_Bank_03_Sensor_04   = "06010C"
    /// Set 01, Bank 04, Sensor 01.
    case set_01_Bank_04_Sensor_01   = "06010D"
    /// Set 01, Bank 04, Sensor 02.
    case set_01_Bank_04_Sensor_02   = "06010E"
    /// Set 01, Bank 04, Sensor 03.
    case set_01_Bank_04_Sensor_03   = "06010F"
    /// Set 01, Bank 04, Sensor 04.
    case set_01_Bank_04_Sensor_04   = "060110"
    /// Set 02, Bank 01, Sensor 01.
    case set_02_Bank_01_Sensor_01   = "060201"
    /// Set 02, Bank 01, Sensor 02.
    case set_02_Bank_01_Sensor_02   = "060202"
    /// Set 02, Bank 01, Sensor 03.
    case set_02_Bank_01_Sensor_03   = "060203"
    /// Set 02, Bank 01, Sensor 04.
    case set_02_Bank_01_Sensor_04   = "060204"
    /// Set 02, Bank 02, Sensor 01.
    case set_02_Bank_02_Sensor_01   = "060205"
    /// Set 02, Bank 02, Sensor 02.
    case set_02_Bank_02_Sensor_02   = "060206"
    /// Set 02, Bank 02, Sensor 03.
    case set_02_Bank_02_Sensor_03   = "060207"
    /// Set 02, Bank 02, Sensor 04.
    case set_02_Bank_02_Sensor_04   = "060208"
    /// Set 02, Bank 03, Sensor 01.
    case set_02_Bank_03_Sensor_01   = "060209"
    /// Set 02, Bank 03, Sensor 02.
    case set_02_Bank_03_Sensor_02   = "06020A"
    /// Set 02, Bank 03, Sensor 03.
    case set_02_Bank_03_Sensor_03   = "06020B"
    /// Set 02, Bank 03, Sensor 04.
    case set_02_Bank_03_Sensor_04   = "06020C"
    /// Set 02, Bank 04, Sensor 01.
    case set_02_Bank_04_Sensor_01   = "06020D"
    /// Set 02, Bank 04, Sensor 02.
    case set_02_Bank_04_Sensor_02   = "06020E"
    /// Set 02, Bank 04, Sensor 03.
    case set_02_Bank_04_Sensor_03   = "06020F"
    /// Set 02, Bank 04, Sensor 04.
    case set_02_Bank_04_Sensor_04   = "060210"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_07_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs are for pending diagnostic codes.
 */
internal enum RVS_BTDriver_OBD_Command_Service_07_PIDs: String, CaseIterable {
        /// Placeholder
    case nop = "06700"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_08_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These PIDs are for On-Board Component control.
 */
internal enum RVS_BTDriver_OBD_Command_Service_08_PIDs: String, CaseIterable {
        /// Placeholder
    case nop = "0800"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_09_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are Vehicle information PIDs
 */
internal enum RVS_BTDriver_OBD_Command_Service_09_PIDs: String, CaseIterable {
    /// Return which service 9 PIDs are supported.
    case returnSupportedPIDs                = "0900"
    /// Return the count of bytes in the VIN (usually 5).
    case vinMessageCount                    = "0901"
    /// return the VIN.
    case vin                                = "0902"
    /// Return the number of calibration messages (a multiple of 4).
    case calibrationIDCountAsMultipleOf4    = "0903"
    /// Return the calibration IDs.
    case calibrationIDs                     = "0904"
    /// Return the number of calibration verification numbers (CVN).
    case cvnCount                           = "0905"
    /// Return the CVNs.
    case cvns                               = "0906"
    /// Return the number of in-use performance tracking messages.
    case inUsePerformanceTrackingCount      = "0907"
    /// Return the in-performance tracking messages for non-diesel engines.
    case inUsePerformanceTrackingSpark      = "0908"
    /// Return the number of ECU name messages.
    case ecuNameMessageCount                = "0909"
    /// Return the ECU name messages.
    case ecuName                            = "090A"
        /// Return the in-performance tracking messages for diesel engines.
    case inUsePerformanceTrackingCompress   = "090B"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_0A_PIDs Enum -
/* ###################################################################################################################################### */
/**
 These are permanent disgnostic test PIDs
 */
internal enum RVS_BTDriver_OBD_Command_Service_0A_PIDs: String, CaseIterable {
    /// Placeholder
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
// MARK: - RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0101/0141 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask: OptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt32
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue

    // MARK: ABCD A = 0xFF000000, B = 0x00FF0000, C = 0x0000FF00, D = 0x000000FF
    
    // MARK: A
    /// CE/MIL on
    static let mil = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                             RawValue(0x80000000))
    /// Number of Emissions-related DTCs
    static let dtcCount = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        RawValue(0x7F000000))
    
    // MARK: B
    /// Reserved
    static let reserved = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        RawValue(0x00800000))
    /// This is on, if the motor is compression (diesel).
    static let diesel = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                          RawValue(0x00080000))
    
    /// Components system test available
    static let componentsAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00004000))
    /// Components system test still in progress
    static let componentsIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00040000))
    /// Fuel system test available
    static let fuelSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00002000))
    /// Fuel system test still in progress
    static let fuelSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00020000))
    /// Misfire test available
    static let misfireAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                RawValue(0x00001000))
    /// Misfire test still in progress
    static let misfireIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               RawValue(0x00010000))
    /// EGR System test available
    static let egrSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              RawValue(0x00008000))
    /// EGR System test still in progress
    static let egrSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00000080))
    /// Catalyst test available
    static let catalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               RawValue(0x00000100))
    /// Catalyst test still in progress
    static let catalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              RawValue(0x00000001))

    // MARK: C-D (Spark) Only valid if .diesel is off
    /// Oxygen sensor heater test available
    static let oxygenSensorHeaterAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00004000))
    /// Oxygen sensor heater test still in progress
    static let oxygenSensorHeaterIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    RawValue(0x00000040))
    /// Oxygen sensor test available
    static let oxygenSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:           RawValue(0x00002000))
    /// Oxygen sensor test still in progress
    static let oxygenSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00000020))
    /// A/C refrigerant test available
    static let acRefrigerantAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00001000))
    /// A/C refrigerant test still in progress
    static let acRefrigerantIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000010))
    /// Secondary air system test available
    static let sasAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                    RawValue(0x00000800))
    /// Secondary air system test still in progress
    static let sasIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                   RawValue(0x00000008))
    /// Evaporative system test available
    static let evaporativeSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:      RawValue(0x00000400))
    /// Evaporative system test still in progress
    static let evaporativeSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00000004))
    /// Heated catalyst test available
    static let heatedCatalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000200))
    /// Heated catalyst test still in progress
    static let heatedCatalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:        RawValue(0x00000002))
    
    // MARK: C-D (Diesel) Only valid if .diesel is on
    /// PM filter monitoring test available
    static let pmFilterMonitoringAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00004000))
    /// PM filter monitoring test still in progress
    static let pmFilterMonitoringIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    RawValue(0x00000040))
    /// Exhaust gas test available
    static let exhaustSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00002000))
    /// Exhaust gas test still in progress
    static let exhaustSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000020))
    /// Reserved
    static let reserved01Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00001000))
    /// Reserved
    static let reserved01Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00000010))
    /// Boost pressure test available
    static let boostPressureAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00000800))
    /// Boost pressure test still in progress
    static let boostPressureIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000008))
    /// Reserved
    static let reserved02Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00000400))
    /// Reserved
    static let reserved02Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00000004))
    /// NOx/SCR Monitor test available
    static let noxSCRAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                 RawValue(0x00000200))
    /// NOx/SCR Monitor test still in progress
    static let noxSCRIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                RawValue(0x00000002))

    // MARK: A
    /// CE/MIL on
    var isMILOn: Bool { return 0 != rawValue & Self.mil.rawValue }
    /// Number of Emissions-related DTCs
    var count: Int { return Int((Self.dtcCount.rawValue & rawValue) >> 24) }
    
    // MARK: B
    /// This is on, if the motor is compression (diesel).
    var isDiesel: Bool { return 0 != rawValue & Self.diesel.rawValue }
    
    /// Components system test available
    var componentsAvailable: Bool { return 0 != rawValue & Self.componentsAvailable.rawValue }
    /// Components system test still in progress
    var componentsIncomplete: Bool { return 0 != rawValue & Self.componentsIncomplete.rawValue }
    /// Fuel system test available
    var fuelSystemAvailable: Bool { return 0 != rawValue & Self.fuelSystemAvailable.rawValue }
    /// Fuel system test still in progress
    var fuelSystemIncomplete: Bool { return 0 != rawValue & Self.fuelSystemIncomplete.rawValue }
    /// Misfire test available
    var misfireAvailable: Bool { return 0 != rawValue & Self.misfireAvailable.rawValue }
    /// Misfire test still in progress
    var misfireIncomplete: Bool { return 0 != rawValue & Self.misfireIncomplete.rawValue }
    /// EGR System test available
    var egrSystemAvailable: Bool { return 0 != rawValue & Self.egrSystemAvailable.rawValue }
    /// EGR System test still in progress
    var egrSystemIncomplete: Bool { return 0 != rawValue & Self.egrSystemIncomplete.rawValue }
    /// Catalyst test available
    var catalystAvailable: Bool { return 0 != rawValue & Self.catalystAvailable.rawValue }
    /// Catalyst test still in progress
    var catalystIncomplete: Bool { return 0 != rawValue & Self.catalystIncomplete.rawValue }

    // MARK: C-D (Spark) Only valid if .isDiesel is off
    /// Oxygen sensor heater test available
    var oxygenSensorHeaterAvailable: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorHeaterAvailable.rawValue }
    /// Oxygen sensor heater test still in progress
    var oxygenSensorHeaterIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorHeaterIncomplete.rawValue }
    /// Oxygen sensor test available
    var oxygenSensorAvailable: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorAvailable.rawValue }
    /// Oxygen sensor test still in progress
    var oxygenSensorIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorIncomplete.rawValue }
    /// A/C refrigerant test available
    var acRefrigerantAvailable: Bool { return !isDiesel && 0 != rawValue & Self.acRefrigerantAvailable.rawValue }
    /// A/C refrigerant test still in progress
    var acRefrigerantIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.acRefrigerantIncomplete.rawValue }
    /// Secondary air system test available
    var sasAvailable: Bool { return !isDiesel && 0 != rawValue & Self.sasAvailable.rawValue }
    /// Secondary air system test still in progress
    var sasIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.sasIncomplete.rawValue }
    /// Evaporative system test available
    var evaporativeSystemAvailable: Bool { return !isDiesel && 0 != rawValue & Self.evaporativeSystemAvailable.rawValue }
    /// Evaporative system test still in progress
    var evaporativeSystemIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.evaporativeSystemIncomplete.rawValue }
    /// Heated catalyst test available
    var heatedCatalystAvailable: Bool { return !isDiesel && 0 != rawValue & Self.heatedCatalystAvailable.rawValue }
    /// Heated catalyst test still in progress
    var heatedCatalystIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.heatedCatalystIncomplete.rawValue }
    
    // MARK: C-D (Diesel) Only valid if .isDiesel is on
    /// PM filter monitoring test available
    var pmFilterMonitoringAvailable: Bool { return isDiesel && 0 != rawValue & Self.pmFilterMonitoringAvailable.rawValue }
    /// PM filter monitoring test still in progress
    var pmFilterMonitoringIncomplete: Bool { return isDiesel && 0 != rawValue & Self.pmFilterMonitoringIncomplete.rawValue }
    /// Exhaust gas test available
    var exhaustSensorAvailable: Bool { return isDiesel && 0 != rawValue & Self.exhaustSensorAvailable.rawValue }
    /// Exhaust gas test still in progress
    var exhaustSensorIncomplete: Bool { return isDiesel && 0 != rawValue & Self.exhaustSensorIncomplete.rawValue }
    /// Boost pressure test available
    var boostPressureAvailable: Bool { return isDiesel && 0 != rawValue & Self.boostPressureAvailable.rawValue }
    /// Boost pressure test still in progress
    var boostPressureIncomplete: Bool { return isDiesel && 0 != rawValue & Self.boostPressureIncomplete.rawValue }
    /// NOx/SCR Monitor test available
    var noxSCRAvailable: Bool { return isDiesel && 0 != rawValue & Self.noxSCRAvailable.rawValue }
    /// NOx/SCR Monitor test still in progress
    var noxSCRIncomplete: Bool { return isDiesel && 0 != rawValue & Self.noxSCRIncomplete.rawValue }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader OptionSet -
/* ###################################################################################################################################### */
/**
 This struct will act as a bitmask to decode the flag byte of the EGT.
 */
struct RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader: OptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt8
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue

    /// Reserved.
    static let reserved = RawValue(0xF0)
    /// Sensor 4 is supported.
    static let egtsensor04 = RawValue(0x08)
    /// Sensor 3 is supported.
    static let egtsensor03 = RawValue(0x04)
    /// Sensor 2 is supported.
    static let egtsensor02 = RawValue(0x02)
    /// Sensor 1 is supported.
    static let egtsensor01 = RawValue(0x01)
    
    /// - returns: True, if Sensor 4 has tests.
    var isSensor04Supported: Bool { return 0 != rawValue & Self.egtsensor04 }
    
    /// - returns: True, if Sensor 3 has tests.
    var isSensor03Supported: Bool { return 0 != rawValue & Self.egtsensor03 }
    
    /// - returns: True, if Sensor 2 has tests.
    var isSensor02Supported: Bool { return 0 != rawValue & Self.egtsensor02 }
    
    /// - returns: True, if Sensor 1 has tests.
    var isSensor01Supported: Bool { return 0 != rawValue & Self.egtsensor01 }
}
