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
/**
 This is a handy typealias for the tuple we'll use to transmit table data.
 */
typealias RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController_TableDataTuple = (key: String, value: String)

/* ################################################################################################################################## */
// MARK: - The Device Screen View Controller Class
/* ################################################################################################################################## */
/**
 This class controls the properties info listing screen (the one that displays a list of individual properties).
 */
class RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController: RVS_BTDriver_MacOS_Test_Harness_Base_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Static Constants
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The Storyboard ID for this class.
     */
    static let storyboardID = "properties-inspector-controller"
    
    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_ServiceSubscriberProtocol Support
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This will be used to hold an automatically-generated UUID for this subscriber.
     */
    var _uuid: UUID!
    
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
    
    /* ################################################################## */
    /**
     The "OK" button was hit by the user in the delete confirm.
     */
    let modalResponseOK = 1000

    /* ############################################################################################################################## */
    // MARK: - Instance Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The service instance, associated with this screen.
     */
    var serviceInstance: RVS_BTDriver_ServiceProtocol!

    /* ################################################################## */
    /**
     This is an Array of tuples, used to populate the table.
     
     The reason that this is an Array of tuples, is so we can enforce order without using a stupid key-sorting closure.
     */
    var tableData = [RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple]()
    
    /* ############################################################################################################################## */
    // MARK: - Instance IBOutlets
    /* ############################################################################################################################## */
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
        serviceInstance?.unsubscribe(self)
    }
}

/* ################################################################################################################################## */
// MARK: - IBAction Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController {
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI to reflect the current state.
     */
    func setUpUI() {
        populateTable()
    }
    
    /* ################################################################## */
    /**
     Sets up the table data.
     */
    func setUpTableData() {
        tableData = []
    }
    
    /* ################################################################## */
    /**
     Called to remove the device from the driver.
     */
    func deleteMyself() {
        DispatchQueue.main.async {
            self.appDelegateObject.mainDisplayScreen.reloadTable()
            self.dismiss(nil)
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
    
    /* ################################################################## */
    /**
     This displays a simple alert, with an OK button.
     */
    func displayDeleteConfirmAlert() {
        if let window = view.window {
            let alert = NSAlert()
            alert.messageText = "SLUG-DELETE-CONFIRM-HEADER".localizedVariant
            alert.informativeText = "SLUG-DELETE-CONFIRM-TEXT".localizedVariant
            alert.alertStyle = .warning
            alert.addButton(withTitle: "SLUG-OK-BUTTON-TEXT".localizedVariant)
            alert.addButton(withTitle: "SLUG-CANCEL-BUTTON-TEXT".localizedVariant)
            alert.beginSheetModal(for: window) { [weak self] (_ inModalResponse: NSApplication.ModalResponse) in
                if self?.modalResponseOK == inModalResponse.rawValue {
                    #if DEBUG
                        print("The User Chose to Delete.")
                    #endif
                    self?.deleteMyself()
                } else {
                    #if DEBUG
                        print("Deletion will not Occur (\(inModalResponse)).")
                    #endif
                }
            }
        }
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

/* ################################################################################################################################## */
// MARK: - NSTableViewDataSource Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController: NSTableViewDataSource {
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
// MARK: - RVS_BTDriver_ServiceSubscriberProtocol Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController: RVS_BTDriver_ServiceSubscriberProtocol {
    /* ################################################################## */
    /**
     Called if the service adds a new property.
     
     - inService: The service instance that is calling this.
     - propertyAdded: The property that was added.
     */
    func service(_ inService: RVS_BTDriver_ServiceProtocol, propertyAdded inProperty: RVS_BTDriver_PropertyProtocol) {
    }
    
    /* ################################################################## */
    /**
     Called if the service encounters an error.
     
     - parameters:
        - inService: The service instance that is calling this.
        - encounteredThisError: The error that is being returned.
     */
    func service(_ inService: RVS_BTDriver_ServiceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("SERVICE ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
            RVS_BTDriver_MacOS_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
    
    /* ################################################################## */
    /**
     Called if the service state changes, in some way.
     
     - inService: The service instance that is calling this.
     */
    func serviceStatusUpdate(_ inDevice: RVS_BTDriver_ServiceProtocol) {
        #if DEBUG
            print("Service Status Changed")
        #endif
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
}
