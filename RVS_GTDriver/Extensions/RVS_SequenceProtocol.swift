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
// MARK: - Standardized Sequence Protocol to Let Collectors be Sequences -
/* ###################################################################################################################################### */
/**
 */
public protocol RVS_SequenceProtocol: Sequence {
    /* ################################################################## */
    /**
     The implementor is required to have an Array of Element (required by Sequence).
     */
    var sequence_contents: [Element] { get set }
    
    /* ################################################################## */
    /**
     Subscript access is get-only (for safety).
     
     - parameter index: The 0-based index to subscript. Must be less than count.
     */
    subscript(_ inIndex: Int) -> Element { get }
}

/* ###################################################################################################################################### */
// MARK: - Makes Things Optional -
/* ###################################################################################################################################### */
/**
 */
extension RVS_SequenceProtocol {
    /* ################################################################## */
    /**
     We just pass the iterator through to the Array.
     
     - returns: The Array iterator for our characateristics.
     */
    public func makeIterator() -> Array<Element>.Iterator {
        return sequence_contents.makeIterator()
    }
    
    /* ################################################################## */
    /**
     The number of characteristics we have. 1-based. 0 is no characteristics.
     */
    public var count: Int {
        return sequence_contents.count
    }
    
    /* ################################################################## */
    /**
     Returns an indexed characteristic.
     
     - parameter inIndex: The 0-based integer index. Must be less than the total count of characteristics.
     */
    public subscript(_ inIndex: Int) -> Element {
        precondition((0..<count).contains(inIndex))   // Standard precondition. Index needs to be 0 or greater, and less than the count.
        
        return sequence_contents[inIndex]
    }
}
