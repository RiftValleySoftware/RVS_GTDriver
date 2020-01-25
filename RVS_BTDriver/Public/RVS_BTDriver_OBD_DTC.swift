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
import Foundation

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_OBD_DTC -
/* ###################################################################################################################################### */
/**
 This enum defines the base for the OBD diagnostic trouble codes (DTCs).
 Each instance of this struct is a single DTC.
 */
public struct RVS_BTDriver_OBD_DTC {
    private static let _codeDesignations = ["P", "C", "B", "U"]

    /* ################################################################## */
    /**he code, itself, is stored as a two-byte integer
     */
    private let _code: UInt16
    
    /* ################################################################## */
    /**
     This function will read the integer code, and return a "[P|U|C|B]****" string
     
     - parameter inCode: The code (an unsigned, 16-bit integer).
     - returns: A String, in the DTC format (Alphabetic chracater -U, P, C or B, followed by four hex digits). Can be nil, if the code cannot be translated.
     */
    private static func _convertCodeToString(_ inCode: UInt16) -> String! {
        let codeDesignationIndex = Int(inCode).maskedValue(firstPlace: 14, runLength: 2)
        let codeHeader = _codeDesignations[codeDesignationIndex]
        let ret = codeHeader + String(format: "%04X", Int(inCode).maskedValue(firstPlace: 0, runLength: 14))
        return ret
    }
    
    /* ################################################################## */
    /**
     This function reads the hex string returned by the device, and renders it into the UInt16 necessary for use as the code.
     
     - parameter inStringData: The String data, raw from the command.
     - returns: The rendered code, as a UInt16.
     */
    private static func _convertStringToCode(_ inStringData: String) -> UInt16! {
        let compressedString = inStringData.hexOnly
        assert(4 == compressedString.count, "There must be exactly 4 hex characters.")
        return UInt16(compressedString.hex2Int)
    }
    
    /* ################################################################## */
    /**
     This returns the code, in its "native" form.
     */
    var intValue: UInt16 {
        return _code
    }
    
    /* ################################################################## */
    /**
     This returns the code, in its alphanumeric (familiar) form.
     */
    var stringValue: String {
        return Self._convertCodeToString(_code)
    }
    
    /* ################################################################## */
    /**
     Initialize with a UInt16 code.
     */
    init(code inCode: UInt16) {
        _code = inCode
    }
    
    /* ################################################################## */
    /**
     Intiatlize with raw string data.
     */
    init(stringData inStringData: String) {
        _code = Self._convertStringToCode(inStringData) ?? 0
    }
}
