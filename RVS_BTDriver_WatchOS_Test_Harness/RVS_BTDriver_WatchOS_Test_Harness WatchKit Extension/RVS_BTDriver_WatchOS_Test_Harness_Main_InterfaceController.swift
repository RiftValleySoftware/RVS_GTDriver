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
class RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController_TableRowController: NSObject {
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
class RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The string used to instantiate our table rows.
     */
    let rowIDString = "standard-row"
    
    /* ################################################################## */
    /**
     The ID for our settings push. Used to reset the driver.
     */
    let settingsSegueID = "settings-segue"
    
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a simple semaphore, to re-enable scanning.
     */
    var wasScanning = false
    
    /* ################################################################## */
    /**
     This is a simple semaphore, to indicate that the settings screen was called.
     */
    var settingsCalled = false
    
    /* ################################################################## */
    /**
     This is our instance of the actual BLE driver.
     */
    var driverInstance: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    var prefs = RVS_BTDriver_WatchOS_Test_Harness_Prefs()
    
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var noBTDisplay: WKInterfaceGroup!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var deviceDisplayTable: WKInterfaceTable!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var scanningButton: WKInterfaceSwitch!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var settingsButton: WKInterfaceButton!
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBAction func scanningButtonHit(_ inValue: Bool) {
        #if DEBUG
            print("Scanning Button Hit")
        #endif
        
        if inValue {
            driverInstance?.startScanning()
        } else {
            driverInstance?.stopScanning()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This establishes the driver instance, wiping out any old one.
     */
    func setUpDriver() {
        driverInstance = nil
        let queue: DispatchQueue! = prefs.useDifferentThread ? DispatchQueue.global() : nil
        driverInstance = RVS_BTDriver(delegate: self, queue: queue, allowDuplicatesInBLEScan: prefs.continuousScan, stayConnected: prefs.persistentConnections)
    }

    /* ################################################################## */
    /**
     Make sure the correct items are shown or hidden.
     */
    func setUpUI() {
        scanningButton.setTitle("SLUG-SCANNING".localizedVariant)
        let isBTAvailable = driverInstance?.isBTAvailable ?? false
        noBTDisplay.setHidden(isBTAvailable)
        deviceDisplayTable.setHidden(!isBTAvailable)
        scanningButton.setHidden(!isBTAvailable)
        scanningButton.setOn(driverInstance?.isScanning ?? false)
        populateTable()
    }
    
    /* ################################################################## */
    /**
     */
    func populateTable() {
        if  let driverInstance = driverInstance,
            driverInstance.isBTAvailable,
            0 < driverInstance.count {
            deviceDisplayTable.setNumberOfRows(driverInstance.count, withRowType: rowIDString)
            
            for index in 0..<driverInstance.count {
                if let deviceRow = self.deviceDisplayTable.rowController(at: index) as? RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController_TableRowController {
                    deviceRow.displayLabel.setText(driverInstance[index].modelName)
                }
            }
        } else {
            deviceDisplayTable.setNumberOfRows(0, withRowType: "")
        }
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setTitle("SLUG-MAIN".localizedVariant)
        wasScanning = false
        settingsCalled = true // We do this to force the driver to be set up the first time.
    }
    
    /* ################################################################## */
    /**
     */
    override func willActivate() {
        super.willActivate()
        
        if settingsCalled {
            setUpDriver()
            settingsCalled = false
        }
        
        setUpUI()
        
        if wasScanning {
            driverInstance?.startScanning()
            wasScanning = false
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func didDeactivate() {
        super.didDeactivate()
        driverInstance?.stopScanning()
        scanningButton.setOn(false)
    }
    
    /* ################################################################## */
    /**
     */
    override func contextForSegue(withIdentifier inSegueIdentifier: String, in inTable: WKInterfaceTable, rowIndex inRowIndex: Int) -> Any? {
        settingsCalled = false
        if let device = driverInstance?[inRowIndex] as? RVS_BTDriver_Device {
            wasScanning = driverInstance?.isScanning ?? false
            return device
        }
        return nil
    }
    
    /* ################################################################## */
    /**
     */
    override func contextForSegue(withIdentifier inSegueIdentifier: String) -> Any? {
        settingsCalled = false
        if settingsSegueID == inSegueIdentifier {
            settingsCalled = true
        }
        wasScanning = driverInstance?.isScanning ?? false
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController: RVS_BTDriverDelegate {
    /* ################################################################## */
    /**
     Simple error reporting method.
     
     - parameter inDriver: The `RVS_BTDriver` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func btDriver(_ inDriver: RVS_BTDriver, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("ERROR! \(String(describing: inError))")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when a new device is discovered while scanning.
     
     - parameter inDriver: The `RVS_BTDriver` instance that is calling this.
     - parameter newDeviceAdded: The new device instance.
     */
    func btDriver(_ inDriver: RVS_BTDriver, newDeviceAdded inDevice: RVS_BTDriver_DeviceProtocol) {
        #if DEBUG
            print("New Device Added: \(String(describing: inDevice))")
        #endif
        DispatchQueue.main.async {
            self.populateTable()
        }
    }
    
    /* ################################################################## */
    /**
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     */
    func btDriverStatusUpdate(_ inDriver: RVS_BTDriver) {
        #if DEBUG
            print("Status Message Received by Navigation Controller")
        #endif
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
}
