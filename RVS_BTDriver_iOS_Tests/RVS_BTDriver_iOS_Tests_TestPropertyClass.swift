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
    override func setUp() {
    }

    override func tearDown() {
    }

    func testPropertyDataType() {
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
// MARK: - Specialization of the Generic Property for Maximum Int -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_Int_MaxInt: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "\(Int.max)".data(using: .utf8)
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
        rawValue = "\(Int.min)".data(using: .utf8)
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
// MARK: - Specialization of the Generic Property for Double -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Tests_Property_SimpleNegativeFloat: RVS_BTDriver_Property {
    override init() {
        super.init()
        rawValue = "-1.2345".data(using: .utf8)
    }
}
