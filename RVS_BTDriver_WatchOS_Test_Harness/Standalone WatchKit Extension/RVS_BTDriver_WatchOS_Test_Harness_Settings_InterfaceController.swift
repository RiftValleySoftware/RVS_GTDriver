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

/* ###################################################################################################################################### */
// MARK: - The Settings Class
/* ###################################################################################################################################### */
/**
 This class controls the display of the settings screen.
 */
class RVS_BTDriver_WatchOS_Test_Harness_Settings_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: - Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    var prefs = RVS_BTDriver_WatchOS_Test_Harness_Prefs()

    /* ################################################################################################################################## */
    // MARK: - IBOutlet Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a switch that reflects and controls whether or not the driver will be set up to use a non-main thread. True means that it uses the Global Thread.
     */
    @IBOutlet weak var useDifferentThreadSwitch: WKInterfaceSwitch!
    
    /* ################################################################## */
    /**
     This is a switch that reflects and controls whether the scan will "discover" the device, even if it has been removed. If false, then removing a device -even while scanning- will cause it to remain removed until scanning is toggled again.
     */
    @IBOutlet weak var rescanSwitch: WKInterfaceSwitch!
    
    /* ################################################################## */
    /**
     This is a switch that reflects and controls whether or not the initial connection (to get device info) is retained, so the device remains in connected state. If true, then the connection will remain on. If false, the connection is terminated just after reading the info.
     */
    @IBOutlet weak var persistentConnectionSwitch: WKInterfaceSwitch!
}

/* ###################################################################################################################################### */
// MARK: - IBAction Handler Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Settings_InterfaceController {
    /* ################################################################## */
    /**
     This is called when the Use Different Thread switch is toggled.
     
     - parameters:
        - inValue: The new value of the switch.
     */
    @IBAction func useDifferentThreadSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Use Different Thread Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.useDifferentThread = inValue
    }
    
    /* ################################################################## */
    /**
     This is called when the Rescan switch is toggled.
     
     - parameters:
        - inValue: The new value of the switch.
     */
    @IBAction func rescanSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Rescan Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.continuousScan = inValue
    }
    
    /* ################################################################## */
    /**
     This is called when the Persistent Connection switch is toggled.
     
     - parameters:
        - inValue: The new value of the switch.
     */
    @IBAction func persistentConnectionSwitchHit(_ inValue: Bool) {
        #if DEBUG
            print("The Use Persistent Connection Preference is now \(inValue ? "ON" : "OFF")")
        #endif
        prefs.persistentConnections = inValue
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Settings_InterfaceController {
    /* ################################################################## */
    /**
     Called when the sheet is loaded.
     
     - parameters:
        - withContext: The context that may have been set by the presenting view controller.
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
}
