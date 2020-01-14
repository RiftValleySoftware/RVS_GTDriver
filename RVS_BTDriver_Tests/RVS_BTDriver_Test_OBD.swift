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
// MARK: - Testing OBD Commands -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_Test_OBD: XCTestCase {
    /* ################################################################## */
    /**
     This is our OBD ELM327 device instance. We create a simple instance each time.
     */
    var obdInstance: RVS_BTDriver_Device_OBD!
    
    /* ################################################################## */
    /**
     This holds the last received command.
     */
    var lastReceivedCommand: String = ""
    
    /* ################################################################## */
    /**
     Simply receives the outgoing command, and stores it in our property.
     
     - parameter inCommandSendString: The command being sent.
     */
    func receiveCommandFromTarget(_ inCommandSendString: String) {
        let hexString = inCommandSendString.hexDump16
        print("Command Send String Received \"\(inCommandSendString)\" (\(hexString.joined(separator: " ").uppercased())).")
        lastReceivedCommand = inCommandSendString
    }
}

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
