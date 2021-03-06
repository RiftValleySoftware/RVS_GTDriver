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

import WatchKit
import Foundation

/* ###################################################################################################################################### */
// MARK: - The Main Extension Delegate Class
/* ###################################################################################################################################### */
/**
 This is the main extension delegate class for the Watch standalone app.
 */
class RVS_BTDriver_WatchOS_Test_Harness_ExtensionDelegate: NSObject, WKExtensionDelegate {
    /* ################################################################################################################################## */
    // MARK: - Class Computed Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Shortcut to fetch the delegate instance, cast correctly. May be nil.
     */
    class var delegateObject: RVS_BTDriver_WatchOS_Test_Harness_ExtensionDelegate! {
        return WKExtension.shared().delegate as? RVS_BTDriver_WatchOS_Test_Harness_ExtensionDelegate
    }
}
