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
 These are individual tests for the OBD ELM327 commands.
 */
class RVS_BTDriver_Test_OBD_ELM327: RVS_BTDriver_Test_OBD {
    /* ################################################################## */
    /**
     We create a simple OBD device, and clear the last command string.
     We also tell the OBD device to send commands our way, as opposed to a device.
     */
    override func setUp() {
        super.setUp()
        obdInstance = RVS_BTDriver_Device_OBD_ELM327(vendor: nil)
        obdInstance?.commandReceiveFunc = self.receiveCommandFromTarget
        lastReceivedCommand = ""
    }

    /* ################################################################################################################################## */
    // MARK: - General -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Return the device description
    */
	func test_getDeviceDescription() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.getDeviceDescription()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.getDeviceDescription.rawValue + "\r\n")
    }
    
    /* ################################################################## */
    /**
     Return the device ID
    */
	func test_getDeviceIdentifier() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.getDeviceIdentifier()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.getDeviceIdentifier.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the device ID
    */
	func test_setDeviceIdentifier() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setDeviceIdentifier("0")
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue, "0") + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setDeviceIdentifier("TEST")
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue, "TEST") + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setDeviceIdentifier("0123456789ABC")
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue, "0123456789ABC") + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setDeviceIdentifier("Ó≈√›Á¥ˆÆ»ŒÔÒ")
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setDeviceIdentifier.rawValue, "Ó≈√›Á¥ˆÆ»ŒÔÒ") + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Divisor
    */
	func test_setBaudRateDivisor() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateDivisor(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateDivisor(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateDivisor(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateDivisor(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateDivisor.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Baud Rate Rate Handshake Timeout
    */
	func test_setBaudRateHandshakeTimeout() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateHandshakeTimeout(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateHandshakeTimeout(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateHandshakeTimeout(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setBaudRateHandshakeTimeout(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setBaudRateHandshakeTimeout.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Restore the OBD Device to Defaults
    */
	func test_restoreToDefaults() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.restoreToDefaults()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.restoreToDefaults.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn echo on
    */
	func test_turnEchoOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnEchoOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnEchoOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Echo Off
    */
	func test_turnEchoOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnEchoOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnEchoOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Flush All Events
    */
	func test_flushAllEvents() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.flushAllEvents()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.flushAllEvents.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Return the unit ID
    */
	func test_getID() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.getID()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.getID.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn on Linefeeds
    */
	func test_turnLinefeedsOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnLinefeedsOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnLinefeedsOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Off Linefeeds
    */
	func test_turnLinefeedsOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnLinefeedsOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnLinefeedsOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn On Low Power Mode
    */
	func test_turnLowPowerModeOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnLowPowerModeOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnLowPowerModeOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn On Memory
    */
	func test_turnMemoryOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnMemoryOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnMemoryOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Off Memory
    */
	func test_turnMemoryOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnMemoryOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnMemoryOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Return Stored Data In Memory
    */
	func test_fetchStoredData() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.fetchStoredData()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.fetchStoredData.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Store 1 Byte of Data in Memory
    */
	func test_storeData() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.storeData(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.storeData.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.storeData(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.storeData.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.storeData(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.storeData.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.storeData(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.storeData.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Perform a "Warm Start"
    */
	func test_warmStart() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.warmStart()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.warmStart.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Reset All
    */
	func test_resetAll() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.resetAll()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.resetAll.rawValue + "\r\n")		
    }

    /* ################################################################################################################################## */
    // MARK: - OBD -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Use Long (>7 Byte) Messages
    */
	func test_useLongMessages() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useLongMessages()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useLongMessages.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Use Short (<= 7 Byte) Messages
    */
	func test_useShortMessages() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useShortMessages()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useShortMessages.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Enable Automatic Receive
    */
	func test_autoReceive() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.autoReceive()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.autoReceive.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
	func test_useAdaptiveTimingMode1() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useAdaptiveTimingMode1()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode1.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Enable Adaptive Timing Auto Mode 1
    */
	func test_useAdaptiveTimingMode2() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useAdaptiveTimingMode2()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useAdaptiveTimingMode2.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Adaptive Timing Off
    */
	func test_turnAdaptiveTimingOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnAdaptiveTimingOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnAdaptiveTimingOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Return a Buffer Dump
    */
	func test_bufferDump() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.bufferDump()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.bufferDump.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Bypass the Initialization Sequence
    */
	func test_bypassInitialization() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.bypassInitialization()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.bypassInitialization.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol
    */
	func test_describeCurrentProtocol() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.describeCurrentProtocol()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.describeCurrentProtocol.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Describe the Current Protocol as a Number
    */
	func test_describeProtocolByNumber() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.describeProtocolByNumber()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.describeProtocolByNumber.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Headers On
    */
	func test_turnHeadersOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnHeadersOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnHeadersOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Headers Off
    */
	func test_turnHeadersOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnHeadersOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnHeadersOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Monitor All
    */
	func test_monitorAll() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.monitorAll()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.monitorAll.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the Monitor for Receiver
    */
	func test_setMonitorForReceiver() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForReceiver(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForReceiver(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForReceiver(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForReceiver(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForReceiver.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Monitor for Transmitter
    */
	func test_setMonitorForTransmitter() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForTransmitter(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForTransmitter(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForTransmitter(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setMonitorForTransmitter(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setMonitorForTransmitter.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Protocol
    */
	func test_setProtocol() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol(3)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol.rawValue, 3) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol(7)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol.rawValue, 7) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set Protocol (Alternate Try)
    */
	func test_setProtocol2() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol2(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol2.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol2(3)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol2.rawValue, 3) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocol2(7)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocol2.rawValue, 7) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (1 hex Digit)
    */
	func test_setAutoProtocol() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol(3)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol.rawValue, 3) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol(7)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol.rawValue, 7) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set Auto Protocol (Alternate Try)
    */
	func test_setAutoProtocol2() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol2(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol2.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol2(3)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol2.rawValue, 3) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setAutoProtocol2(7)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setAutoProtocol2.rawValue, 7) + "\r\n")
    }

    /* ################################################################## */
    /**
     Use Auto Protocol
    */
	func test_useAutoProtocol() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useAutoProtocol()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useAutoProtocol.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Close the Protocol
    */
	func test_closeProtocol() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.closeProtocol()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.closeProtocol.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Responses On
    */
	func test_turnResponsesOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnResponsesOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnResponsesOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Responses Off
    */
	func test_turnResponsesOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnResponsesOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnResponsesOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the Receive Address
    */
	func test_setReceiveAddress() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Receive Address (Alternate Command)
    */
	func test_setReceiveAddress2() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress2(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress2(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress2(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setReceiveAddress2(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setReceiveAddress2.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Turn On Print Spaces
    */
	func test_turnPrintSpacesOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnPrintSpacesOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnPrintSpacesOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Off Print Spaces
    */
	func test_turnPrintSpacesOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnPrintSpacesOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnPrintSpacesOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set Header (prefix and value)
    */
	func test_setHeader() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(0, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 0, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(0, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 0, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(0, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 0, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(0, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 0, 255) + "\r\n")
        
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(3, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 3, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(3, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 3, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(3, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 3, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(3, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 3, 255) + "\r\n")
        
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(7, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 7, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(7, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 7, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(7, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 7, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(7, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader1.rawValue, 7, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set Header (3 values)
    */
	func test_setHeader2() {
        let strider = stride(from: 0, to: 255, by: 64)
        
        for value1 in strider {
            for value2 in strider {
                for value3 in strider {
                    (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setHeader(UInt8(value1), UInt8(value2), UInt8(value3))
                    XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setHeader2.rawValue, UInt8(value1), UInt8(value2), UInt8(value3)) + "\r\n")
                }
            }
        }
    }

    /* ################################################################## */
    /**
     Set Standard (J1978) Search Order
    */
	func test_useStandardSearchOrder() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useStandardSearchOrder()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useStandardSearchOrder.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set Tester Address
    */
	func test_setTesterAddress() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTesterAddress(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTesterAddress(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTesterAddress(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTesterAddress(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTesterAddress.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set Timeout to Multiples of 4ms
    */
	func test_setTimeOutBy4MillisecondIntervals() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTimeOutBy4MillisecondIntervals(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTimeOutBy4MillisecondIntervals(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTimeOutBy4MillisecondIntervals(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setTimeOutBy4MillisecondIntervals(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setTimeOutBy4MillisecondIntervals.rawValue, 255) + "\r\n")
    }

    /* ################################################################################################################################## */
    // MARK: - CAN -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting On
    */
	func test_turnCANAutoFormattingOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANAutoFormattingOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn CAN Auto-Formatting Off
    */
	func test_turnCANAutoFormattingOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANAutoFormattingOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANAutoFormattingOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn on CAN Extended Addressing, and Set it to the Given Value
    */
	func test_setCANExtendedAddressing() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setCANExtendedAddressing(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setCANExtendedAddressing(127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setCANExtendedAddressing(128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setCANExtendedAddressing(255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setCANExtendedAddressing.rawValue, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Turn CAN Extended Addressing Off
    */
	func test_turnOffCANExtendedAddressing() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnOffCANExtendedAddressing()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnOffCANExtendedAddressing.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the ID Filter
    */
	func test_setIDFilter() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(0, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 0, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(0, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 0, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(0, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 0, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(0, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 0, 255) + "\r\n")
        
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(3, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 3, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(3, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 3, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(3, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 3, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(3, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 3, 255) + "\r\n")
        
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(7, 0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 7, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(7, 127)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 7, 127) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(7, 128)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 7, 128) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(7, 255)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter1.rawValue, 7, 255) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the ID Filter (4 values)
    */
	func test_setIDFilter2() {
        let strider = stride(from: 0, to: 255, by: 64)
        
        for value1 in strider {
            for value2 in strider {
                for value3 in strider {
                    for value4 in strider {
                        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setIDFilter(UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4))
                        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setIDFilter2.rawValue, UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4)) + "\r\n")
                    }
                }
            }
        }
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control On
    */
	func test_turnCANFlowControlOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANFlowControlOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANFlowControlOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn CAN Flow Control Off
    */
	func test_turnCANFlowControlOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANFlowControlOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANFlowControlOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode On
    */
	func test_turnCANSilentModeOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANSilentModeOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANSilentModeOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn CAN Silent Mode Off
    */
	func test_turnCANSilentModeOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnCANSilentModeOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnCANSilentModeOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn DLC Display On
    */
	func test_turnDLCDisplayOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnDLCDisplayOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnDLCDisplayOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn DLC Display Off
    */
	func test_turnDLCDisplayOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnDLCDisplayOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnDLCDisplayOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Data
    */
	func test_setFlowControlData() {
        let strider = stride(from: 0, to: 255, by: 64)
        
        for value1 in strider {
            for value2 in strider {
                for value3 in strider {
                    for value4 in strider {
                        for value5 in strider {
                            (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setFlowControlData([UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4), UInt8(value5)])
                            XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setFlowControlData.rawValue, UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4), UInt8(value5)) + "\r\n")
                        }
                    }
                }
            }
        }
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Header
    */
	func test_setFlowControlHeader() {
        let strider = stride(from: 0, to: 255, by: 64)
        
        for value1 in strider {
            for value2 in strider {
                for value3 in strider {
                    for value4 in strider {
                        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setFlowControlHeader(UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4))
                        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setFlowControlHeader.rawValue, UInt8(value1), UInt8(value2), UInt8(value3), UInt8(value4)) + "\r\n")
                    }
                }
            }
        }
    }

    /* ################################################################## */
    /**
     Set the CAN Flow Control Mode
    */
	func test_setFlowControlMode() {
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setFlowControlMode(0)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setFlowControlMode.rawValue, 0) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setFlowControlMode(3)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setFlowControlMode.rawValue, 3) + "\r\n")
        (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setFlowControlMode(7)
        XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setFlowControlMode.rawValue, 7) + "\r\n")
    }

    /* ################################################################## */
    /**
     Set the Protocol B Options and Baud Rate
    */
	func test_setProtocolBOptionsAndBaudRate() {
        let strider = stride(from: 0, to: 255, by: 64)
        
        for value1 in strider {
            for value2 in strider {
                (obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.setProtocolBOptionsAndBaudRate(UInt8(value1), UInt8(value2))
                XCTAssertEqual(lastReceivedCommand, String(format: RVS_BTDriver_OBD_Command_String.setProtocolBOptionsAndBaudRate.rawValue, UInt8(value1), UInt8(value2)) + "\r\n")
            }
        }
    }

    /* ################################################################## */
    /**
     Send an RTR Message
    */
	func test_rtrMessage() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.rtrMessage()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.rtrMessage.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC On
    */
	func test_turnVariableDLCOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnVariableDLCOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnVariableDLCOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn the Variable DLC Off
    */
	func test_turnVariableDLCOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnVariableDLCOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnVariableDLCOff.rawValue + "\r\n")		
    }

    /* ################################################################################################################################## */
    // MARK: - Volts -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Set the Calibration Volts
     
     - parameter value: Calibrating voltage.
    */
	func test_setCalibratingVoltage(_ value: Float) {
        
    }

    /* ################################################################## */
    /**
     Reset the Calibration Voltage
    */
	func test_resetCalibratingVoltage() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.resetCalibratingVoltage()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.resetCalibratingVoltage.rawValue + "\r\n")		
    }

    /* ################################################################################################################################## */
    // MARK: - J1939 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Monitor for DM1 Messages
    */
	func test_monitorForDM1Messages() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.monitorForDM1Messages()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.monitorForDM1Messages.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Use ELM Data Format
    */
	func test_useElmDataFormat() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useElmDataFormat()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useElmDataFormat.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Use SAE Data Format
    */
	func test_useSAEDataFormat() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useSAEDataFormat()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useSAEDataFormat.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Header Formatting On
    */
	func test_turnJ1939HeaderFormattingOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnJ1939HeaderFormattingOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Header Formatting Off
    */
	func test_turnJ1939HeaderFormattingOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnJ1939HeaderFormattingOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnJ1939HeaderFormattingOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Use the 1X Timer Multiplier
    */
	func test_use1XTimerMultiplier() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.use1XTimerMultiplier()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.use1XTimerMultiplier.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Use the 5X Timer Multiplier
    */
	func test_use5XTimerMultiplier() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.use5XTimerMultiplier()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.use5XTimerMultiplier.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
    */
	func test_setPGNMonitor(_ value: UInt64) {
        
    }

    /* ################################################################## */
    /**
     Set the PGN Monitor
     
     - parameter value: 0-4096
     - parameter messages: 0-7 (the number of messages to receive)
    */
	func test_setPGNMonitorGetMessages(_ value: UInt64, _ messages: UInt8) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - J1850 -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Header
    */
	func test_getIFRValueFromHeader() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.getIFRValueFromHeader()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.getIFRValueFromHeader.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     The IFR Value Should be Set From the Source
    */
	func test_getIFRValueFromSource() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.getIFRValueFromSource()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.getIFRValueFromSource.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn IFRs On
    */
	func test_turnIFRsOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnIFRsOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnIFRsOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn On IFRs, and Set to Auto
    */
	func test_useIFRsAuto() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.useIFRsAuto()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.useIFRsAuto.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn IFRs Off
    */
	func test_turnIFRsOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnIFRsOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnIFRsOff.rawValue + "\r\n")		
    }

    /* ################################################################################################################################## */
    // MARK: - ISO -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Try to Set Baud Rate to 10400
    */
	func test_isoBaudRate10400() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.isoBaudRate10400()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.isoBaudRate10400.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 4800
    */
	func test_isoBaudRate4800() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.isoBaudRate4800()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.isoBaudRate4800.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Try to Set Baud Rate to 9600
    */
	func test_isoBaudRate9600() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.isoBaudRate9600()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.isoBaudRate9600.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the ISO Initial Address
     
     - parameter address: 0-255
    */
	func test_setISOInitAddress(_ address: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Display Keywords
    */
	func test_displayKeywords() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.displayKeywords()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.displayKeywords.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking On
    */
	func test_turnKeywordCheckingOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnKeywordCheckingOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Keyword Checking Off
    */
	func test_turnKeywordCheckingOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnKeywordCheckingOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnKeywordCheckingOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Perform a Slow Initiation
    */
	func test_performSlowInitiation() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.performSlowInitiation()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.performSlowInitiation.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Set the Wakeup Interval to Multiple of 4ms
     
     - parameter multiplier: 0-255
    */
	func test_setWakeupIntervalMultiplerBy20ms(_ multiplier: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Wakeup Message
     
     - parameter message: Up to 6 0-255
    */
	func test_setWakeupMessage(_ message: [UInt8]) {
        
    }

    /* ################################################################################################################################## */
    // MARK: - PPs -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Turn On All Program Parameters
    */
	func test_turnAllPPsProgParametersOn() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnAllPPsProgParametersOn()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOn.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn Off All Program Parameters
    */
	func test_turnAllPPsProgParametersOff() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.turnAllPPsProgParametersOff()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.turnAllPPsProgParametersOff.rawValue + "\r\n")		
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
	func test_setPPsProgParameterOnFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Turn On the Given Program Parameter
     
     - parameter index: Parameter index 0-255
    */
	func test_setPPsProgParameterOffFor(_ index: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Set the Given Program Parameter to the Given Value
     
     - parameter value: 0-255
     - parameter for: Parameter index 0-255
    */
	func test_setPPsProgParameterValue(_ value: UInt8, for: UInt8) {
        
    }

    /* ################################################################## */
    /**
     Return a PPs Summary
    */
	func test_ppSummary() {
		(obdInstance as? RVS_BTDriver_Device_OBD_ELM327)?.ppSummary()
		XCTAssertEqual(lastReceivedCommand, RVS_BTDriver_OBD_Command_String.ppSummary.rawValue + "\r\n")		
    }
}
