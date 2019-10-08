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
// MARK: - Settings Screen View Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_BLEDriver_iOS_Test_Harness_SettingsViewController: UIViewController {
    /* ################################################################## */
    /**
     These represent the persistent state.
     */
    let prefs = RVS_BLEDriver_iOS_Test_Harness_Prefs()
    
    /* ################################################################## */
    /**
     This is the switch that controls the "Use A Different Thread" pref.
     */
    @IBOutlet weak var threadSwitch: UISwitch!
    
    /* ################################################################## */
    /**
     This is a button that acts like a label, but allows the switch to toggle like a Web control.
     */
    @IBOutlet weak var threadToggleButton: UIButton!
    
    /* ################################################################## */
    /**
     This is the switch that controls the "Show Duplicates In Scans" pref.
     */
    @IBOutlet weak var scanSwitch: UISwitch!
    
    /* ################################################################## */
    /**
     This is a button that acts like a label, but allows the switch to toggle like a Web control.
     */
    @IBOutlet weak var scanToggleButton: UIButton!
    
    /* ################################################################## */
    /**
     This is the persistent connections prefs switch.
     */
    @IBOutlet weak var persistentConnectionsSwitch: UISwitch!

    /* ################################################################## */
    /**
     This is the toggle value button for the persistent connections switch.
     */
    @IBOutlet weak var persistentConnectionsToggleButton: UIButton!
    
    /* ################################################################## */
    /**
     Called when the thread switch changes state.
     */
    @IBAction func threadSwitchChanged(_ inSwitch: UISwitch) {
        prefs.useDifferentThread = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     Called when the scan switch changes state.
     */
    @IBAction func scanSwitchChanged(_ inSwitch: UISwitch) {
        prefs.continuousScan = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func persistentConnectionsSwitchChanged(_ inSwitch: UISwitch) {
        prefs.persistentConnections = inSwitch.isOn
    }

    /* ################################################################## */
    /**
     Called when the label/button is tapped. It toggles the state of the pref (and the switch).
     */
    @IBAction func threadSwitchToggle(_ inButton: UIButton) {
        prefs.useDifferentThread = !prefs.useDifferentThread
        threadSwitch.setOn(prefs.useDifferentThread, animated: true)
    }
    
    /* ################################################################## */
    /**
     Called when the label/button is tapped. It toggles the state of the pref (and the switch).
     */
    @IBAction func scanSwitchToggle(_ inButton: UIButton) {
        prefs.continuousScan = !prefs.continuousScan
        scanSwitch.setOn(prefs.continuousScan, animated: true)
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func peristentConnectionsToggleButtonHit(_ sender: Any) {
        prefs.persistentConnections = !prefs.persistentConnections
        persistentConnectionsSwitch.setOn(prefs.persistentConnections, animated: true)
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_SettingsViewController {
    /* ################################################################## */
    /**
     Make sure that we display the navbar.
     
     - parameter inAnimated: Ignored, but sent to the superclass.
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = navigationItem.title?.localizedVariant
        threadToggleButton.setTitle(threadToggleButton.title(for: .normal)?.localizedVariant, for: .normal)
        scanToggleButton.setTitle(scanToggleButton.title(for: .normal)?.localizedVariant, for: .normal)
        persistentConnectionsToggleButton.setTitle(persistentConnectionsToggleButton.title(for: .normal)?.localizedVariant, for: .normal)
        threadSwitch.isOn = prefs.useDifferentThread
        scanSwitch.isOn = prefs.continuousScan
        persistentConnectionsSwitch.isOn = prefs.persistentConnections
    }
}
