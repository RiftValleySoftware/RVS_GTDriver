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
 This view controller manages the main device selection screen.
 */
class RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     This is the image that is displayed if there is no bluetooth available.
     */
    @IBOutlet weak var noBTImageView: NSImageView!
    
    /* ################################################################## */
    /**
     This is the image that is displayed if there is no bluetooth available.
     */
    @IBOutlet weak var deviceTableView: NSTableView!
    /* ################################################################## */
    /**
     Called when we're going away. This needs to be in the main declaration area. You can't have it in extensions.
     */
    deinit {
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Superclass Overrides -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Called when the view has completed loading.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = self
        setUpUI()
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.setUpDriver()   // Once we load, then we ask the app delegate to establish the driver, so we can react (We need to have the view loaded before getting callbacks).
    }
}

/* ###################################################################################################################################### */
// MARK: - Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     This just sets up the UI to match the current driver state.
     */
    func setUpUI() {
        noBTImageView.isHidden = isBTAvailable
        deviceTableView.isHidden = !isBTAvailable
    }
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: NSTableViewDelegate {
    
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: NSTableViewDataSource {
    
}
