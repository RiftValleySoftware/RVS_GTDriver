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
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FF FF FF FF", service: 1))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FFFFFFFF", service: 2))
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
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "5 5 55 55     5    5", service: 2))
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
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "8 00 0000 0", service: 1))
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
        
        let value: UInt32 = 0x0B000000 | coveredDTCsMask.rawValue
        let valueString = String(format: "%08x", value)
        var simulation: String = ""
        for index in stride(from: 0, to: valueString.count, by: 4) {
            let startIndex1 = valueString.index(valueString.startIndex, offsetBy: index)
            let endIndex1 = valueString.index(startIndex1, offsetBy: 2)
            let startIndex2 = endIndex1
            let endIndex2 = valueString.index(startIndex2, offsetBy: 2)
            
            let subString1 = String(valueString[startIndex1..<endIndex1])
            let subString2 = String(valueString[startIndex2..<endIndex2])
            
            simulation += String(format: "%@ %@ ", subString1, subString2)
        }
        
        let testTarget = RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter(contents: simulation.trimmingCharacters(in: CharacterSet.whitespaces), service: 01)
        print(String(describing: testTarget))
        let testCount  = testTarget.count
        let supportedTests = testTarget.testsComplete
        XCTAssertEqual(supportedTests.count, testCount)
        XCTAssertEqual(11, testCount)
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
                XCTAssertEqual(.complete, status)
            default:
                XCTFail("Illegal Test: \(String(describing: test))")
            }
        }
    }
}
