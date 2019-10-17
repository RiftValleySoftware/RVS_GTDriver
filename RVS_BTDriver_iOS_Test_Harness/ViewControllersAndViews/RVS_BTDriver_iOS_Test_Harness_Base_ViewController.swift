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
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_iOS
#endif

/* ###################################################################################################################################### */
// MARK: - Main ViewController Base Class -
/* ###################################################################################################################################### */
/**
 This is a common base class for our navigation-managed view controllers.
 */
class RVS_BTDriver_iOS_Test_Harness_Base_ViewController: UIViewController {
}

/* ###################################################################################################################################### */
// MARK: - Internal Calculated Properties -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     Simple cast of our navigation controller to the proper class.
     */
    var mainNavController: RVS_BTDriver_iOS_Test_Harness_NavigationController! {
        return navigationController as? RVS_BTDriver_iOS_Test_Harness_NavigationController
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     Simply puts up an alert, with the given error's `localizedDescription`, localized, as the message.
     
     - parameter inError: The error to be displayed.
     */
    internal func reportError(_ inError: Error) {
        mainNavController?.displayAlert("SLUG-ERROR-HEADER", message: inError.localizedDescription.localizedVariant, presentedBy: self)
    }
}
