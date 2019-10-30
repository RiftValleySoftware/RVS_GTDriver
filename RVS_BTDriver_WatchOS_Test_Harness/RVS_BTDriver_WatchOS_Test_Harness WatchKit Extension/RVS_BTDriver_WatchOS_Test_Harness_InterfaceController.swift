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
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_WatchOS
#endif

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_InterfaceController_TableRow: WKInterfaceGroup {
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var displayLabel: WKInterfaceLabel!
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var settingsButton: WKInterfaceButton!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var noBTDisplay: WKInterfaceGroup!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var deviceDisplayTable: WKInterfaceTable!
    
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBAction func settingsButtonHit() {
        #if DEBUG
            print("Settings Button Hit")
        #endif
    }
    
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Make sure the correct items are shown or hidden.
        let isBTAvailable = RVS_BTDriver_WatchOS_Test_Harness_ExtensionDelegate.delegateObject?.driverInstance?.isBTAvailable ?? false
        noBTDisplay.setHidden(isBTAvailable)
        deviceDisplayTable.setHidden(!isBTAvailable)
    }
    
    /* ################################################################## */
    /**
     */
    override func willActivate() {
        super.willActivate()
    }
    
    /* ################################################################## */
    /**
     */
    override func didDeactivate() {
        super.didDeactivate()
    }

}
