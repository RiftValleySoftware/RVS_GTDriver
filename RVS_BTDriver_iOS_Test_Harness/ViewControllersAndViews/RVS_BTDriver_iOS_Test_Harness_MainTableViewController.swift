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
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_iOS
#endif

/* ###################################################################################################################################### */
// MARK: - Class for One Table Cell -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Test_Harness_MainTableViewController_TableViewCell: UITableViewCell {
    /// The device assigned to this cell.
    var device: RVS_BTDriver_DeviceProtocol!
    /// The label.
    @IBOutlet weak var displayLabel: UILabel!
}

/* ###################################################################################################################################### */
// MARK: - Main List Controller -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Test_Harness_MainTableViewController: RVS_BTDriver_iOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     The table cell prototype reuse ID
     */
    let cellReuseIDentifier = "device-cell"
    
    /* ################################################################## */
    /**
     The segue that will bring in a device details page.
     */
    let displaySegueID = "display-device"
    
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
    static let greenSelectedColor = UIColor(red: 0, green: 0.25, blue: 0, alpha: 1)

    /* ################################################################## */
    /**
     This is set to true, if the app was scanning before it segued.
     */
    internal var internal_wasScanning = false
    
    /* ################################################################## */
    /**
     This is set to true, if we need to completely reload the driver (after settings screen).
     */
    internal var internal_reload_driver = false
    
    /* ################################################################## */
    /**
     The image that we display if there is no Bluetooth available.
     */
    @IBOutlet weak var noBTImageView: UIImageView!
    
    /* ################################################################## */
    /**
     The container view for the controls and table, available if there is an active Bluetooth connection.
     */
    @IBOutlet weak var activeBTItemContainerView: UIView!
    
    /* ################################################################## */
    /**
     The table that displays discovered devices.
     */
    @IBOutlet weak var devicesTableView: UITableView!
    
    /* ################################################################## */
    /**
     The scanning/not scanning switch.
     */
    @IBOutlet weak var scanModeSegmentedSwitch: UISegmentedControl!
    
    /* ################################################################## */
    /**
     This is for subscriber support.
     */
    var uuid = UUID()
}

/* ###################################################################################################################################### */
// MARK: - IBAction Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController {
    /* ################################################################## */
    /**
     The scanning/not scanning switch changed.
     
     - parameter inSwitch: The switch instance.
     */
    @IBAction func scanModeSwitchChanged(_ inSwitch: UISegmentedControl) {
        if type(of: self).segmentedSwitchIsOnIndex == inSwitch.selectedSegmentIndex {
            driverInstance?.startScanning()
        } else {
            driverInstance?.stopScanning()
        }
        setup()
    }
    
    /* ################################################################## */
    /**
     This forces the driver to reset after changing settings.
     */
    @IBAction func unwindToThisViewController(segue inSegue: UIStoryboardSegue) {
        assert(self == inSegue.destination, "The segue is not aimed at us!")
        
        // If the settings changed, the driver needs to be completely reset.
        if inSegue.source is RVS_BTDriver_iOS_Test_Harness_SettingsViewController {
            mainNavController.setUpDriver()
            devicesTableView.reloadData()
        }
        
        // As you were...
        if internal_wasScanning {
            driverInstance.startScanning()
        }
        
        internal_wasScanning = false
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController: RVS_BTDriverDelegate {
    func btDriver(_ driver: RVS_BTDriver, encounteredThisError: RVS_BTDriver.Errors) {
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_DeviceSubscriberProtocol Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController: RVS_BTDriver_DeviceSubscriberProtocol {
    func device(_ device: RVS_BTDriver_DeviceProtocol, encounteredThisError: RVS_BTDriver.Errors) {
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     - parameter inTableView: The table view that called this.
     - parameter numberOfRowsInSection: An integer, with the 0-based section (always 0).
     - returns: The number of rows (number of devices).
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int {
        // Make sure that we are the delegate for all devices.
        for device in driverInstance {
            device.subscribe(self)
        }
        
        return driverInstance?.count ?? 0
    }
    
    /* ################################################################## */
    /**
     Called to create a cell instance to populate a table cell.
     
     - parameter inTableView: The table view that called this.
     - parameter cellForRowAt: An IndexPath to the selected cell that needs populating.
     - returns: A newly-created cell instance.
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        guard let cell = inTableView.dequeueReusableCell(withIdentifier: cellReuseIDentifier) as? RVS_BTDriver_iOS_Test_Harness_MainTableViewController_TableViewCell else { return UITableViewCell() }
        if  let device = self.driverInstance?[inIndexPath.row],
            let model = device.modelName?.localizedVariant {
            DispatchQueue.main.async {
                cell.device = device
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
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController: UITableViewDelegate {
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
        let device = driverInstance?[inIndexPath.row]
        performSegue(withIdentifier: displaySegueID, sender: device)
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
        if  inEditingStyle == UITableViewCell.EditingStyle.delete,
            let driver = driverInstance {
            driverInstance.removeDevice(driver[inIndexPath.row])
            inTableView.reloadData()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Base Class Override Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController {
    /* ################################################################## */
    /**
     Called after the view has completely loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        mainNavController.setUpDriver()
        navigationItem.title = navigationItem.title?.localizedVariant
        // We set up the localized strings for the segmented control.
        for i in 0..<scanModeSegmentedSwitch.numberOfSegments {
            scanModeSegmentedSwitch.setTitle(scanModeSegmentedSwitch.titleForSegment(at: i)?.localizedVariant, forSegmentAt: i)
        }
    }
    
    /* ################################################################## */
    /**
     Called just before the view is to lay out its various subviews.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setup()
    }
    
    /* ################################################################## */
    /**
     This is called when we are about to dismiss the screen.
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        if internal_reload_driver {
            mainNavController.setUpDriver()
            devicesTableView.reloadData()
            internal_wasScanning = false
        }
        
        // As you were...
        if internal_wasScanning {
            driverInstance.startScanning()
        }
        
        internal_reload_driver = false
        internal_wasScanning = false
    }

    /* ################################################################## */
    /**
     This is called as we prepare to open the device inspector screen. We use it to associate the device instance with the screen.
     
     - parameter for: The segue object.
     - parameter sender: The context we attached to the segue (the device object).
     */
    override func prepare(for inSegue: UIStoryboardSegue, sender inSender: Any?) {
        if  let destination = inSegue.destination as? RVS_BTDriver_iOS_Test_Harness_DetailViewController,
            let device = inSender as? RVS_BTDriver_DeviceProtocol {
            internal_wasScanning = driverInstance.isScanning
            destination.device = device
        // If we are going into the settings screen, we always stop scanning completely, and reload the driver when we come back.
        } else if inSegue.destination is RVS_BTDriver_iOS_Test_Harness_SettingsViewController {
            internal_reload_driver = true
        }
        
        internal_wasScanning = driverInstance.isScanning
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_MainTableViewController {
    /* ################################################################## */
    /**
     Sets up the UI Items.
     */
    func setup() {
        noBTImageView?.isHidden = driverInstance?.isBTAvailable ?? false    // This is the "No Bluetooth" image.
        // In case there is no bluetooth service available, we can hide most of the stuff.
        activeBTItemContainerView.isHidden = !(driverInstance?.isBTAvailable ?? false)
        if driverInstance?.isBTAvailable ?? false {
            scanModeSegmentedSwitch.selectedSegmentIndex = driverInstance?.isScanning ?? false ? type(of: self).segmentedSwitchIsOnIndex : type(of: self).segmentedSwitchIsOffIndex
            // iOS 13 uses a different property to affect the tint color.
            if #available(iOS 13.0, *) {
                scanModeSegmentedSwitch.selectedSegmentTintColor = driverInstance?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
                // White text.
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: driverInstance?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor], for: .normal)
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            } else {
                let textColor = driverInstance?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
                scanModeSegmentedSwitch.tintColor = driverInstance?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
            }
            devicesTableView?.reloadData()
        }
    }
}
