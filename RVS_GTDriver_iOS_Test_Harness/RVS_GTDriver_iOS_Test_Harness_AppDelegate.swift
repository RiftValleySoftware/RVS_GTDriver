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

import UIKit
import RVS_GTDriver_iOS

@UIApplicationMain
/* ###################################################################################################################################### */
// MARK: - Main App Delegate Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_GTDriver_iOS_Test_Harness_AppDelegate: UIResponder, UIApplicationDelegate {
    
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
    }
    
    /* ############################################################################################################################## */
    // MARK: - Internal Class Calculated Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is a quick way to get this object instance (it's a SINGLETON), cast as the correct class.
     
     - returns: the app delegate object, in its natural environment.
     */
    class var appDelegateObject: RVS_GTDriver_iOS_Test_Harness_AppDelegate {
        return (UIApplication.shared.delegate as? RVS_GTDriver_iOS_Test_Harness_AppDelegate)!
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The driver object that is the basis for this whole circus.
     */
    var gtDriver: RVS_GTDriver!
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        gtDriver = RVS_GTDriver(delegate: self)
        return true
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDriverDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_AppDelegate: RVS_GTDriverDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by the main driver.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDriver(_ inDriver: RVS_GTDriver, errorEncountered inError: Error) {
        
    }

    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance that experienced the error.
     - parameter errorEncountered: The error encountered.
     */
    func gtDevice(_ inDevice: RVS_GTDevice, errorEncountered inError: Error) {
        
    }
}
