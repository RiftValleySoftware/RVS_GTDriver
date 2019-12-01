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
 
 if this is a Service separateor (
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
    let keyColumnID = NSUserInterfaceItemIdentifier("data-key")
    
    /* ################################################################## */
    /**
     Key for the "Value" column.
     */
    let valueColumnID = NSUserInterfaceItemIdentifier("data-value")
    
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
    // MARK: - Instance IBOutlets
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     The Table, Displaying the Properties.
     */
    @IBOutlet weak var propertyTable: NSTableView!
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
        
        var serviceHeader: RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple!
        var serviceProperties = [RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple]()
        
        if let deviceInstance = deviceInstance {
            for service in deviceInstance.services {
                serviceHeader = RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: service.uuid, value: "")
                for property in service.properties {
                    switch property.value {
                    case .stringValue(let value):
                        if let value = value {
                            serviceProperties.append(RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: property.uuid, value: value))
                        }
                        
                    case .intValue(let value):
                        if let value = value {
                            serviceProperties.append(RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: property.uuid, value: String(value)))
                        }
                        
                    case .floatValue(let value):
                        if let value = value {
                            serviceProperties.append(RVS_BTDriver_MacOS_Test_Harness_Device_ViewController_TableDataTuple(key: property.uuid, value: String(value)))
                        }
                        
                    default:
                        #if DEBUG
                            print("Unknown Value Type: \(String(describing: property.value))")
                        #endif
                        ()
                    }
                }
                
                if let header = serviceHeader,
                0 < serviceProperties.count {
                    tableData.append(header)
                    tableData += serviceProperties.sorted(by: { (a, b) -> Bool in
                        return a.key < b.key
                    })
                }
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
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if let modelTitle = deviceInstance?.modelName {
            title = modelTitle
        }
        propertyTable?.floatsGroupRows = true
        populateTable()
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
}

/* ################################################################################################################################## */
// MARK: - NSTableViewDelegate Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_MacOS_Test_Harness_Properties_ViewController: NSTableViewDelegate {
    /* ################################################################## */
    /**
     Called to indicate whether or not the row is a group header (indicated by no value).
     
     - parameters:
        - inTableView: The table instance.
        - isGroupRow: The 0-based Int index of the row.
     
     - returns: True, if this is a group header row.
     */
    func tableView(_ inTableView: NSTableView, isGroupRow inRow: Int) -> Bool {
        return tableData[inRow].value.isEmpty
    }
    
    /* ################################################################## */
    /**
     Called to provide a view to use for the cell.
     
     - parameters:
        - inTableView: The table instance.
        - viewFor: Container object for the column that holds the row.
        - row: 0-based Int, with the index of the row, within the column.
     
     - returns: A new view object, with the value, therein.
     */
    func tableView(_ inTableView: NSTableView, viewFor inTableColumn: NSTableColumn?, row inRow: Int) -> NSView? {
        // If we have a column, then we are a regular, two-part row.
        if  let column = inTableColumn,
            let cell = inTableView.makeView(withIdentifier: column.identifier, owner: nil) as? NSTableCellView {
            cell.textField?.isEditable = false
            cell.textField?.drawsBackground = true
            cell.textField?.textColor = NSColor.black
            cell.textField?.backgroundColor = (0 == inRow % 2) ? NSColor.clear : NSColor(red: 1, green: 1, blue: 1, alpha: 0.25)
            switch inTableColumn?.identifier {
            case keyColumnID:
                cell.textField?.stringValue = tableData[inRow].key
                cell.textField?.font = NSFont.boldSystemFont(ofSize: 10)
                cell.textField?.alignment = .right
            default:
                cell.textField?.stringValue = tableData[inRow].value
                cell.textField?.font = NSFont.systemFont(ofSize: 10)
            }
            return cell
        } else {    // Otherwise, we are a one-part header.
            let groupHeader = NSTextView()
            groupHeader.isEditable = false
            groupHeader.font = NSFont.boldSystemFont(ofSize: 12)
            groupHeader.alignment = .center
            groupHeader.string = tableData[inRow].key
            groupHeader.drawsBackground = true
            groupHeader.backgroundColor = NSColor.black
            groupHeader.textColor = NSColor.white
            return groupHeader
        }
    }
}
