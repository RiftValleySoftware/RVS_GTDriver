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
    case returnSupportedPIDs    = "0100"
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_02_PIDs Enum -
/* ###################################################################################################################################### */
/**
 This is the same as the first set of PIDs, except with freeze-frame data.
 */
internal enum RVS_BTDriver_OBD_Command_Service_02_PIDs: String, CaseIterable {
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
