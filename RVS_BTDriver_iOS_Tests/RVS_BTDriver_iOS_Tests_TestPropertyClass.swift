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
// MARK: - Testing Property Data Type Conversion -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_TestPropertyClass: XCTestCase {
    /* ################################################################## */
    /**
     Test Integer zero
     */
    func testPropertyDataTypeZero() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_Zero()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(0)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(0, val, "Should be Zero!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Test Integer zero (decimal)
     */
    func testPropertyDataTypeZeroDecimal() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_ZeroDecimal()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(0)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(0, val, "Should be Zero!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Test highest Int (Int32.max)
     */
    func testPropertyDataTypeMax() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MaxInt()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(Int(Int32.max))
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(Int(Int32.max), val, "Should be Int32 Max!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Test lowest Int (Int32.min)
     */
    func testPropertyDataTypeMin() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MinInt()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(Int(Int32.min))
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(Int(Int32.min), val, "Should be Int32 Min!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that a string containing a decimal number, where the decimal is .0000, is returned as an Int.
     */
    func testPropertyDataTypeWithDecimal() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_IntWithDecimal()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(1)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(1, val, "Should be 1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that a string containing a decimal number, where the decimal is .0000, is returned as an Int (Negative).
     */
    func testPropertyDataTypeWithDecimalNegative() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_NegativeIntWithDecimal()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.intValue(-1)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .intValue(val) = testTarget {
            XCTAssertEqual(-1, val, "Should be -1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that positive Doubles are returned.
     */
    func testPropertyDataTypeSimpleFloat() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_SimpleFloat()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.floatValue(1.2345)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .floatValue(val) = testTarget {
            XCTAssertEqual(1.2345, val, "Should be 1.2345!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that negative Doubles are returned.
     */
    func testPropertyDataTypeSimpleNegativeFloat() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_SimpleNegativeFloat()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.floatValue(-1.2345)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .floatValue(val) = testTarget {
            XCTAssertEqual(-1.2345, val, "Should be -1.2345!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     In this test, we ensure that values beyond Int32.max are returned as Double.
     */
    func testPropertyDataTypeMaxPlusOne() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MaxIntPlusOne()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.floatValue(Double(Int32.max) + 1)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .floatValue(val) = testTarget {
            XCTAssertEqual(Double(Int32.max) + 1, val, "Should be Int32 Max + 1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     In this test, we ensure that values below Int32.min are returned as Double.
     */
    func testPropertyDataTypeMinMinusOne() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MinIntMinusOne()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.floatValue(Double(Int32.min) - 1)
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .floatValue(val) = testTarget {
            XCTAssertEqual(Double(Int32.min) - 1, val, "Should be Int32 Min - 1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     This test forces the number to be a String, by prepending a space.
     */
    func testPropertyDataTypeMinMinusOneStringy() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MinIntMinusOneStringy()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.stringValue(" " + String(Double(Int32.min) - 1))
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .stringValue(val) = testTarget {
            XCTAssertEqual(" " + String(Double(Int32.min) - 1), val, "Should be Int32 Min - 1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     This does the same, by suffixing a space. It also is a String that could be an Int.
     */
    func testPropertyDataTypeMaxMinusOneStringy() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_Int_MaxIntMinusOneStringy()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.stringValue(String(Int32.max - 1) + " ")
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .stringValue(val) = testTarget {
            XCTAssertEqual(String(Int32.max - 1) + " ", val, "Should be Int32 Max - 1!")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     This tests a pure string, with no numerical characters.
     */
    func testPropertyDataTypeString() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_String()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.stringValue("Open the pod bay doors, Hal.")
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .stringValue(val) = testTarget {
            XCTAssertEqual("Open the pod bay doors, Hal.", val, "Should be 'Open the pod bay doors, Hal.'")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
    
    /* ################################################################## */
    /**
     This tests a pure string, in Japanese.
     */
    func testPropertyDataTypeStringJapanese() {
        let testTargetInstance = RVS_BTDriver_iOS_Tests_Property_StringJapanese()
        let testTarget = testTargetInstance.value
        let comparisonTarget = RVS_BTDriver_PropertyProtocol_Type_Enum.stringValue("ポッドベイドア、Halを開きます。")
        XCTAssertEqual(testTarget, comparisonTarget, "Values Don't Match!")
        if case let .stringValue(val) = testTarget {
            XCTAssertEqual("ポッドベイドア、Halを開きます。", val, "Should be 'ポッドベイドア、Halを開きます。'")
        } else {
            XCTFail("Not the Expected Type!")
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Int As Zero -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_Zero: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "0".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Int As Zero, but expressed with a decimal point. -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_ZeroDecimal: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "0.0000".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Maximum Int -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MaxInt: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "\(Int32.max)".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Minimum Int -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MinInt: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "\(Int32.min)".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Int With A Decimal Point, and Zero -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_IntWithDecimal: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "1.0000".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Int With Decimal Point, but Negative -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_NegativeIntWithDecimal: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "-1.0000".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Double -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_SimpleFloat: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "1.2345".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Double Negative -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_SimpleNegativeFloat: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "-1.2345".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Maximum Int Plus One -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MaxIntPlusOne: RVS_BTDriver_Property {
    override init() {
        super.init()
        let doubleVal = Double(Int32.max) + 1
        rawValue = "\(doubleVal)".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Minimum Int Minus One -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MinIntMinusOne: RVS_BTDriver_Property {
    override init() {
        super.init()
        let doubleVal = Double(Int32.min) - 1
        rawValue = "\(doubleVal)".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Minimum Int Minus One, but preceded by a space; which makes it a String -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MinIntMinusOneStringy: RVS_BTDriver_Property {
    override init() {
        super.init()
        let doubleVal = Double(Int32.min) - 1
        rawValue = " \(doubleVal)".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for Maximum Int Minus One, but succeeded by a space; which makes it a String -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MaxIntMinusOneStringy: RVS_BTDriver_Property {
    override init() {
        super.init()
        let val = Int32.max - 1
        rawValue = "\(val) ".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for a Pure String -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_String: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "Open the pod bay doors, Hal.".data(using: .utf8)
    }
}

/* ###################################################################################################################################### */
// MARK: - Specialization of the Generic Property for a Pure String, in Japanese characters -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_StringJapanese: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "ポッドベイドア、Halを開きます。".data(using: .utf8)
    }
}
