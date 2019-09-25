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
#if !DIRECT
    import RVS_BLEDriver_iOS
#endif

/* ###################################################################################################################################### */
// MARK: - Single Table View Cell Class -
/* ###################################################################################################################################### */
/**
 Each row of the table is composed of an instance of this class.
 */
class RVS_BLEDriver_iOS_Test_Harness_MainViewController_TableViewCell: UITableViewCell {
    /* ################################################################## */
    /**
     The device associated with this cell.
     */
    var gtDevice: RVS_BLEDevice!
    
    /* ################################################################## */
    /**
     The label, displaying the device info.
     */
    @IBOutlet weak var displayLabel: UILabel!
}

/* ###################################################################################################################################### */
// MARK: - Main Window ViewController Class -
/* ###################################################################################################################################### */
/**
 The main window view controller class.
 
 It displays a table, with each row representing one discovered goTenna device.
 
 Selecting a row will open a view for that device (pushed onto the nav stack).
 */
class RVS_BLEDriver_iOS_Test_Harness_MainViewController: UIViewController, RVS_BLEDriver_iOS_Test_Harness_AppDelegateAccess {
    /* ################################################################################################################################## */
    // MARK: - Private Internal Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a semaphore that we use to remember whether or not we were in scanning mode when the view was last exited.
     */
    private var _wasScanning = false
    
    /* ################################################################## */
    /**
     Used to remember our old value of the use different thread pref.
     */
    private var _oldQueueVal: Bool = false
    
    /* ################################################################## */
    /**
     Used to remember our old value of the include duplicates.
     */
    private var _oldContinuousScan: Bool = false
    
    /* ################################################################## */
    /**
     Used to remember our old value of the persistent connection pref.
     */
    private var _oldPersistentConnections: Bool = false

    /* ################################################################################################################################## */
    // MARK: - Internal Static Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the reuse ID for creating new table cells.
     */
    static let reuseID = "DeviceRow"
    
    /* ################################################################## */
    /**
     This is the segue ID for showing device detail.
     */
    static let displaySegueID = "SelectDevice"
    
    /* ################################################################## */
    /**
     This is the index that indicates the segmented Switch is in "not scanning" mode.
     */
    static let segmentedSwitchIsOffIndex = 0
    
    /* ################################################################## */
    /**
     This is the index that indicates the segmented Switch is in "scanning" mode.
     */
    static let segmentedSwitchIsOnIndex = 1
    
    /* ################################################################## */
    /**
     The color to use for the segmented switch when not scanning.
     */
    static let redSelectedColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1)
    
    /* ################################################################## */
    /**
     The color to use for the segmented switch when scanning.
     */
    static let greenSelectedColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)

    /* ################################################################################################################################## */
    // MARK: - Internal IB Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the table that displays our available devices.
     */
    @IBOutlet weak var tableView: UITableView!
    
    /* ################################################################## */
    /**
     The segmented control that selects scanning or not scanning.
     */
    @IBOutlet weak var scanningSegmentedControl: UISegmentedControl!
    
    /* ################################################################## */
    /**
     The image that is displayed if there is no bluetooth available.
     */
    @IBOutlet weak var noBTImageView: UIImageView!
    
    /* ################################################################################################################################## */
    // MARK: - Internal Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     These represent the persistent state.
     */
    let prefs = RVS_BLEDriver_iOS_Test_Harness_Prefs()
    
    /* ################################################################## */
    /**
     The driver object that is the basis for this whole circus.
     */
    var gtDriver: RVS_BLEDriver!
}

/* ###################################################################################################################################### */
// MARK: - Instance IBAction Handlers -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Called when the user changes the value of the segmented switch.
     
     - parameter: ignored.
     */
    @IBAction func scanningStateChanged(_: UISegmentedControl) {
        gtDriver?.isScanning = type(of: self).segmentedSwitchIsOnIndex == scanningSegmentedControl.selectedSegmentIndex
        setUpUI()
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Sets up the UI to match the state.
     */
    func setUpUI() {
        // In case there is no bluetooth service available, we can hide most of the stuff, and display a "S.O.L." image.
        noBTImageView.isHidden = gtDriver?.isBluetoothAvailable ?? false
        tableView.isHidden = !(gtDriver?.isBluetoothAvailable ?? false)
        scanningSegmentedControl.isHidden = !(gtDriver?.isBluetoothAvailable ?? false)
        if gtDriver?.isBluetoothAvailable ?? false {
            scanningSegmentedControl.selectedSegmentIndex = gtDriver?.isScanning ?? false ? type(of: self).segmentedSwitchIsOnIndex : type(of: self).segmentedSwitchIsOffIndex
            // iOS 13 uses a different property to affect the tint color.
            if #available(iOS 13.0, *) {
                scanningSegmentedControl.selectedSegmentTintColor = gtDriver?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
                // White text.
                scanningSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: gtDriver?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor], for: .normal)
                scanningSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            } else {
                let textColor = gtDriver?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor
                scanningSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
                scanningSegmentedControl.tintColor = gtDriver?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
            }
            tableView?.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     Sets up our driver.
     */
    func setUpDriver() {
        #if DEBUG
            print("Setting Up Driver:")
            print("\tDifferent Thread is \(prefs.useDifferentThread ? "" : "not ")on.")
            print("\tContinuous Scan is \(prefs.continuousScan ? "" : "not ")on.\n")
            print("\tPersistent Connections is \(prefs.persistentConnections ? "" : "not ")on.\n")
        #endif
        _oldQueueVal = prefs.useDifferentThread
        _oldContinuousScan = prefs.continuousScan
        _oldPersistentConnections = prefs.persistentConnections
        // Create our driver instance.
        gtDriver = RVS_BLEDriver(delegate: self, queue: prefs.useDifferentThread ? DispatchQueue.global() : nil, allowDuplicatesInBLEScan: prefs.continuousScan, stayConnected: prefs.persistentConnections)
    }
    
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     - parameter inTableView: The table view that called this.
     - parameter numberOfRowsInSection: An integer, with the 0-based section (always 0).
     - returns: The number of rows (number of devices).
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int {
        // Make sure that we are the delegate for all devices.
        for device in gtDriver {
            device.delegate = self
        }
        return gtDriver?.count ?? 0
    }
    
    /* ################################################################## */
    /**
     Called to create a cell instance to populate a table cell.
     
     - parameter inTableView: The table view that called this.
     - parameter cellForRowAt: An IndexPath to the selected cell that needs populating.
     - returns: A newly-created cell instance.
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        guard let cell = inTableView.dequeueReusableCell(withIdentifier: type(of: self).reuseID) as? RVS_BLEDriver_iOS_Test_Harness_MainViewController_TableViewCell else { return UITableViewCell() }
        if let device = self.gtDriver?[inIndexPath.row] {
            let model = device.modelNumber.localizedVariant
            DispatchQueue.main.async {
                cell.gtDevice = device
                cell.displayLabel.text = model
                // This just gives us some stripes, so we can see the different rows.
                cell.backgroundColor = (0 == inIndexPath.row % 2) ? UIColor.clear : UIColor.white.withAlphaComponent(0.25)
            }
        }
        return cell
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController: UITableViewDelegate {
    /* ################################################################## */
    /**
     This is called when someone taps on a row.
     
     We bring in the inspector for that device, and deselect the row.
     
     - parameter inTableView: The table view that called this.
     - parameter willSelectRowAt: An IndexPath to the selected row.
     - returns: An IndexPath, if the row is to remain selected and highlighted. It is always false, and we immediately deselect the row, anyway.
     */
    func tableView(_ inTableView: UITableView, willSelectRowAt inIndexPath: IndexPath) -> IndexPath? {
        inTableView.deselectRow(at: inIndexPath, animated: false)    // Make sure to deselect the row, right away.
        let device = gtDriver?[inIndexPath.row]
        performSegue(withIdentifier: type(of: self).displaySegueID, sender: device)
        return nil
    }
    
    /* ################################################################## */
    /**
     Indicate that a row can be edited (for left-swipe delete).
     
     - parameter inTableView: The table view being checked
     - parameter canEditRowAt: The indexpath of the row to be checked.
     
     - returns: true, always.
     */
    func tableView(_ inTableView: UITableView, canEditRowAt inIndexPath: IndexPath) -> Bool {
        return true
    }
    
    /* ################################################################## */
    /**
     Called to do a delete action.
     
     - parameter inTableView: The table view being checked
     - parameter commit: The action to perform.
     - parameter forRowAt: The indexpath of the row to be deleted.
     */
    func tableView(_ inTableView: UITableView, commit inEditingStyle: UITableViewCell.EditingStyle, forRowAt inIndexPath: IndexPath) {
        if inEditingStyle == UITableViewCell.EditingStyle.delete {
            gtDriver[inIndexPath.row].deleteThisDevice()   // We'll delete it when we get the callback.
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Called when the view is first loaded.
     */
    override func viewDidLoad() {
        // We deliberately set these different, to force a new driver instance.
        _oldQueueVal = !prefs.useDifferentThread
        _oldContinuousScan = !prefs.continuousScan
        _oldPersistentConnections = !prefs.persistentConnections
        navigationItem.backBarButtonItem?.title = navigationItem.backBarButtonItem?.title?.localizedVariant ?? "ERROR"
        // We set up the localized strings for the segmented control.
        for i in 0..<scanningSegmentedControl.numberOfSegments {
            scanningSegmentedControl.setTitle(scanningSegmentedControl.titleForSegment(at: i)?.localizedVariant, forSegmentAt: i)
        }
    }
    
    /* ################################################################## */
    /**
     Make sure that the navbar is hidden for the main view.
     
     - parameter inAnimated: Ignored, but sent to the superclass.
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        navigationController?.isNavigationBarHidden = true
        gtDriver?.isScanning = _wasScanning
        _wasScanning = false
        if _oldQueueVal != prefs.useDifferentThread || _oldContinuousScan != prefs.continuousScan || _oldPersistentConnections != prefs.persistentConnections {
            setUpDriver()
        }
        setUpUI()
    }
    
    /* ################################################################## */
    /**
     This is called as we prepare to open the device inspector screen. We use it to associate the device instance with the screen.
     
     - parameter for: The sgue object.
     - parameter sender: The context we attached to the segue (the device object).
     */
    override func prepare(for inSegue: UIStoryboardSegue, sender inSender: Any?) {
        _wasScanning = gtDriver?.isScanning ?? false
        gtDriver?.isScanning = false
        guard   let destination = inSegue.destination as? RVS_BLEDriver_iOS_Test_Harness_Device_ViewController,
                let device = inSender as? RVS_BLEDevice else { return }
        destination.gtDevice = device
        setUpUI()
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDriverDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController: RVS_BLEDriverDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by the main driver.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDriver(_ inDriver: RVS_BLEDriver, errorEncountered inError: RVS_BLEDriver.Errors) {
        #if DEBUG
            print("ERROR: \(String(describing: inError))")
        #endif
        displayError(inError.localizedDescription.localizedVariant)
    }
    
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    func gtDriver(_ inDriver: RVS_BLEDriver, newDeviceAdded inDevice: RVS_BLEDevice) {
        // All we need to do, is tell the table to reload itself.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object. It will not be viable after this call.
     */
    func gtDriver(_ inDriver: RVS_BLEDriver, deviceWasRemoved inDevice: RVS_BLEDevice) {
        // All we need to do, is tell the table to reload itself.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.

     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The driver instance calling this.
     */
    func gtDriverStatusUpdate(_ driver: RVS_BLEDriver) {
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BLEDeviceDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_BLEDriver_iOS_Test_Harness_MainViewController: RVS_BLEDeviceDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance that experienced the error.
     - parameter errorEncountered: The error encountered.
     */
    public func gtDevice(_ inDevice: RVS_BLEDevice, errorEncountered inError: RVS_BLEDriver.Errors) {
        #if DEBUG
            print("ERROR: \(String(describing: inError))")
        #endif
        displayError(inError.localizedDescription.localizedVariant)
    }
}