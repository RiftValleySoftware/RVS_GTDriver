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
// MARK: - Main Navigation Controller -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Test_Harness_NavigationController: UINavigationController {
    /* ################################################################## */
    /**
     */
    var driverInstance: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverInstance = RVS_BTDriver(self)
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverDelegate Support -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_iOS_Test_Harness_NavigationController: RVS_BTDriverDelegate {
    func driver(_ inDriver: RVS_BTDriver, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("Error Message Received by Navigation Controller: \(inError.localizedDescription)")
        #endif
    }
}
