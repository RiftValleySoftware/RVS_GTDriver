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

#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_WatchOS
#endif

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    var prefs = RVS_BTDriver_WatchOS_Test_Harness_Prefs()
    
    /* ################################################################## */
    /**
     */
    var deviceInstance: RVS_BTDriver_Device!
    
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
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func awake(withContext inContext: Any?) {
        super.awake(withContext: inContext)
        deviceInstance = inContext as? RVS_BTDriver_Device
        setTitle(deviceInstance?.modelName?.localizedVariant)
    }
    
    /* ################################################################## */
    /**
     */
    override func willActivate() {
        super.willActivate()
        displayLabel?.setText(deviceInstance?.description)
    }
    
    /* ################################################################## */
    /**
     */
    override func didDeactivate() {
        super.didDeactivate()
    }
}
