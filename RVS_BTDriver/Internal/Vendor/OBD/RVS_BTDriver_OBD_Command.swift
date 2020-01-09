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
