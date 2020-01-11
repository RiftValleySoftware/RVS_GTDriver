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
class RVS_BTDriver_Test_OBD_PIDs: XCTestCase {
    /* ################################################################## */
    /**
     This is a simple test of the "PIDs Supported" PID that is the 00 PID for service 01 and 02.
     */
    func testPID_0100_0200() {
        func checkInterpreter(_ inInterpreter: RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter) {
            let pidsSupported = inInterpreter.supportedPIDs
            
            var index = 1
            for pid in pidsSupported {
                let match = String(format: "%02X%02X", inInterpreter.service, index)
                index += 1
                XCTAssertEqual(match, pid)
            }
        }
        
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FF FF FF FF", service: 1))
        checkInterpreter(RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter(contents: "FF FF FF FF", service: 2))
    }
}
