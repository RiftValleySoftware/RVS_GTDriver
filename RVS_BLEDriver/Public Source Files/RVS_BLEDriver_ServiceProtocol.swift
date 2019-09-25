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
// MARK: - Main Driver RVS_BLEDriver_ServiceProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This protocol describes a service, or collection of "values," expressed as a sequence.
 */
public protocol RVS_BLEDriver_ServiceProtocol: RVS_SequenceProtocol where Element == RVS_BLEDriver_ValueProtocol {
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ServiceProtocol Protocol Extension -
/* ###################################################################################################################################### */
/**
 These defaults allow a number of methods to be optional.
 */
extension RVS_BLEDriver_ServiceProtocol {
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ValueProtocol Protocol -
/* ###################################################################################################################################### */
/**
 This protocol is used to describe one value in a service.
 */
public protocol RVS_BLEDriver_ValueProtocol {
}

/* ###################################################################################################################################### */
// MARK: - Main Driver RVS_BLEDriver_ValueProtocol Protocol Extension -
/* ###################################################################################################################################### */
/**
 These defaults allow a number of methods to be optional.
 */
extension RVS_BLEDriver_ValueProtocol {
}
