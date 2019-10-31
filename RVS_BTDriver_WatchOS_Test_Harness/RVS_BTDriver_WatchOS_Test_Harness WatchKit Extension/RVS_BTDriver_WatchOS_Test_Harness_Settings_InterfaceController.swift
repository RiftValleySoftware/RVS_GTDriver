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
class RVS_BTDriver_WatchOS_Test_Harness_Settings_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    var prefs = RVS_BTDriver_WatchOS_Test_Harness_Prefs()

    /* ################################################################## */
    /**
     */
    @IBOutlet weak var useDifferentThreadSwitch: WKInterfaceSwitch!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var rescanSwitch: WKInterfaceSwitch!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var persistentConnectionSwitch: WKInterfaceSwitch!

    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBAction func useDifferentThreadSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Use Different Thread Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.useDifferentThread = inValue
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func rescanSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Rescan Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.continuousScan = inValue
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func persistentConnectionSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Use Persistent Connection Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.persistentConnections = inValue
    }
    
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Make sure the correct items are shown or hidden.
     */
    func setUpUI() {
        useDifferentThreadSwitch.setTitle("SLUG-DIFFERENT-QUEUE".localizedVariant)
    }

    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func awake(withContext inContext: Any?) {
        super.awake(withContext: inContext)
        setTitle("SLUG-SETTINGS".localizedVariant)
        useDifferentThreadSwitch.setTitle("SLUG-DIFFERENT-QUEUE".localizedVariant)
        rescanSwitch.setTitle("SLUG-FULL-SCAN".localizedVariant)
        persistentConnectionSwitch.setTitle("SLUG-PERSISTENT-CONNECTIONS".localizedVariant)
        
        useDifferentThreadSwitch.setOn(prefs.useDifferentThread)
        rescanSwitch.setOn(prefs.continuousScan)
        persistentConnectionSwitch.setOn(prefs.persistentConnections)
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
