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

/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var noBTImageView: NSImageView!

    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = self
        setUpUI()
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.setUpDriver()   // Once we load, then we ask the app delegate to establish the driver, so we can react (We need to have the view loaded before getting callbacks).
    }
    
    /* ################################################################## */
    /**
     */
    deinit {
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = nil
    }
    
    /* ################################################################## */
    /**
     */
    func setUpUI() {
        noBTImageView.isHidden = isBTAvailable
    }
}
