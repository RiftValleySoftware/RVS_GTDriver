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
// MARK: - RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask -
/* ###################################################################################################################################### */
/**
 This is an option set that will decode the response to the 0101/0141 PID.
 */
internal struct RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask: OptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt32
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue

    // MARK: ABCD A = 0xFF000000, B = 0x00FF0000, C = 0x0000FF00, D = 0x000000FF
    
    // MARK: A
    /// CE/MIL on
    static let mil = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                             RawValue(0x80000000))
    /// Number of Emissions-related DTCs
    static let dtcCount = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        RawValue(0x7F000000))
    
    // MARK: B
    /// Reserved
    static let reserved = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                        RawValue(0x00800000))
    /// This is on, if the motor is compression (diesel).
    static let diesel = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                          RawValue(0x00080000))
    
    /// Components system test available
    static let componentsAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00004000))
    /// Components system test still in progress
    static let componentsIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00040000))
    /// Fuel system test available
    static let fuelSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00002000))
    /// Fuel system test still in progress
    static let fuelSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00020000))
    /// Misfire test available
    static let misfireAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                RawValue(0x00001000))
    /// Misfire test still in progress
    static let misfireIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               RawValue(0x00010000))
    /// EGR System test available
    static let egrSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              RawValue(0x00008000))
    /// EGR System test still in progress
    static let egrSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00000080))
    /// Catalyst test available
    static let catalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:               RawValue(0x00000100))
    /// Catalyst test still in progress
    static let catalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:              RawValue(0x00000001))

    // MARK: C-D (Spark) Only valid if .diesel is off
    /// Oxygen sensor heater test available
    static let oxygenSensorHeaterAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00004000))
    /// Oxygen sensor heater test still in progress
    static let oxygenSensorHeaterIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    RawValue(0x00000040))
    /// Oxygen sensor test available
    static let oxygenSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:           RawValue(0x00002000))
    /// Oxygen sensor test still in progress
    static let oxygenSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00000020))
    /// A/C refrigerant test available
    static let acRefrigerantAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00001000))
    /// A/C refrigerant test still in progress
    static let acRefrigerantIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000010))
    /// Secondary air system test available
    static let sasAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                    RawValue(0x00000800))
    /// Secondary air system test still in progress
    static let sasIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                   RawValue(0x00000008))
    /// Evaporative system test available
    static let evaporativeSystemAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:      RawValue(0x00000400))
    /// Evaporative system test still in progress
    static let evaporativeSystemIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00000004))
    /// Heated catalyst test available
    static let heatedCatalystAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000200))
    /// Heated catalyst test still in progress
    static let heatedCatalystIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:        RawValue(0x00000002))
    
    // MARK: C-D (Diesel) Only valid if .diesel is on
    /// PM filter monitoring test available
    static let pmFilterMonitoringAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:     RawValue(0x00004000))
    /// PM filter monitoring test still in progress
    static let pmFilterMonitoringIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:    RawValue(0x00000040))
    /// Exhaust gas test available
    static let exhaustSensorAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00002000))
    /// Exhaust gas test still in progress
    static let exhaustSensorIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000020))
    /// Reserved
    static let reserved01Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00001000))
    /// Reserved
    static let reserved01Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00000010))
    /// Boost pressure test available
    static let boostPressureAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:          RawValue(0x00000800))
    /// Boost pressure test still in progress
    static let boostPressureIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:         RawValue(0x00000008))
    /// Reserved
    static let reserved02Available = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:             RawValue(0x00000400))
    /// Reserved
    static let reserved02Incomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:            RawValue(0x00000004))
    /// NOx/SCR Monitor test available
    static let noxSCRAvailable = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                 RawValue(0x00000200))
    /// NOx/SCR Monitor test still in progress
    static let noxSCRIncomplete = RVS_BTDriver_OBD_Command_Service_01_MonitorStatusBitMask(rawValue:                RawValue(0x00000002))

    // MARK: A
    /// CE/MIL on
    var isMILOn: Bool { return 0 != rawValue & Self.mil.rawValue }
    /// Number of Emissions-related DTCs
    var count: Int { return Int(rawValue & Self.dtcCount.rawValue >> 24) }
    
    // MARK: B
    /// This is on, if the motor is compression (diesel).
    var isDiesel: Bool { return 0 != rawValue & Self.diesel.rawValue }
    
    /// Components system test available
    var componentsAvailable: Bool { return 0 != rawValue & Self.componentsAvailable.rawValue }
    /// Components system test still in progress
    var componentsIncomplete: Bool { return 0 != rawValue & Self.componentsIncomplete.rawValue }
    /// Fuel system test available
    var fuelSystemAvailable: Bool { return 0 != rawValue & Self.fuelSystemAvailable.rawValue }
    /// Fuel system test still in progress
    var fuelSystemIncomplete: Bool { return 0 != rawValue & Self.fuelSystemIncomplete.rawValue }
    /// Misfire test available
    var misfireAvailable: Bool { return 0 != rawValue & Self.misfireAvailable.rawValue }
    /// Misfire test still in progress
    var misfireIncomplete: Bool { return 0 != rawValue & Self.misfireIncomplete.rawValue }
    /// EGR System test available
    var egrSystemAvailable: Bool { return 0 != rawValue & Self.egrSystemAvailable.rawValue }
    /// EGR System test still in progress
    var egrSystemIncomplete: Bool { return 0 != rawValue & Self.egrSystemIncomplete.rawValue }
    /// Catalyst test available
    var catalystAvailable: Bool { return 0 != rawValue & Self.catalystAvailable.rawValue }
    /// Catalyst test still in progress
    var catalystIncomplete: Bool { return 0 != rawValue & Self.catalystIncomplete.rawValue }

    // MARK: C-D (Spark) Only valid if .isDiesel is off
    /// Oxygen sensor heater test available
    var oxygenSensorHeaterAvailable: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorHeaterAvailable.rawValue }
    /// Oxygen sensor heater test still in progress
    var oxygenSensorHeaterIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorHeaterIncomplete.rawValue }
    /// Oxygen sensor test available
    var oxygenSensorAvailable: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorAvailable.rawValue }
    /// Oxygen sensor test still in progress
    var oxygenSensorIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.oxygenSensorIncomplete.rawValue }
    /// A/C refrigerant test available
    var acRefrigerantAvailable: Bool { return !isDiesel && 0 != rawValue & Self.acRefrigerantAvailable.rawValue }
    /// A/C refrigerant test still in progress
    var acRefrigerantIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.acRefrigerantIncomplete.rawValue }
    /// Secondary air system test available
    var sasAvailable: Bool { return !isDiesel && 0 != rawValue & Self.sasAvailable.rawValue }
    /// Secondary air system test still in progress
    var sasIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.sasIncomplete.rawValue }
    /// Evaporative system test available
    var evaporativeSystemAvailable: Bool { return !isDiesel && 0 != rawValue & Self.evaporativeSystemAvailable.rawValue }
    /// Evaporative system test still in progress
    var evaporativeSystemIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.evaporativeSystemIncomplete.rawValue }
    /// Heated catalyst test available
    var heatedCatalystAvailable: Bool { return !isDiesel && 0 != rawValue & Self.heatedCatalystAvailable.rawValue }
    /// Heated catalyst test still in progress
    var heatedCatalystIncomplete: Bool { return !isDiesel && 0 != rawValue & Self.heatedCatalystIncomplete.rawValue }
    
    // MARK: C-D (Diesel) Only valid if .isDiesel is on
    /// PM filter monitoring test available
    var pmFilterMonitoringAvailable: Bool { return isDiesel && 0 != rawValue & Self.pmFilterMonitoringAvailable.rawValue }
    /// PM filter monitoring test still in progress
    var pmFilterMonitoringIncomplete: Bool { return isDiesel && 0 != rawValue & Self.pmFilterMonitoringIncomplete.rawValue }
    /// Exhaust gas test available
    var exhaustSensorAvailable: Bool { return isDiesel && 0 != rawValue & Self.exhaustSensorAvailable.rawValue }
    /// Exhaust gas test still in progress
    var exhaustSensorIncomplete: Bool { return isDiesel && 0 != rawValue & Self.exhaustSensorIncomplete.rawValue }
    /// Boost pressure test available
    var boostPressureAvailable: Bool { return isDiesel && 0 != rawValue & Self.boostPressureAvailable.rawValue }
    /// Boost pressure test still in progress
    var boostPressureIncomplete: Bool { return isDiesel && 0 != rawValue & Self.boostPressureIncomplete.rawValue }
    /// NOx/SCR Monitor test available
    var noxSCRAvailable: Bool { return isDiesel && 0 != rawValue & Self.noxSCRAvailable.rawValue }
    /// NOx/SCR Monitor test still in progress
    var noxSCRIncomplete: Bool { return isDiesel && 0 != rawValue & Self.noxSCRIncomplete.rawValue }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader OptionSet -
/* ###################################################################################################################################### */
/**
 This struct will act as a bitmask to decode the flag byte of the EGT.
 */
struct RVS_BTDriver_OBD_Command_Service_01_ExhaustGasTemperature_EGTHeader: OptionSet {
    /// Required for the OptionSet protocol.
    typealias RawValue = UInt8
    
    /// Required for the OptionSet protocol.
    let rawValue: RawValue

    /// Reserved.
    static let reserved = RawValue(0xF0)
    /// Sensor 4 is supported.
    static let egtsensor04 = RawValue(0x08)
    /// Sensor 3 is supported.
    static let egtsensor03 = RawValue(0x04)
    /// Sensor 2 is supported.
    static let egtsensor02 = RawValue(0x02)
    /// Sensor 1 is supported.
    static let egtsensor01 = RawValue(0x01)
    
    /// - returns: True, if Sensor 4 has tests.
    var isSensor04Supported: Bool { return 0 != rawValue & Self.egtsensor04 }
    
    /// - returns: True, if Sensor 3 has tests.
    var isSensor03Supported: Bool { return 0 != rawValue & Self.egtsensor03 }
    
    /// - returns: True, if Sensor 2 has tests.
    var isSensor02Supported: Bool { return 0 != rawValue & Self.egtsensor02 }
    
    /// - returns: True, if Sensor 1 has tests.
    var isSensor01Supported: Bool { return 0 != rawValue & Self.egtsensor01 }
}

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
