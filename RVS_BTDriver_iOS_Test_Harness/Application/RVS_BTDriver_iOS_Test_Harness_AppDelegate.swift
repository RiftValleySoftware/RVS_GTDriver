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

/* ###################################################################################################################################### */
// MARK: - Main Application Delegate -
/* ###################################################################################################################################### */
/**
 */
@UIApplicationMain
class RVS_BTDriver_iOS_Test_Harness_AppDelegate: UIResponder, UIApplicationDelegate {
    /// The window instance.
    var window: UIWindow?
    
    /* ################################################################## */
    /**
     Quick access to the app delegate object.
     */
    class var appDelegateObject: RVS_BTDriver_iOS_Test_Harness_AppDelegate! {
        return UIApplication.shared.delegate as? RVS_BTDriver_iOS_Test_Harness_AppDelegate
    }
    
    /* ################################################################## */
    /**
     Called after the application has set itself up.
     
     - parameter inApplication: A reference to the application instance.
     - parameter didFinishLaunchingWithOptions: The launch option set.
     
     - returns: false, if you want to abort the launch. True, otherwise.
     */
    func application(_ inApplication: UIApplication, didFinishLaunchingWithOptions inLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
