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

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_SupportedPIDsBitMask Protocol -
/* ###################################################################################################################################### */
/**
 This is the base protocol for command interpreters. It defines an Array of String, which is used to match the interpreter with the PID it is applied to.
 */
internal protocol RVS_BTDriver_OBD_Command_Service_Command_Interpreter {
    /* ################################################################## */
    /**
     This returns an Array of Strings, reflecting which PIDs will return data to be decoded by this mask set.
     */
    static var pidCommands: [String] { get }
    
    /* ################################################################## */
    /**
     This return an Int, with the service being handled by this interpreter.
     */
    var service: Int { get }
    
    /* ################################################################## */
    /**
     This will read in the data, and save the header (a UInt8 bitmask), and the data (4 UInt16).
     
     - parameter contents: The contents, as a String of 2-character hex numbers, space-separated.
     - parameter service: The service to which this interpreter applies.
     */
    init(contents inContents: String, service inService: Int)
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsBitMask -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0100 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_02_SupportedPIDsInterpreter: RVS_BTDriver_OBD_Command_Service_Command_Interpreter {
    /// This is the interpreted value, assigned to an OptionSet.
    private let _value: UInt32
    /// This will contain the service (either 1 or 2) to which this interpreter applies.
    var service: Int = 0
    
    /* ################################################################## */
    /**
     This will be used for the first PID of Service 01 and 02.
     */
    static var pidCommands: [String] {
        return [RVS_BTDriver_OBD_Command_Service_01_PIDs.returnSupportedPIDs.rawValue,
                RVS_BTDriver_OBD_Command_Service_02_PIDs.returnSupportedPIDs.rawValue]
    }
    
    /* ################################################################## */
    /**
     This returns an Array of String, containing the PIDs that are supported.
     */
    var supportedPIDs: [String] {
        var ret: [String] = []
        
        var mask:UInt32 = 0x80000000
        
        for bit in 0..<32 {
            if 0 != mask & _value {
                let build = String(format: "%0x%0x", service, bit)
                ret.append(build)
            }
            
            mask = mask >> 1
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This will read in the data, and save the header (a UInt8 bitmask), and the data (4 UInt16).
     
     - parameter contents: The contents, as a String of 2-character hex numbers, space-separated.
     - parameter service: The service (either 1 or 2), to which this interpreter applies.
     */
    init(contents inContents: String, service inService: Int) {
        if  1 == inService || 2 == inService,   // Must be one of these. No other values allowed.
            let derivedValue = UInt32(inContents.hexOnly, radix: 16) {
            service = inService
            _value = derivedValue
            return
        }
        
        _value = 0
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0101/0141 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_MonitorStatus_Interpreter: RVS_BTDriver_OBD_Command_Service_Command_Interpreter {
    /// This contains the value of the response.
    private let _value: RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask
    /// This will contain the service (either 1 or 2) to which this interpreter applies.
    var service: Int = 0

    /* ################################################################## */
    /**
     This will be used by these PIDs of service 01.
     */
    static var pidCommands: [String] {
        return [RVS_BTDriver_OBD_Command_Service_01_PIDs.returnMonitorStatus.rawValue,
                RVS_BTDriver_OBD_Command_Service_01_PIDs.returnMonitorStatusThisCycle.rawValue]
    }
    
    /* ################################################################## */
    /**
     This will read in the data, and save the header (a UInt8 bitmask), and the data (4 UInt16).
     
     - parameter contents: The contents, as a String of 2-character hex numbers, space-separated.
     - parameter service: The service (either 1 or 2), to which this interpreter applies.
     */
    init(contents inContents: String, service inService: Int) {
        if  1 == inService || 2 == inService,   // Must be one of these. No other values allowed.
            let derivedValue = UInt32(inContents.hexOnly, radix: 16) {
            _value = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue: derivedValue)
            return
        }
        
        _value = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue: 0)
    }
    
    /// This is on, if the motor is compression (diesel).
    var isDiesel: Bool { return _value.isDiesel }
    
    /// Components system test available
    var componentsAvailable: Bool { return _value.componentsAvailable }
    /// Components system test still in progress
    var componentsIncomplete: Bool { return _value.componentsIncomplete }
    /// Fuel system test available
    var fuelSystemAvailable: Bool { return _value.fuelSystemAvailable }
    /// Fuel system test still in progress
    var fuelSystemIncomplete: Bool { return _value.fuelSystemIncomplete }
    /// Misfire test available
    var misfireAvailable: Bool { return _value.misfireAvailable }
    /// Misfire test still in progress
    var misfireIncomplete: Bool { return _value.misfireIncomplete }
    /// EGR System test available
    var egrSystemAvailable: Bool { return _value.egrSystemAvailable }
    /// EGR System test still in progress
    var egrSystemIncomplete: Bool { return _value.egrSystemIncomplete }
    /// Catalyst test available
    var catalystAvailable: Bool { return _value.catalystAvailable }
    /// Catalyst test still in progress
    var catalystIncomplete: Bool { return _value.catalystIncomplete }
    /// Oxygen sensor heater test available
    var oxygenSensorHeaterAvailable: Bool { return _value.oxygenSensorHeaterAvailable }
    /// Oxygen sensor heater test still in progress
    var oxygenSensorHeaterIncomplete: Bool { return _value.oxygenSensorHeaterIncomplete }
    /// Oxygen sensor test available
    var oxygenSensorAvailable: Bool { return _value.oxygenSensorAvailable }
    /// Oxygen sensor test still in progress
    var oxygenSensorIncomplete: Bool { return _value.oxygenSensorIncomplete }
    /// A/C refrigerant test available
    var acRefrigerantAvailable: Bool { return _value.acRefrigerantAvailable }
    /// A/C refrigerant test still in progress
    var acRefrigerantIncomplete: Bool { return _value.acRefrigerantIncomplete }
    /// Secondary air system test available
    var sasAvailable: Bool { return _value.sasAvailable }
    /// Secondary air system test still in progress
    var sasIncomplete: Bool { return _value.sasIncomplete }
    /// Evaporative system test available
    var evaporativeSystemAvailable: Bool { return _value.evaporativeSystemAvailable }
    /// Evaporative system test still in progress
    var evaporativeSystemIncomplete: Bool { return _value.evaporativeSystemIncomplete }
    /// Heated catalyst test available
    var heatedCatalystAvailable: Bool { return _value.heatedCatalystAvailable }
    /// Heated catalyst test still in progress
    var heatedCatalystIncomplete: Bool { return _value.heatedCatalystIncomplete }
    /// PM filter monitoring test available
    var pmFilterMonitoringAvailable: Bool { return _value.pmFilterMonitoringAvailable }
    /// PM filter monitoring test still in progress
    var pmFilterMonitoringIncomplete: Bool { return _value.pmFilterMonitoringIncomplete }
    /// Exhaust gas test available
    var exhaustSensorAvailable: Bool { return _value.exhaustSensorAvailable }
    /// Exhaust gas test still in progress
    var exhaustSensorIncomplete: Bool { return _value.exhaustSensorIncomplete }
    /// Boost pressure test available
    var boostPressureAvailable: Bool { return _value.boostPressureAvailable }
    /// Boost pressure test still in progress
    var boostPressureIncomplete: Bool { return _value.boostPressureIncomplete }
    /// NOx/SCR Monitor test available
    var noxSCRAvailable: Bool { return _value.noxSCRAvailable }
    /// NOx/SCR Monitor test still in progress
    var noxSCRIncomplete: Bool { return _value.noxSCRIncomplete }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature -
/* ###################################################################################################################################### */
/**
 This is a special struct that is used to decode the exhaust gas temperature sensor data.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature: RVS_BTDriver_OBD_Command_Service_Command_Interpreter {
    /* ################################################################## */
    /**
     This will be used by these PIDs of service 01 and 02.
     */
    static var pidCommands: [String] {
        return [RVS_BTDriver_OBD_Command_Service_01_PIDs.egt_Bank_01.rawValue,
                RVS_BTDriver_OBD_Command_Service_01_PIDs.egt_Bank_02.rawValue]
    }
    
    var service: Int = 0
    
    // MARK: ABCDE A = 0xFF0000000000000000, B = 0x00FFFF000000000000, C =  0x000000FFFF00000000, D = 0x0000000000FFFF0000, E = 0x00000000000000FFFF
    
    /// This is the header, and it will be a bitmask, denoting which of the following 16-bit numbers represent a test result.
    private let _header: RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader
    /// This is an Array of 16-bit numbers, representing test results.
    private let _data: [UInt16]
    
    /// - returns: True, if Sensor 4 has tests.
    var isSensor04DataAvailable: Bool { return _header.isSensor04Supported }
    
    /// - returns: True, if Sensor 3 has tests.
    var isSensor03DataAvailable: Bool { return _header.isSensor03Supported }
    
    /// - returns: True, if Sensor 2 has tests.
    var isSensor02DataAvailable: Bool { return _header.isSensor02Supported }
    
    /// - returns: True, if Sensor 1 has tests.
    var isSensor01DataAvailable: Bool { return _header.isSensor01Supported }

    /* ################################################################## */
    /**
     - returns: The sensor test data for sensor 4.
     */
    var sensor04: UInt16 {
        if isSensor04DataAvailable && 0 < _data.count {
            return _data[0]
        }
        return 0
    }
    
    /* ################################################################## */
    /**
     - returns: The sensor test data for sensor 3.
     */
    var sensor03: UInt16 {
        if isSensor03DataAvailable && 1 < _data.count {
            return _data[1]
        }
        return 0
    }
    
    /* ################################################################## */
    /**
     - returns: The sensor test data for sensor 2.
     */
    var sensor02: UInt16 {
        if isSensor02DataAvailable && 2 < _data.count {
            return _data[2]
        }
        return 0
    }
    
    /* ################################################################## */
    /**
     - returns: The sensor test data for sensor 1.
     */
    var sensor01: UInt16 {
        if isSensor01DataAvailable && 2 < _data.count {
            return _data[3]
        }
        return 0
    }

    /* ################################################################## */
    /**
     This will read in the data, and save the header (a UInt8 bitmask), and the data (4 UInt16).
     
      - parameter contents: The contents, as a String of 2-character hex numbers, space-separated.
      - parameter service: The service (either 1 or 2), to which this interpreter applies.
      */
     init(contents inContents: String, service inService: Int) {
        var split = inContents.split(separator: " ")
        if 2 < split.count {
            if let head = UInt8(split.removeFirst(), radix: 16) {
                _header = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader(rawValue: head)

                var contents: [UInt16] = []
                
                for i in stride(from: 0, to: split.count, by: 2) {
                    if let value = UInt16(String(split[i] + split[i+1]), radix: 16) {
                        contents.append(value)
                    }
                }
                
                _data  = contents
                return
            }
        }
        
        _header = RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader(rawValue: 0)
        _data = []
    }
}
