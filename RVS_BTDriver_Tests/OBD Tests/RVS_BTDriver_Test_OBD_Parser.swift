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
}
