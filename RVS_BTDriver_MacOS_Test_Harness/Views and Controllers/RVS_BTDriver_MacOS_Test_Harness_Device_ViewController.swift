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

typealias RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple = (key: String, value: String)

/* ################################################################################################################################## */
// MARK: - The Device Screen View Controller Class
/* ################################################################################################################################## */
/**
 This class controls the device info listing screen (the one that displays a list of device information).
 */
class RVS_BTDriver_MacOS_Test_Harness_Device_ViewController: RVS_BTDriver_MacOS_Test_Harness_Base_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Instance Constants
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     Key for the "Key" column.
     */
    let keyColumnID = "data-key"

    /* ################################################################## */
    /**
     Key for the "Value" column.
     */
    let valueColumnID = "data-value"

    /* ############################################################################################################################## */
    // MARK: - Instance Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The device instance, associated with this screen.
     */
    var deviceInstance: RVS_BTDriver_DeviceProtocol!
    
    /* ################################################################## */
    /**
     This is an Array of tuples, used to populate the table.
     
     The reason that this is an Array of tuples, is so we can enforce order without using a stupid key-sorting closure.
     */
    var tableData = [RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple]()

    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_DeviceSubscriberProtocol Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is a UUID, that identifies this screen for subscriber puproses.
     */
    var uuid = UUID()
    
    /* ############################################################################################################################## */
    // MARK: - Instance IBOutlets
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The Connect/Disconnect button.
     */
    @IBOutlet weak var connectDisconnectButton: NSButton!

    /* ################################################################## */
    /**
     The Delete button.
     */
    @IBOutlet weak var deleteButton: NSButtonCell!
    
    /* ################################################################## */
    /**
     The Table, Displaying the Properties.
     */
    @IBOutlet weak var propertyTable: NSTableView!
    
    /* ################################################################## */
    /**
     Make sure that we clean up after ourselves.
     */
    deinit {
        deviceInstance?.unsubscribe(self)
    }
}

/* ################################################################################################################################## */
// MARK: - IBAction Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Device_ViewController {
    /* ################################################################## */
    /**
     Called when the Connect/Disconnect button is hit.
     
     - parameter: ignored.
     */
    @IBAction func connectDisconnectHit(_: Any) {
        #if DEBUG
            print("\(((deviceInstance?.isConnected ?? false) ? "SLUG-DISCONNECT".localizedVariant : "SLUG-CONNECT".localizedVariant)) Button Hit.")
        #endif
        
        // The weird test here, is so that we don't send true to a nonexistent device. Doesn't really matter, as we're using a chained optional.
        deviceInstance?.isConnected = !(deviceInstance?.isConnected ?? true)
    }

    /* ################################################################## */
    /**
     Called when the Delete button is hit.
     
     - parameter: ignored.
     */
    @IBAction func deleteButtonHit(_: Any) {
        #if DEBUG
            print("DELETE Button Hit.")
        #endif
    }
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Device_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI to reflect the current state.
     */
    func setUpUI() {
        connectDisconnectButton?.title = ((deviceInstance?.isConnected ?? false) ? "SLUG-DISCONNECT".localizedVariant : "SLUG-CONNECT".localizedVariant)
        connectDisconnectButton?.contentTintColor = ((deviceInstance?.isConnected ?? false) ? NSColor.red : NSColor.green)
        populateTable()
    }
    
    /* ################################################################## */
    /**
     Sets up the table data.
     */
    func setUpTableData() {
        tableData = []
        
        if let deviceInstance = deviceInstance {
            if let value = deviceInstance.uuid {
                let dataItem = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: "deviceInfoDeviceID".localizedVariant, value: value)
                tableData.append(dataItem)
            }
            
            if let value = deviceInstance.manufacturerName {
                let dataItem = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: "deviceInfoManufacturerName".localizedVariant, value: value)
                tableData.append(dataItem)
            }
            
            if let value = deviceInstance.modelName {
                let dataItem = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: "deviceInfoModelName".localizedVariant, value: value)
                tableData.append(dataItem)
            }
            
            if let value = deviceInstance.hardwareRevision {
                let dataItem = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: "deviceInfoHardwareRevision".localizedVariant, value: value)
                tableData.append(dataItem)
            }
            
            if let value = deviceInstance.firmwareRevision {
                let dataItem = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: "deviceInfoFirmwareRevision".localizedVariant, value: value)
                tableData.append(dataItem)
            }
        }
    }
    
    /* ################################################################## */
    /**
     Sets up the table.
     */
    func populateTable() {
        setUpTableData()
        propertyTable?.reloadData()
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Device_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        if let modelTitle = deviceInstance?.modelName {
            title = modelTitle
        }
        
        deleteButton?.title = deleteButton.title.localizedVariant
        deleteButton?.backgroundColor = NSColor.red
        setUpUI()
        
        deviceInstance?.subscribe(self)
    }
}

/* ################################################################################################################################## */
// MARK: - NSTableViewDataSource Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Device_ViewController: NSTableViewDataSource {
    /* ################################################################## */
    /**
     Called to supply the number of rows in the table.
     
     - parameters:
        - inTableView: The table instance.
     
     - returns: A 1-based Int, with 0 being no rows.
     */
    func numberOfRows(in inTableView: NSTableView) -> Int {
        return tableData.count
    }

    /* ################################################################## */
    /**
     This is called to supply the string display for one row that corresponds to a device.
     
     - parameters:
        - inTableView: The table instance.
        - viewFor: Container object for the column that holds the row.
        - row: 0-based Int, with the index of the row, within the column.
     
     - returns: A new Text View, with the device model name.
     */
    func tableView(_ inTableView: NSTableView, objectValueFor inTableColumn: NSTableColumn?, row inRow: Int) -> Any? {
        switch inTableColumn?.identifier.rawValue {
        case keyColumnID:
            return tableData[inRow].key
        default:
            return tableData[inRow].value
        }
    }
}

/* ################################################################################################################################## */
// MARK: - RVS_BTDriver_DeviceSubscriberProtocol Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Device_ViewController: RVS_BTDriver_DeviceSubscriberProtocol {
    /* ################################################################## */
    /**
     */
    func device(_ inDevice: RVS_BTDriver_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("DEVICE ERROR! \(String(describing: inError))")
        #endif
        RVS_BTDriver_MacOS_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
    }
    
    /* ################################################################## */
    /**
     */
    func deviceStatusUpdate(_ inDevice: RVS_BTDriver_DeviceProtocol) {
        #if DEBUG
            print("Device Status Changed")
        #endif
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
}
