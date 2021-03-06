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
// MARK: - Testing Standard OBD PID Interpreters -
/* ###################################################################################################################################### */
/**
 These tests will instantiate the interpreters, and will test them to make sure that they are properly interpreting the response strings.
 */
/* ###################################################################################################################################### */
// MARK: - The First Interpreter for Service 01 and 02 -
/* ###################################################################################################################################### */
class RVS_BTDriver_TestPID_0100_0200: XCTestCase {
    /* ################################################################## */
    /**
     This is a simple test of the "PIDs Supported" PID that is the 00 PID for service 01 and 02.
     This test will run the full gamut.
     */
    func test_Full() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            XCTAssertEqual(32, pidsSupported.count)

            var index = 1
            for pid in pidsSupported {
                let match = String(format: "%02X%02X", inInterpreter.service, index)
                index += 1
                XCTAssertEqual(match, pid)
            }
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FF FF FF FF", service: 2))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FFFFFFFF", service: 1))
    }
    
    /* ################################################################## */
    /**
     This test is like the above, but for every other PID.
     */
    func test_By2() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            XCTAssertEqual(16, pidsSupported.count)
            
            var index = 1
            for pid in pidsSupported {
                let match = String(format: "%02X%02X", inInterpreter.service, index)
                index += 2
                XCTAssertEqual(match, pid)
            }
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "AA AA AA AA", service: 1))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "AAAA AA AA", service: 2))
    }
    
    /* ################################################################## */
    /**
     This test is like the above, but for every other PID (In the other direction).
     */
    func test_By2_TheOtherWay() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            XCTAssertEqual(16, pidsSupported.count)

            var index = 2
            for pid in pidsSupported {
                let match = String(format: "%02X%02X", inInterpreter.service, index)
                index += 2
                XCTAssertEqual(match, pid)
            }
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "55555555", service: 1))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "5 5 55 55     5    5", service: 1))
    }
    
    /* ################################################################## */
    /**
     This test looks at just one PID (the first one).
     */
    func test_JustTheOne() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            XCTAssertEqual(1, pidsSupported.count)

            let match = String(format: "%02X%02X", inInterpreter.service, 1)
            XCTAssertEqual(match, pidsSupported[0])
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "8 00 0000 0", service: 2))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "80 00 00 00", service: 2))
    }
    
    /* ################################################################## */
    /**
     This test looks at just one PID (the last one).
     */
    func test_JustTheOtherOne() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            XCTAssertEqual(1, pidsSupported.count)

            let match = String(format: "%02X%02X", inInterpreter.service, 32)
            XCTAssertEqual(match, pidsSupported[0])
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "1", service: 1))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "00000001", service: 2))
    }
}

/* ###################################################################################################################################### */
// MARK: - The Second Interpreter for Service 01 and 02 -
/* ###################################################################################################################################### */
class RVS_BTDriver_TestPID_0101_0201: XCTestCase {
    // MARK: Test Utilities
    /* ################################################################## */
    /**
     */
    func splitUpString(_ inString: String) -> String {
        var ret: String = ""
        
        // This splits the string into pairs, like we get from the device.
        for index in stride(from: 0, to: inString.count, by: 4) {
            let startIndex1 = inString.index(inString.startIndex, offsetBy: index)
            let endIndex1 = inString.index(startIndex1, offsetBy: 2)
            let startIndex2 = endIndex1
            let endIndex2 = inString.index(startIndex2, offsetBy: 2)
            
            let subString1 = String(inString[startIndex1..<endIndex1])
            let subString2 = String(inString[startIndex2..<endIndex2])
            
            ret += String(format: "%@ %@ ", subString1, subString2)
        }
        
        return ret.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /* ################################################################## */
    /**
     */
    func evaluateTest(_ inMask: UInt32, state inStatus: RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter.TestStatus, count inCount: UInt32, expected inExpected: Int = 1, isDiesel inIsDiesel: Bool = false, service inService: Int = 1) {
        // We will have 11 available tests, diesel will be off, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = (inCount << 24) | (inIsDiesel ? 0x00080000 : 0)  | inMask
        let valueString = splitUpString(String(format: "%08x", value))
        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: valueString, service: inService)
        
        let allTests = testTarget.allTests
        
        XCTAssertEqual(inService, testTarget.service)
        XCTAssertEqual(Int(inCount), allTests.count)
        XCTAssertEqual(Int(inCount), testTarget.count)
        
        var tests: [RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter.TestCategories] = []

        switch inStatus {
        case .complete:
            tests = testTarget.testsComplete
        case .inProgress:
            tests = testTarget.testsInProgress
        case .unknown:
            tests = testTarget.testsUnknown
        }
        
        XCTAssertEqual(inExpected, tests.count)
    }
    
    // MARK: Spark Engine Tests
    /* ################################################################## */
    /**
     Tests to see if every spark test is on.
     */
    func test_AllSparkOn() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsAvailable,
            .fuelSystemAvailable,
            .misfireAvailable,
            .egrSystemAvailable,
            .catalystAvailable,
            .oxygenSensorHeaterAvailable,
            .oxygenSensorAvailable,
            .acRefrigerantAvailable,
            .sasAvailable,
            .evaporativeSystemAvailable,
            .heatedCatalystAvailable
        ])
        
        // We will have 11 available tests, diesel will be off, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x0B000000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))
        
        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 01)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsComplete
        XCTAssertTrue(testTarget.isSpark)
        XCTAssertEqual(11, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .oxygenSensorHeater(let status),
                 .oxygenSensor(let status),
                 .acRefrigerant(let status),
                 .sas(let status),
                 .evaporativeSystem(let status),
                 .heatedCatalyst(let status):
                XCTAssertEqual(.complete, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
    
    /* ################################################################## */
    /**
     Tests to see if every spark test is in progress.
     */
    func test_AllSparkInProgress() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsIncomplete,
            .fuelSystemIncomplete,
            .misfireIncomplete,
            .egrSystemIncomplete,
            .catalystIncomplete,
            .oxygenSensorHeaterIncomplete,
            .oxygenSensorIncomplete,
            .acRefrigerantIncomplete,
            .sasIncomplete,
            .evaporativeSystemIncomplete,
            .heatedCatalystIncomplete
        ])
        
        // We will have 11 available tests, diesel will be off, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x0B000000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))

        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 02)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsInProgress
        XCTAssertTrue(testTarget.isSpark)
        XCTAssertEqual(11, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .oxygenSensorHeater(let status),
                 .oxygenSensor(let status),
                 .acRefrigerant(let status),
                 .sas(let status),
                 .evaporativeSystem(let status),
                 .heatedCatalyst(let status):
                XCTAssertEqual(.inProgress, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
    
    /* ################################################################## */
    /**
     Tests to see if every spark test is unknown.
     */
    func test_AllSparkUnkown() {
        // We will have 11 available tests, diesel will be off.
        let value: UInt32 = 0x0B000000
        let simulation = splitUpString(String(format: "%08x", value))

        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 01)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsUnknown
        XCTAssertTrue(testTarget.isSpark)
        XCTAssertEqual(11, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .oxygenSensorHeater(let status),
                 .oxygenSensor(let status),
                 .acRefrigerant(let status),
                 .sas(let status),
                 .evaporativeSystem(let status),
                 .heatedCatalyst(let status):
                XCTAssertEqual(.unknown, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func test_EachSparkIndividually() {
        let availableDTCsMask = [UInt32]([
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.componentsAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.fuelSystemAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.misfireAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.egrSystemAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.catalystAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.oxygenSensorHeaterAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.oxygenSensorAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.acRefrigerantAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.sasAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.evaporativeSystemAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.heatedCatalystAvailable.rawValue
        ])
        
        let inProgressDTCsMask = [UInt32]([
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.componentsIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.fuelSystemIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.misfireIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.egrSystemIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.catalystIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.oxygenSensorHeaterIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.oxygenSensorIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.acRefrigerantIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.sasIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.evaporativeSystemIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.heatedCatalystIncomplete.rawValue
        ])
        
        for mask in availableDTCsMask {
            evaluateTest(mask, state: .complete, count: UInt32(availableDTCsMask.count))
        }
        
        for mask in inProgressDTCsMask {
            evaluateTest(mask, state: .inProgress, count: UInt32(inProgressDTCsMask.count), service: 2)
        }
        
        for _ in inProgressDTCsMask {
            evaluateTest(0, state: .unknown, count: UInt32(inProgressDTCsMask.count), expected: 11)
        }
    }

    // MARK: Diesel Engine Tests
    /* ################################################################## */
    /**
     Tests to see if every diesel test is on.
     */
    func test_AllDieselOn() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsAvailable,
            .fuelSystemAvailable,
            .misfireAvailable,
            .egrSystemAvailable,
            .catalystAvailable,
            .pmFilterMonitoringAvailable,
            .exhaustSensorAvailable,
            .boostPressureAvailable,
            .noxSCRAvailable
        ])
        
        // We will have 9 available tests, diesel will be on, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x09000000 | 0x00080000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))

        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 01)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsComplete
        XCTAssertTrue(testTarget.isDiesel)
        XCTAssertEqual(9, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .pmFilterMonitoring(let status),
                 .exhaustSensor(let status),
                 .boostPressure(let status),
                 .noxSCR(let status):
                XCTAssertEqual(.complete, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }

    /* ################################################################## */
    /**
     Tests to see if every diesel test is in progress.
     */
    func test_AllDieselInProgress() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsIncomplete,
            .fuelSystemIncomplete,
            .misfireIncomplete,
            .egrSystemIncomplete,
            .catalystIncomplete,
            .pmFilterMonitoringIncomplete,
            .exhaustSensorIncomplete,
            .boostPressureIncomplete,
            .noxSCRIncomplete
        ])
        
        // We will have 9 available tests, diesel will be on, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x09000000 | 0x00080000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))

        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 02)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsInProgress
        XCTAssertTrue(testTarget.isDiesel)
        XCTAssertEqual(9, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .pmFilterMonitoring(let status),
                 .exhaustSensor(let status),
                 .boostPressure(let status),
                 .noxSCR(let status):
                XCTAssertEqual(.inProgress, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
    
    /* ################################################################## */
    /**
     Tests to see if every diesel test is unknown.
     */
    func test_AllDieselUnknown() {
        // We will have 9 available tests, diesel will be on.
        let value: UInt32 = 0x09000000 | 0x00080000
        let simulation = splitUpString(String(format: "%08x", value))

        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 01)
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsUnknown
        XCTAssertTrue(testTarget.isDiesel)
        XCTAssertEqual(9, testCount)
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(supportedTests.count, testTarget.count)
        XCTAssertEqual(supportedTests.count, testTarget.testAvailability.count)
        for test in supportedTests {
            switch test {
            case .components(let status),
                 .fuelSystem(let status),
                 .misfire(let status),
                 .egr(let status),
                 .catalyst(let status),
                 .pmFilterMonitoring(let status),
                 .exhaustSensor(let status),
                 .boostPressure(let status),
                 .noxSCR(let status):
                XCTAssertEqual(.unknown, status, "Illegal Test State: \(String(describing: test))")
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func test_EachDieselIndividually() {
        let availableDTCsMask = [UInt32]([
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.componentsAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.fuelSystemAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.misfireAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.egrSystemAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.catalystAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.pmFilterMonitoringAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.exhaustSensorAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.boostPressureAvailable.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.noxSCRAvailable.rawValue
        ])
        
        let inProgressDTCsMask = [UInt32]([
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.componentsIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.fuelSystemIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.misfireIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.egrSystemIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.catalystIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.pmFilterMonitoringIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.exhaustSensorIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.boostPressureIncomplete.rawValue,
            RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask.noxSCRIncomplete.rawValue
        ])
        
        for mask in availableDTCsMask {
            evaluateTest(mask, state: .complete, count: UInt32(availableDTCsMask.count), isDiesel: true)
        }
        
        for mask in inProgressDTCsMask {
            evaluateTest(mask, state: .inProgress, count: UInt32(inProgressDTCsMask.count), isDiesel: true, service: 2)
        }
        
        for _ in inProgressDTCsMask {
            evaluateTest(0, state: .unknown, count: UInt32(inProgressDTCsMask.count), expected: 9, isDiesel: true)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Testing Special OBD PID Interpreters -
/* ###################################################################################################################################### */
/**
 */
/* ###################################################################################################################################### */
// MARK: - The First Interpreter for Service 01 and 02 Exhaust Gast Temperature Sensors -
/* ###################################################################################################################################### */
class RVS_BTDriver_TestPID_0178_0179: XCTestCase {
    let testFlagMax: UInt16 = 0xFFFF
    let testFlagMin: UInt16 = 0x0000
    let tesFlagMinus14: UInt16 = 0x00FF
    let testFlagZero: UInt16 = 0x0190

    /* ################################################################## */
    /**
     */
    func populateSensors(values inValues: [UInt16?]) -> String {
        precondition(4 == inValues.count)
        var ret = ""
        var val = 0
        
        for sensorData in inValues.enumerated() where nil != sensorData.element {
            val |= 1 << sensorData.offset
        }
        
        ret = String(format: "%02X", val)
        
        for offset in stride(from: 3, to: -1, by: -1) {
            if let val = inValues[offset] {
                ret += String(format: " %04X", val)
            } else {
                ret += " 0000"
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     */
    func testAllSensors() {
        for service in [1, 2] {
            var command = "0F 00 00 00 00 00 00 00 00"
            var testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
            XCTAssertTrue(testTarget.isSensor01DataAvailable)
            XCTAssertTrue(testTarget.isSensor02DataAvailable)
            XCTAssertTrue(testTarget.isSensor03DataAvailable)
            XCTAssertTrue(testTarget.isSensor04DataAvailable)
            
            XCTAssertEqual(-40.0, testTarget.sensor01TemperatureInDegreesCelsius)
            XCTAssertEqual(-40.0, testTarget.sensor02TemperatureInDegreesCelsius)
            XCTAssertEqual(-40.0, testTarget.sensor03TemperatureInDegreesCelsius)
            XCTAssertEqual(-40.0, testTarget.sensor04TemperatureInDegreesCelsius)
            
            command = "0F FFFF FFFF FFFF FFFF"
            testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
            XCTAssertTrue(testTarget.isSensor01DataAvailable)
            XCTAssertTrue(testTarget.isSensor02DataAvailable)
            XCTAssertTrue(testTarget.isSensor03DataAvailable)
            XCTAssertTrue(testTarget.isSensor04DataAvailable)
            
            XCTAssertEqual(6513.5, testTarget.sensor01TemperatureInDegreesCelsius)
            XCTAssertEqual(6513.5, testTarget.sensor02TemperatureInDegreesCelsius)
            XCTAssertEqual(6513.5, testTarget.sensor03TemperatureInDegreesCelsius)
            XCTAssertEqual(6513.5, testTarget.sensor04TemperatureInDegreesCelsius)
            
            command = "0F00FF00FF00FF00FF"
            testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
            XCTAssertTrue(testTarget.isSensor01DataAvailable)
            XCTAssertTrue(testTarget.isSensor02DataAvailable)
            XCTAssertTrue(testTarget.isSensor03DataAvailable)
            XCTAssertTrue(testTarget.isSensor04DataAvailable)
            
            XCTAssertEqual(-14.5, testTarget.sensor01TemperatureInDegreesCelsius)
            XCTAssertEqual(-14.5, testTarget.sensor02TemperatureInDegreesCelsius)
            XCTAssertEqual(-14.5, testTarget.sensor03TemperatureInDegreesCelsius)
            XCTAssertEqual(-14.5, testTarget.sensor04TemperatureInDegreesCelsius)
            
            command = "0F 0190 01 90 01 90 0190"
            testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
            XCTAssertTrue(testTarget.isSensor01DataAvailable)
            XCTAssertTrue(testTarget.isSensor02DataAvailable)
            XCTAssertTrue(testTarget.isSensor03DataAvailable)
            XCTAssertTrue(testTarget.isSensor04DataAvailable)
            
            XCTAssertEqual(0, testTarget.sensor01TemperatureInDegreesCelsius)
            XCTAssertEqual(0, testTarget.sensor02TemperatureInDegreesCelsius)
            XCTAssertEqual(0, testTarget.sensor03TemperatureInDegreesCelsius)
            XCTAssertEqual(0, testTarget.sensor04TemperatureInDegreesCelsius)

            let allSensors = [testFlagMin, tesFlagMinus14, testFlagZero, testFlagMax]
            command = populateSensors(values: allSensors)
            testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
            XCTAssertEqual(-40.0, testTarget.sensor01TemperatureInDegreesCelsius)
            XCTAssertEqual(-14.5, testTarget.sensor02TemperatureInDegreesCelsius)
            XCTAssertEqual(0, testTarget.sensor03TemperatureInDegreesCelsius)
            XCTAssertEqual(6513.5, testTarget.sensor04TemperatureInDegreesCelsius)
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testEachSensorIndependently() {
        for service in [1, 2] {
            let allValues = [testFlagMin, tesFlagMinus14, testFlagZero, testFlagMax]
            for value in allValues.enumerated() {
                var sensorLoad: [UInt16?] = [nil, nil, nil, nil]
                sensorLoad[value.offset] = value.element
                let command = populateSensors(values: sensorLoad)
                let testTarget = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature(contents: command, service: service)
                
                switch value.offset {
                case 0:
                    XCTAssertTrue(testTarget.isSensor01DataAvailable)
                    XCTAssertFalse(testTarget.isSensor02DataAvailable)
                    XCTAssertFalse(testTarget.isSensor03DataAvailable)
                    XCTAssertFalse(testTarget.isSensor04DataAvailable)
                    XCTAssertEqual(-40.0, testTarget.sensor01TemperatureInDegreesCelsius)
                case 1:
                    XCTAssertFalse(testTarget.isSensor01DataAvailable)
                    XCTAssertTrue(testTarget.isSensor02DataAvailable)
                    XCTAssertFalse(testTarget.isSensor03DataAvailable)
                    XCTAssertFalse(testTarget.isSensor04DataAvailable)
                    XCTAssertEqual(-14.5, testTarget.sensor02TemperatureInDegreesCelsius)
                case 2:
                    XCTAssertFalse(testTarget.isSensor01DataAvailable)
                    XCTAssertFalse(testTarget.isSensor02DataAvailable)
                    XCTAssertTrue(testTarget.isSensor03DataAvailable)
                    XCTAssertFalse(testTarget.isSensor04DataAvailable)
                    XCTAssertEqual(0, testTarget.sensor03TemperatureInDegreesCelsius)
                case 3:
                    XCTAssertFalse(testTarget.isSensor01DataAvailable)
                    XCTAssertFalse(testTarget.isSensor02DataAvailable)
                    XCTAssertFalse(testTarget.isSensor03DataAvailable)
                    XCTAssertTrue(testTarget.isSensor04DataAvailable)
                    XCTAssertEqual(6513.5, testTarget.sensor04TemperatureInDegreesCelsius)
                default:
                    XCTFail("Index Out of Range")
                }
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - The tests for the DTC response -
/* ###################################################################################################################################### */
class RVS_BTDriver_TestPID_0300: XCTestCase {
    /* ################################################################## */
    /**
     */
    func testBasicDTCEncoder() {
        // The first String is the actual data that mocks that returned by the device. The second String represents the expected output afte parsing. We treat the instance like an Array of String.
        let testingStrings: [(String, [String])] = [
            ("43 01 01 08", ["P0108"]),
            ("43 02 01 08 02 32", ["P0108", "P0232"]),
            ("008\n0: 43 03 01 08 02 32\n1: 0C 87 00 00 00 00 00", ["P0108", "P0232", "P0C87"]),
            ("00C\n0: 43 05 01 08 02 32\n1: 0C 87 00 01 0A 01 00", ["P0001", "P0108", "P0232", "P0A01", "P0C87"]),
            ("00E\n0: 43 06 01 08 02 32\n1: 0C 87 00 01 0A 01 0B\n2: 00 00 00 00 00 00 00", ["P0001", "P0108", "P0232", "P0A01", "P0B00", "P0C87"]),
            ("43 01 0C 5A", ["P0C5A"]),
            ("43 02 0C 5A 05 37", ["P0537", "P0C5A"]),
            ("4GHI3020JKLC5AMNOPQRS0537TUVWXYZ", ["P0537", "P0C5A"]),
            ("008\n0: 43 03 0C 5A 05 37\n1: 04 94 00 00 00 00 00", ["P0494", "P0537", "P0C5A"]),
            ("00A\n0: 43 04 0C 5A 05 37\n1: 04 94 00 9E 00 00 00", ["P009E", "P0494", "P0537", "P0C5A"]),
            ("00C\n0: 43 05 0C 5A 05 37\n1: 04 94 00 9E 00 10 00", ["P0010", "P009E", "P0494", "P0537", "P0C5A"]),
            ("00E\n0: 43 06 0C 5A 05 37\n1: 04 94 00 9E 00 10 00\n2: 11 00 00 00 00 00 00", ["P0010", "P0011", "P009E", "P0494", "P0537", "P0C5A"]),
            ("018\n0: 43 06 0C 5A 05 37\n1: 04 94 00 9E 00 10 00\n2: 11 01 08 02 32 0C 87\n3: 00 01 0A 01 00 00 00", ["P0001", "P0010", "P0011", "P009E", "P0108", "P0232", "P0494", "P0537", "P0A01", "P0C5A", "P0C87"]),
            ("01C\n0: 43 06 4C 5A 05 37\n1: 04 94 40 9E 00 10 00\n2387651: 11 01 08 02 32 0C 87\n3465: C0 01 CA 01 FF 01 3F\n4: 01 FF FF FF FF FF FF", ["P0010", "P0011", "P0108", "P0232", "P0494", "P0537", "P0C87", "P3F01", "C009E", "C0C5A", "U0001", "U0A01", "U3F01"]),
            ("024\n0: 43 06 4C 5A 05 37\n1: 04 94 40 9E 00 10 00-OOHTHISLOOKSTOUGH\n2387651: 11 01 08 02 32 0C 87\n3465: C0 01 CA 01 FF 01 3F\n4: 01 0C 5A FF FF 04 94\nSUPERCALIFRAGILISTICEXPIALIDOTIOUS:00 10 FF FF FF FF FF:IMALITTLETEAPOT-BLOODYANDCUT\nTHIS-IS-MY-HANDLE\nTHIS:IS-MY-BUTT", ["P0010", "P0011", "P0108", "P0232", "P0494", "P0537", "P0C5A", "P0C87", "P3F01", "C009E", "C0C5A", "U0001", "U0A01", "U3F01", "U3FFF"])
        ]
        
        for testString in testingStrings {
            let testTarget = RVS_BTDriver_OBD_Command_Service_03(contents: testString.0, service: 3)
            
            var index = 0
            for returnedCode in testTarget {
                let expectedCode = testString.1[index]
                XCTAssertEqual(expectedCode, returnedCode)
                index += 1
            }
        }
    }
}
