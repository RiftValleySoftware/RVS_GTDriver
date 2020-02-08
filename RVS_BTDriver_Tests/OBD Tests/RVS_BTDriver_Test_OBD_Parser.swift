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
// MARK: - The tests for the Parser -
/* ###################################################################################################################################### */
class RVS_BTDriver_Test_OBD_Parser: XCTestCase {
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
    func testBasicInit0100() {
        let rawResponseDataString1 = "0100\nSEARCHING...\n41 00 FF FF FF FF\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0100", completeCommand: "0100", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            for pid in 1..<33 {
                let pidString = String(format: "01%02X", pid)
                XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
            }
        }
        
        let rawResponseDataString2 = "0100\nSEARCHING...\n41 00 AA AA AA AA\n\n>"
        let rawResponseData2 = rawResponseDataString2.data(using: .utf8)
        let transaction2 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0100", completeCommand: "0100", responseData: rawResponseData2, responseDataAsString: rawResponseDataString2)
        let parser2 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction2)
        if let interpreter = parser2.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            for pid in 1..<33 {
                let pidString = String(format: "01%02X", pid)
                if 0 == pid % 2 {
                    XCTAssertFalse(interpreter.supportedPIDs.contains(pidString))
                } else {
                    XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
                }
            }
        }
        
        let rawResponseDataString3 = "0100\nSEARCHING...\n41 00 55 55 55 55\n\n>"
        let rawResponseData3 = rawResponseDataString3.data(using: .utf8)
        let transaction3 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0100", completeCommand: "0100", responseData: rawResponseData3, responseDataAsString: rawResponseDataString3)
        let parser3 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction3)
        if let interpreter = parser3.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            for pid in 1..<33 {
                let pidString = String(format: "01%02X", pid)
                if 0 == pid % 2 {
                    XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
                } else {
                    XCTAssertFalse(interpreter.supportedPIDs.contains(pidString))
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0200() {
        let rawResponseDataString1 = "0200\nSEARCHING...\n42 00 FF FF FF FF\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0200", completeCommand: "0200", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            for pid in 1..<33 {
                let pidString = String(format: "02%02X", pid)
                XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
            }
        }
        
        let rawResponseDataString2 = "0200\nSEARCHING...\n42 00 AA AA AA AA\n\n>"
        let rawResponseData2 = rawResponseDataString2.data(using: .utf8)
        let transaction2 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0200", completeCommand: "0200", responseData: rawResponseData2, responseDataAsString: rawResponseDataString2)
        let parser2 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction2)
        if let interpreter = parser2.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            let supportedPIDs = interpreter.supportedPIDs
            print(supportedPIDs)
            for pid in 1..<33 {
                let pidString = String(format: "02%02X", pid)
                if 0 == pid % 2 {
                    XCTAssertFalse(interpreter.supportedPIDs.contains(pidString))
                } else {
                    XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
                }
            }
        }
        
        let rawResponseDataString3 = "0200\nSEARCHING...\n42 00 55 55 55 55\n\n>"
        let rawResponseData3 = rawResponseDataString3.data(using: .utf8)
        let transaction3 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0200", completeCommand: "0200", responseData: rawResponseData3, responseDataAsString: rawResponseDataString3)
        let parser3 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction3)
        if let interpreter = parser3.interpreter as? RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter {
            for pid in 1..<33 {
                let pidString = String(format: "02%02X", pid)
                if 0 == pid % 2 {
                    XCTAssertTrue(interpreter.supportedPIDs.contains(pidString))
                } else {
                    XCTAssertFalse(interpreter.supportedPIDs.contains(pidString))
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0300() {
        // The first String is the actual data that mocks that returned by the device. The second String represents the expected output afte parsing. We treat the instance like an Array of String.
        let testingStrings: [(String, [String])] = [
            ("0300\nSEARCHING...\n43 01 01 08\n\n>", ["P0108"]),
            ("0300\n43 02 01 08 02 32", ["P0108", "P0232"]),
            ("0300\n008\n0: 43 03 01 08 02 32\n1: 0C 87 00 00 00 00 00\n\n>", ["P0108", "P0232", "P0C87"]),
            ("0300\n00C\n0: 43 05 01 08 02 32\n1: 0C 87 00 01 0A 01 00\n\n>", ["P0001", "P0108", "P0232", "P0A01", "P0C87"]),
            ("0300\nSEARCHING...\n00E\n0: 43 06 01 08 02 32\n1: 0C 87 00 01 0A 01 0B\n2: 00 00 00 00 00 00 00\n\n>", ["P0001", "P0108", "P0232", "P0A01", "P0B00", "P0C87"]),
            ("0300\n43 01 0C 5A", ["P0C5A"]),
            ("0300\n43 02 0C 5A 05 37\n\n>", ["P0537", "P0C5A"]),
            ("0300\n4GHI3020JKLC5AMNOPQRS0537TUVWXYZ", ["P0537", "P0C5A"]),
            ("0300\n008\n0: 43 03 0C 5A 05 37\n1: 04 94 00 00 00 00 00", ["P0494", "P0537", "P0C5A"]),
            ("0300\n00A\n0: 43 04 0C 5A 05 37\n1: 04 94 00 9E 00 00 00", ["P009E", "P0494", "P0537", "P0C5A"]),
            ("0300\nSEARCHING...\n00C\n0: 43 05 0C 5A 05 37\n1: 04 94 00 9E 00 10 00\n\n>", ["P0010", "P009E", "P0494", "P0537", "P0C5A"]),
            ("0300\n00E\n0: 43 06 0C 5A 05 37\n1: 04 94 00 9E 00 10 00\n2: 11 00 00 00 00 00 00", ["P0010", "P0011", "P009E", "P0494", "P0537", "P0C5A"]),
            ("0300\n018\n0: 43 06 0C 5A 05 37\n1: 04 94 00 9E 00 10 00\n2: 11 01 08 02 32 0C 87\n3: 00 01 0A 01 00 00 00", ["P0001", "P0010", "P0011", "P009E", "P0108", "P0232", "P0494", "P0537", "P0A01", "P0C5A", "P0C87"]),
            ("0300\n01C\n0: 43 06 4C 5A 05 37\n1: 04 94 40 9E 00 10 00\n2387651: 11 01 08 02 32 0C 87\n3465: C0 01 CA 01 FF 01 3F\n4: 01 FF FF FF FF FF FF", ["P0010", "P0011", "P0108", "P0232", "P0494", "P0537", "P0C87", "P3F01", "C009E", "C0C5A", "U0001", "U0A01", "U3F01"]),
            ("0300\nSEARCHING...\n024\n0: 43 06 4C 5A 05 37\n1: 04 94 40 9E 00 10 00-OOHTHISLOOKSTOUGH\n2387651: 11 01 08 02 32 0C 87\n3465: C0 01 CA 01 FF 01 3F\n4: 01 0C 5A FF FF 04 94\nSUPERCALIFRAGILISTICEXPIALIDOTIOUS:00 10 FF FF FF FF FF:\nIMALITTLETEAPOT-BLOODYANDCUT/THIS-IS-MY-HANDLE/THIS:IS-MY-BUTT\n\n>", ["P0010", "P0011", "P0108", "P0232", "P0494", "P0537", "P0C5A", "P0C87", "P3F01", "C009E", "C0C5A", "U0001", "U0A01", "U3F01", "U3FFF"])
        ]
        
        for testSet in testingStrings {
            let rawResponseDataString1 = testSet.0
            let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
            let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0300", completeCommand: "0300", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
            let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
            if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_03 {
                let comp = testSet.1
                XCTAssertEqual(interpreter.codes.count, interpreter.count)
                XCTAssertEqual(comp.count, interpreter.count)
                for index in 0..<comp.count {
                    let compVal = comp[index]
                    let code = index < interpreter.count ? interpreter[index] : ""
                    XCTAssertEqual(compVal, code)
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_AllSparkOn() {
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
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.testsComplete
            XCTAssertTrue(interpreter.isSpark)
            XCTAssertEqual(11, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
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
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_AllSparkInProgress() {
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
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.testsInProgress
            XCTAssertTrue(interpreter.isSpark)
            XCTAssertEqual(11, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
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
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_AllDieselOn() {
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
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.testsComplete
            XCTAssertTrue(interpreter.isDiesel)
            XCTAssertEqual(9, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
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
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_AllDieselInProgress() {
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
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.testsInProgress
            XCTAssertTrue(interpreter.isDiesel)
            XCTAssertEqual(9, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
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
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_MixedSpark() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsIncomplete,
            .fuelSystemAvailable,
            .misfireIncomplete,
            .egrSystemAvailable,
            .catalystIncomplete,
            .oxygenSensorHeaterAvailable,
            .oxygenSensorIncomplete,
            .acRefrigerantAvailable,
            .heatedCatalystIncomplete
        ])
        
        // We will have 11 available tests, diesel will be off, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x0B000000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.allTests
            XCTAssertTrue(interpreter.isSpark)
            XCTAssertEqual(11, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
            for test in supportedTests {
                switch test {
                case .components(let status),
                     .misfire(let status),
                     .catalyst(let status),
                     .oxygenSensor(let status),
                     .heatedCatalyst(let status):
                    XCTAssertEqual(.inProgress, status, "Illegal Test State: \(String(describing: test))")

                case .fuelSystem(let status),
                     .egr(let status),
                     .oxygenSensorHeater(let status),
                     .acRefrigerant(let status):
                    XCTAssertEqual(.complete, status, "Illegal Test State: \(String(describing: test))")
                    
                case .sas(let status),
                     .evaporativeSystem(let status):
                    XCTAssertEqual(.unknown, status, "Illegal Test State: \(String(describing: test))")

                default:
                    XCTFail("Illegal Test: \(String(describing: test))")
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_MixedDiesel() {
        let coveredDTCsMask = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask([
            .componentsAvailable,
            .fuelSystemIncomplete,
            .misfireAvailable,
            .egrSystemIncomplete,
            .catalystAvailable,
            .pmFilterMonitoringIncomplete,
            .noxSCRAvailable
        ])
        
        // We will have 9 available tests, diesel will be on, and the available tests are laid out in the OptionSet rawvalue.
        let value: UInt32 = 0x09000000 | 0x00080000 | coveredDTCsMask.rawValue
        let simulation = splitUpString(String(format: "%08x", value))
        let addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        let rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        let rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            let testCount  = interpreter.count
            let supportedTests = interpreter.allTests
            XCTAssertTrue(interpreter.isDiesel)
            XCTAssertEqual(9, testCount)
            XCTAssertEqual(supportedTests.count, testCount)
            XCTAssertEqual(supportedTests.count, interpreter.count)
            XCTAssertEqual(supportedTests.count, interpreter.testAvailability.count)
            for test in supportedTests {
                switch test {
                case .components(let status),
                     .misfire(let status),
                     .catalyst(let status),
                     .noxSCR(let status):
                    XCTAssertEqual(.complete, status, "Illegal Test State: \(String(describing: test))")
                    
                case .fuelSystem(let status),
                     .egr(let status),
                     .pmFilterMonitoring(let status):
                    XCTAssertEqual(.inProgress, status, "Illegal Test State: \(String(describing: test))")
                    
                case .exhaustSensor(let status),
                     .boostPressure(let status):
                    XCTAssertEqual(.unknown, status, "Illegal Test State: \(String(describing: test))")
                    
                default:
                    XCTFail("Illegal Test: \(String(describing: test))")
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    func testBasicInit0101_MIL_Diesel_Flags() {
        var value: UInt32 = 0x80080000
        var simulation = splitUpString(String(format: "%08x", value))
        var addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        var rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        var rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction1 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser1 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction1)
        if let interpreter1 = parser1.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            XCTAssertTrue(interpreter1.isMILOn)
            XCTAssertTrue(interpreter1.isDiesel)
        }
        
        value = 0x00080000
        simulation = splitUpString(String(format: "%08x", value))
        addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction2 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser2 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction2)
        if let interpreter2 = parser2.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            XCTAssertFalse(interpreter2.isMILOn)
            XCTAssertTrue(interpreter2.isDiesel)
        }
        
        value = 0x80000000
        simulation = splitUpString(String(format: "%08x", value))
        addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction3 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser3 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction3)
        if let interpreter3 = parser3.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            XCTAssertTrue(interpreter3.isMILOn)
            XCTAssertFalse(interpreter3.isDiesel)
        }
        
        value = 0x00000000
        simulation = splitUpString(String(format: "%08x", value))
        addSearching = 1 == Int.random(in: 0...1) ? "SEARCHING...\n" : ""
        rawResponseDataString1 = "0101\n\(addSearching)41 01 \(simulation)\n\n>"
        rawResponseData1 = rawResponseDataString1.data(using: .utf8)
        let transaction4 = RVS_BTDriver_OBD_Device_TransactionStruct(device: nil, rawCommand: "0101", completeCommand: "0101", responseData: rawResponseData1, responseDataAsString: rawResponseDataString1)
        let parser4 = RVS_BTDriver_Vendor_OBD_Parser(transaction: transaction4)
        if let interpreter4 = parser4.interpreter as? RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter {
            XCTAssertFalse(interpreter4.isMILOn)
            XCTAssertFalse(interpreter4.isDiesel)
        }
    }
}
