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
import RVS_GTDriver_iOS

/* ###################################################################################################################################### */
// MARK: - Single Table View Cell Class -
/* ###################################################################################################################################### */
/**
 Each row of the table is composed of an instance of this class.
 */
class RVS_GTDriver_iOS_Test_Harness_MainViewController_TableViewCell: UITableViewCell {
    /* ################################################################## */
    /**
     The device associated with this cell.
     */
    var gtDevice: RVS_GTDevice!
    
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
class RVS_GTDriver_iOS_Test_Harness_MainViewController: UIViewController {
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
    static let greenSelectedColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)

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
    
    /* ################################################################################################################################## */
    // MARK: - Internal Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The driver object that is the basis for this whole circus.
     */
    var gtDriver: RVS_GTDriver!
}

/* ###################################################################################################################################### */
// MARK: - Instance IBAction Handlers -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Called when the user changes the value of the segmented switch.
     
     - parameter: ignored.
     */
    @IBAction func scanningStateChanged(_: UISegmentedControl) {
        gtDriver.isScanning = type(of: self).segmentedSwitchIsOnIndex == scanningSegmentedControl.selectedSegmentIndex
        setUpUI()
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Sets up the UI to match the state.
     */
    func setUpUI() {
        scanningSegmentedControl.selectedSegmentIndex = gtDriver.isScanning ? type(of: self).segmentedSwitchIsOnIndex : type(of: self).segmentedSwitchIsOffIndex
        // iOS 13 uses a different property to affect the tint color.
        if #available(iOS 13.0, *) {
            scanningSegmentedControl.selectedSegmentTintColor = gtDriver.isScanning ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
            // White text.
            scanningSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        } else {
            let textColor = gtDriver.isScanning ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor
            scanningSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
            scanningSegmentedControl.tintColor = gtDriver.isScanning ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
        }
        tableView?.reloadData()
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     - parameter inTableView: The table view that called this.
     - parameter numberOfRowsInSection: An integer, with the 0-based section (always 0).
     - returns: The number of rows (number of devices).
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int {
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
        guard let cell = inTableView.dequeueReusableCell(withIdentifier: type(of: self).reuseID) as? RVS_GTDriver_iOS_Test_Harness_MainViewController_TableViewCell else { return UITableViewCell() }
        cell.gtDevice = gtDriver[inIndexPath.row]
        return cell
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController: UITableViewDelegate {
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
        let device = gtDriver[inIndexPath.row]
        performSegue(withIdentifier: type(of: self).displaySegueID, sender: device)
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController {
    override func viewDidLoad() {
        gtDriver = RVS_GTDriver(delegate: self)
        // We set up the localized strings for the segmented control.
        for i in 0..<scanningSegmentedControl.numberOfSegments {
            scanningSegmentedControl.setTitle(scanningSegmentedControl.titleForSegment(at: i)?.localizedVariant, forSegmentAt: i)
        }
        setUpUI()
    }
    
    /* ################################################################## */
    /**
     Make sure that the navbar is hidden for the main view.
     
     - parameter inAnimated: Ignored, but sent to the superclass.
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        navigationController?.isNavigationBarHidden = true
    }
    
    /* ################################################################## */
    /**
     This is called as we prepare to open the device inspector screen. We use it to associate the device instance with the screen.
     
     - parameter for: The sgue object.
     - parameter sender: The context we attached to the segue (the device object).
     */
    override func prepare(for inSegue: UIStoryboardSegue, sender inSender: Any?) {
        guard   let destination = inSegue.destination as? RVS_GTDriver_iOS_Test_Harness_Device_ViewController,
                let device = inSender as? RVS_GTDevice else { return }
        destination.gtDevice = device
        gtDriver.isScanning = false
        setUpUI()
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDriverDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController: RVS_GTDriverDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by the main driver.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDriver(_ inDriver: RVS_GTDriver, errorEncountered inError: Error) {
        
    }
    
    /* ################################################################## */
    /**
     Called when a device has been added and instantiated.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter newDeviceAdded: The device object.
     */
    func gtDriver(_ inDriver: RVS_GTDriver, newDeviceAdded inDevice: RVS_GTDevice) {
        // All we need to do, is tell the table to reload itself.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object.
     */
    func gtDriver(_ inDriver: RVS_GTDriver, deviceWillBeRemoved inDevice: RVS_GTDevice) {
    }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDriver: The driver instance calling this.
     - parameter deviceWillBeRemoved: The device object. It will not be viable after this call.
     */
    func gtDriver(_ inDriver: RVS_GTDriver, deviceWasRemoved inDevice: RVS_GTDevice) {
        // All we need to do, is tell the table to reload itself.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
