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
        
        var mask: UInt32 = 0x80000000
        
        // The bits are inverse proportional to the PID they each represent.
        for pid in 1..<33 {
            if 0 != mask & _value {
                let build = String(format: "%02X%02X", service, pid)
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
     These are flags that indicate the status of various tests.
     */
    enum TestStatus {
        /// This means that the test is valid, but neither of its flags are set.
        case unknown
        /// This means that the incomplete flag is set for this test.
        case inProgress
        /// This means that the complete flag is set for this test.
        case complete
    }
    
    /* ################################################################## */
    /**
     These are the various tests that are available.
     */
    enum TestCategories: Hashable {
        // MARK: All Types of Engines
        
        /// Various Components of the System
        case components(TestStatus)
        /// The Fuel System.
        case fuelSystem(TestStatus)
        /// Engine Misfires
        case misfire(TestStatus)
        /// EGR (and/or VVT for Diesel)
        case egr(TestStatus)
        /// Catalyst system (NMHC Catalyst, for Diesel)
        case catalyst(TestStatus)

        // MARK: Standard Spark Engines
        
        /// Oxygen Sensor Heater
        case oxygenSensorHeater(TestStatus)
        /// Oxygen Sensor
        case oxygenSensor(TestStatus)
        /// Air-Conditioning Refrigerant
        case acRefrigerant(TestStatus)
        /// Secondary Air System (SAS)
        case sas(TestStatus)
        /// Evaporative System
        case evaporativeSystem(TestStatus)
        /// Heated Catalyst
        case heatedCatalyst(TestStatus)
        
        // MARK: Diesel Engines
        
        /// PM Filter Monitoring
        case pmFilterMonitoring(TestStatus)
        /// Exhaust Gas Sensor
        case exhaustSensor(TestStatus)
        /// Boost Pressure
        case boostPressure(TestStatus)
        /// NOx/SCR Monitor
        case noxSCR(TestStatus)
        
        /* ################################################################## */
        /**
         This is a quick way to see the status of the test.
         
         - returns: The status.
         */
        var testStatus: TestStatus {
            var ret: TestStatus
            
            switch self {
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
                 .heatedCatalyst(let status),
                 .pmFilterMonitoring(let status),
                 .exhaustSensor(let status),
                 .boostPressure(let status),
                 .noxSCR(let status):
                ret = status
            }
            
            return ret
        }
    }
    
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
    
    /* ################################################################## */
    /**
     - returns: True, if the motor is compression (diesel).
     */
    var isDiesel: Bool { return _value.isDiesel }
    
    /* ################################################################## */
    /**
     - returns: True, if the motor is spark.
     */
    var isSpark: Bool { return !isDiesel }

    /* ################################################################## */
    /**
     - returns: The number of DTCs available.
     */
    var count: Int { return _value.count }

    /* ################################################################## */
    /**
     This returns a Set of enums, containing the status of various tests. Each test has an associated value, containing its status.
     */
    var testAvailability: Set<TestCategories> {
        var ret: Set<TestCategories> = [
            // All types of engine (no check for diesel)
            .components(_value.componentsAvailable ? .complete : _value.componentsIncomplete ? .inProgress :.unknown),
            .fuelSystem(_value.fuelSystemAvailable ? .complete : _value.fuelSystemIncomplete ? .inProgress : .unknown),
            .misfire(_value.misfireAvailable ? .complete : _value.misfireIncomplete ? .inProgress : .unknown),
            .egr(_value.egrSystemAvailable ? .complete : _value.egrSystemIncomplete ? .inProgress : .unknown),
            .catalyst(_value.catalystAvailable ? .complete : _value.catalystIncomplete ? .inProgress : .unknown)
        ]
        
        if isSpark {
            ret = ret.union(Set<TestCategories>(arrayLiteral: .oxygenSensorHeater(_value.oxygenSensorHeaterAvailable ? .complete : _value.oxygenSensorHeaterIncomplete ? .inProgress : .unknown),
                .oxygenSensor(_value.oxygenSensorAvailable ? .complete : _value.oxygenSensorIncomplete ? .inProgress : .unknown),
                .acRefrigerant(_value.acRefrigerantAvailable ? .complete : _value.acRefrigerantIncomplete ? .inProgress : .unknown),
                .sas(_value.sasAvailable ? .complete : _value.sasIncomplete ? .inProgress : .unknown),
                .evaporativeSystem(_value.evaporativeSystemAvailable ? .complete : _value.evaporativeSystemIncomplete ? .inProgress : .unknown),
                .heatedCatalyst(_value.heatedCatalystAvailable ? .complete : _value.heatedCatalystIncomplete ? .inProgress : .unknown)
                )
            )
        } else {
            ret = ret.union(Set<TestCategories>(arrayLiteral: .pmFilterMonitoring(_value.pmFilterMonitoringAvailable ? .complete : _value.pmFilterMonitoringIncomplete ? .inProgress : .unknown),
                .exhaustSensor(_value.exhaustSensorAvailable ? .complete : _value.exhaustSensorIncomplete ? .inProgress : .unknown),
                .boostPressure(_value.boostPressureAvailable ? .complete : _value.boostPressureIncomplete ? .inProgress : .unknown),
                .noxSCR(_value.noxSCRAvailable ? .complete : _value.noxSCRIncomplete ? .inProgress : .unknown)
                )
            )
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     - returns: Only the tests that have completed.
     */
    var testsComplete: [TestCategories] { return testAvailability.compactMap { return .complete == $0.testStatus ? $0 : nil } }
    
    /* ################################################################## */
    /**
     - returns: Only the tests that are still under way.
     */
    var testsInProgress: [TestCategories] { return testAvailability.compactMap { return .inProgress == $0.testStatus ? $0 : nil } }
    
    /* ################################################################## */
    /**
     - returns: Only the tests that are in an unknown state.
     */
    var testsUnkown: [TestCategories] { return testAvailability.compactMap { return .unknown == $0.testStatus ? $0 : nil } }
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
