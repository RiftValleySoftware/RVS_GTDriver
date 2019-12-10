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

/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
 This view controller manages the main device selection screen.
 */
class RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     This is KVO
     
     - returns: true, if all of the vendor interfaces have Bluetooth powered on.
     */
    @objc dynamic public var isScanning: Bool {
        get {
            return driverInstance?.isScanning ?? false
        }
        
        set {
            if let driverInstance = driverInstance {
                if newValue {
                    driverInstance.startScanning()
                } else {
                    driverInstance.stopScanning()
                }
            }
        }
    }

    /* ################################################################## */
    /**
     This is the image that is displayed if there is no bluetooth available.
     */
    @IBOutlet weak var noBTImageView: NSImageView!

    /* ################################################################## */
    /**
     This is the checkbox that reflects the scanning state.
     */
    @IBOutlet weak var scanningCheckbox: NSButton!
    
    /* ################################################################## */
    /**
     This is the image that is displayed if there is no bluetooth available.
     */
    @IBOutlet weak var deviceTableView: NSTableView!
    
    /* ################################################################## */
    /**
     This will hold a selected device, for presentation to the user. It is ephemeral.
     */
    var selectedDevice: RVS_BTDriver_DeviceProtocol!

    /* ################################################################## */
    /**
     Called when we're going away. This needs to be in the main declaration area. You can't have it in extensions.
     */
    deinit {
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Superclass Overrides -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Called when the view has completed loading.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        scanningCheckbox.title = scanningCheckbox.title.localizedVariant
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.mainViewController = self
        setUpUI()
        RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.setUpDriver()   // Once we load, then we ask the app delegate to establish the driver, so we can react (We need to have the view loaded before getting callbacks).
    }
}

/* ###################################################################################################################################### */
// MARK: - Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     This just sets up the UI to match the current driver state.
     */
    func setUpUI() {
        noBTImageView.isHidden = isBTAvailable
        deviceTableView.isHidden = !isBTAvailable
        scanningCheckbox.isHidden = !isBTAvailable
        deviceTableView?.reloadData()
    }
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: NSTableViewDelegate {
    /* ################################################################## */
    /**
     This is called when a row is selected. We match the device to the row, set that in the semaphore, and approve the selection.
     
     - parameters:
        - inTableView: The table instance.
        - shouldSelectRow: 0-based Int, with the index of the row, within the column.
     
     - returns: False (always).
     */
    func tableView(_ inTableView: NSTableView, shouldSelectRow inRow: Int) -> Bool {
        if  let device = driverInstance?[inRow] {
            #if DEBUG
                print("Row \(inRow) was selected.")
            #endif
            selectedDevice = device
            return true
        }
        
        selectedDevice = nil
        return false
    }
    
    /* ################################################################## */
    /**
     This is called to supply the string display for one row that corresponds to a device.
     
     - parameters:
        - inTableView: The table instance.
        - objectValueFor: Container object for the column that holds the row.
        - row: 0-based Int, with the index of the row, within the column.
     
     - returns: A new String, with the device name.
     */
    func tableView(_ inTableView: NSTableView, objectValueFor inTableColumn: NSTableColumn?, row inRow: Int) -> Any? {
        if  let device = driverInstance?[inRow],
            let name = device.deviceName {
            return name
        }
        
        return "NO DEVICE NAME"
    }

    /* ################################################################## */
    /**
     Called after the selection was set up and approved.
     
     We open a modal window, with the device info.
     
     - parameter: Ignored
     */
    func tableViewSelectionDidChange(_: Notification) {
        selectedDevice = nil
        deviceTableView.deselectAll(nil)
    }
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_Mac_Test_Harness_ViewController: NSTableViewDataSource {
    /* ################################################################## */
    /**
     Called to supply the number of rows in the table.
     
     - parameters:
        - inTableView: The table instance.
     
     - returns: A 1-based Int, with 0 being no rows.
     */
    func numberOfRows(in inTableView: NSTableView) -> Int {
        return driverInstance?.count ?? 0
    }
}