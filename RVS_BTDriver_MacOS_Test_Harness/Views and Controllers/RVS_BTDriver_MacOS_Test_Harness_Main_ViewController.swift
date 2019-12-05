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
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_MacOS
#endif

/* ################################################################################################################################## */
// MARK: - The Main Screen View Controller Class
/* ################################################################################################################################## */
/**
 This class controls the main listing screen (the one that displays a list of devices).
 */
class RVS_BTDriver_MacOS_Test_Harness_Main_ViewController: RVS_BTDriver_MacOS_Test_Harness_Base_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Instance Constants
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The column ID for the device name.
     */
    let deviceNameID = "device-name"
    
    /* ################################################################## */
    /**
     The column ID for the "Is Connected" text.
     */
    let isConnectedID = "device-connected"

    /* ################################################################## */
    /**
     This will hold a selected device, for presentation to the user. It is ephemeral.
     */
    var selectedDevice: RVS_BTDriver_DeviceProtocol!
    
    /* ############################################################################################################################## */
    // MARK: - IB Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The checkbox for "scanning" state.
     */
    @IBOutlet weak var scanningCheckbox: NSButton!
    
    /* ################################################################## */
    /**
     The "No Bluetooth" image.
     */
    @IBOutlet weak var noBTImage: NSImageView!
    
    /* ################################################################## */
    /**
     A table, containing rows for the discovered devices.
     */
    @IBOutlet weak var deviceListTable: NSTableView!
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Main_ViewController {
    /* ################################################################## */
    /**
     Simply forces the table to reload.
     */
    func reloadTable() {
        selectedDevice = nil
        deviceListTable?.reloadData()
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Main_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegateObject.mainDisplayScreen = self  // We register with the app delegate, so it can reload our table when it gets device updates.
        view.window?.title = view.window?.title.localizedVariant ?? "ERROR"
        scanningCheckbox?.title = scanningCheckbox?.title.localizedVariant ?? "ERROR"
    }
}

/* ################################################################################################################################## */
// MARK: - NSTableViewDelegate/DataSource Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Main_ViewController: NSTableViewDelegate, NSTableViewDataSource {
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

    /* ################################################################## */
    /**
     This is called to supply the string display for one row that corresponds to a device.
     
     - parameters:
        - inTableView: The table instance.
        - objectValueFor: Container object for the column that holds the row.
        - row: 0-based Int, with the index of the row, within the column.
     
     - returns: A String, with the device name.
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
     Called after the selection was set up and approved.
     
     We open a modal window, with the device info.
     
     - parameter: Ignored
     */
    func tableViewSelectionDidChange(_: Notification) {
        if  let device = selectedDevice,
            let newController = storyboard?.instantiateController(withIdentifier: RVS_BTDriver_MacOS_Test_Harness_Device_ViewController.storyboardID) as? RVS_BTDriver_MacOS_Test_Harness_Device_ViewController {
            newController.deviceInstance = device
            presentAsModalWindow(newController)
        }
        
        selectedDevice = nil
        deviceListTable.deselectAll(nil)
    }
    
    /* ################################################################## */
    /**
     */
    func setup() {
        noBTImage?.isHidden = driverInstance.isBTAvailable
        deviceListTable?.isHidden = !driverInstance.isBTAvailable
        scanningCheckbox?.isHidden = !driverInstance.isBTAvailable
        reloadTable()
    }
}
