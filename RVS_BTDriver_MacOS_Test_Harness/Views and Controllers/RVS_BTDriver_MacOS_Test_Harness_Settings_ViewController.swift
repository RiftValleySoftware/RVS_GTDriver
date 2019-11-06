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

/* ################################################################################################################################## */
// MARK: - The Settings Screen View Controller Class
/* ################################################################################################################################## */
/**
 This class controls the main listing screen (the one that displays a list of devices).
 */
class RVS_BTDriver_MacOS_Test_Harness_Settings_ViewController: RVS_BTDriver_MacOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var useDifferentQueueCheckbox: NSButton!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var rescanCheckbox: NSButton!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var persistentConnectionCheckbox: NSButton!
}

/* ################################################################################################################################## */
// MARK: - IBAction Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Settings_ViewController {
    /* ################################################################## */
    /**
     Called when any of the checkboxes change.
     
     When a change is made, we reset the driver.
     
     - parameter: Ignored.
     */
    @IBAction func checkboxChanged(_: Any) {
        #if DEBUG
            print("Checkbox changed state, so we are resetting the driver")
        #endif
        appDelegateObject.setUpDriver()
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Settings_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.title = view.window?.title.localizedVariant ?? "ERROR"
        useDifferentQueueCheckbox?.title = useDifferentQueueCheckbox?.title.localizedVariant ?? "ERROR"
        rescanCheckbox?.title = rescanCheckbox?.title.localizedVariant ?? "ERROR"
        persistentConnectionCheckbox?.title = persistentConnectionCheckbox?.title.localizedVariant ?? "ERROR"
    }
}
