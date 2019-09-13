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

import Cocoa
import RVS_GTDriver

@NSApplicationMain
/* ###################################################################################################################################### */
// MARK: - Main App Delegate Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_GTDriver_MacOS_Test_Harness_AppDelegate: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Internal Class Functions
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This displays a simple alert, with an OK button.
     
     - parameter header: The header to display at the top.
     - parameter message: A String, containing whatever messge is to be displayed below the header.
     */
    class func displayAlert(header inHeader: String, message inMessage: String = "") {
        let alert = NSAlert()
        alert.messageText = inHeader
        alert.informativeText = inMessage
        alert.addButton(withTitle: "SLUG-OK-BUTTON-TEXT".localizedVariant)
        alert.runModal()
    }
}

/* ###################################################################################################################################### */
// MARK: - NSApplicationDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_MacOS_Test_Harness_AppDelegate: NSApplicationDelegate {
    /* ################################################################## */
    /**
     Called when the application has completed launching.
     
     - parameter inNotification: The notification object that accompanied the launch.
     */
    func applicationDidFinishLaunching(_ inNotification: Notification) {
    }

    /* ################################################################## */
    /**
     Called when the application is about to terminate.
     
     - parameter inNotification: The notification object that accompanied the call.
     */
    func applicationWillTerminate(_ inNotification: Notification) {
    }
}
