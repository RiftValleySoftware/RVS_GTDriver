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
// MARK: - Table Cell View
/* ################################################################################################################################## */
/**
 This view will be used for each table cell.
 */
class RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewControllerTableCellView: NSTableCellView {
    /* ################################################################## */
    /**
     The instantiation ID
    */
    static let storyboardID = "property-display"
    
    /* ################################################################## */
    /**
     The UUID
    */
    @IBOutlet weak var keyLabel: NSTextField!

    /* ################################################################## */
    /**
     The value
    */
    @IBOutlet weak var valueLabel: NSTextField!
    
    /* ################################################################## */
    /**
     The properties of the characteristic
    */
    @IBOutlet weak var propertiesLabel: NSTextField!
}

/* ################################################################################################################################## */
/**
 This is a handy typealias for the tuple we'll use to transmit table data.
 
 if this is a Service separateor (
 */
typealias RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple = (key: String, value: String, read: Bool, write: Bool, indicate: Bool, notify: Bool)

/* ################################################################################################################################## */
// MARK: - The Detail View Controller Class for Each Device
/* ################################################################################################################################## */
/**
 */
class RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Static Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is the storyboard instantiation ID.
    */
    static let storyboardID = "details-view-controller"

    /* ################################################################## */
    /**
     This is the device instance associated with this screen.
    */
    var deviceInstance: RVS_BTDriver_OBD_DeviceProtocol!

    /* ################################################################## */
    /**
     The cancel button that dismisses the screen.
    */
    @IBOutlet weak var cancelButton: NSButton!
    
    /* ################################################################## */
    /**
     The table that displays the property state.
    */
    @IBOutlet weak var propertyTable: NSTableView!
    
    /* ################################################################## */
    /**
     This is the data that is to be displayed by the table.
    */
    var tableData: [RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple] = []
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI elements.
     */
    func setUpUI() {
        if let modelTitle = deviceInstance?.deviceName {
            title = modelTitle
        }
        populateTable()
    }
    
    /* ################################################################## */
    /**
     Sets up the table data.
     */
    func setUpTableData() {
        tableData = []
        
        if let deviceInstance = deviceInstance {
            if let deviceName = deviceInstance.deviceName {
                let key = String(format: "SLUG-DEVICE-NAME-FORMAT".localizedVariant, deviceName)
                tableData.append(RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: key, value: "", read: false, write: false, indicate: false, notify: false))
            }
            
            for service in deviceInstance.services {
                let serviceHeader = RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: service.uuid, value: "", read: false, write: false, indicate: false, notify: false)
                var serviceProperties = [RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple]()

                for property in service.properties {
                    let key = property.uuid
                    
                    switch property.value {
                    case .intValue(let value):
                        if let value = value {
                            serviceProperties.append(RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: key, value: String(value), read: property.canRead, write: property.canWrite, indicate: property.canIndicate, notify: property.canNotify))
                        }
                        
                    case .floatValue(let value):
                        if let value = value {
                            serviceProperties.append(RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: key, value: String(value), read: property.canRead, write: property.canWrite, indicate: property.canIndicate, notify: property.canNotify))
                        }
                        
                    case .stringValue(let value):
                        if  let value = value,
                            !value.isEmpty {
                            serviceProperties.append(RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: key, value: value, read: property.canRead, write: property.canWrite, indicate: property.canIndicate, notify: property.canNotify))
                        } else {
                            fallthrough
                        }
                        
                    default:
                        #if DEBUG
                            print("Unknown Value Type: \(String(describing: property.value))")
                        #endif
                        serviceProperties.append(RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController_TableDataTuple(key: key, value: "UNKNOWN VALUE", read: property.canRead, write: property.canWrite, indicate: property.canIndicate, notify: property.canNotify))
                    }
                }
                
                if 0 < serviceProperties.count {
                    tableData.append(serviceHeader)
                    tableData += serviceProperties.sorted(by: { (a, b) -> Bool in
                        return a.key.lengthOfBytes(using: .utf8) == b.key.lengthOfBytes(using: .utf8) ? a.key < b.key : a.key.lengthOfBytes(using: .utf8) < b.key.lengthOfBytes(using: .utf8)
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
        propertyTable?.tableColumns.forEach {
            $0.headerCell.stringValue = $0.headerCell.stringValue.localizedVariant
            $0.headerCell.font = NSFont.boldSystemFont(ofSize: 10)
            $0.headerCell.alignment = .center
        }
        setUpTableData()
        propertyTable?.reloadData()
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton?.title = (cancelButton?.title ?? "ERROR").localizedVariant
        setUpUI()
    }
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController: NSTableViewDelegate {
    /* ################################################################## */
    /**
     Called to supply the view for a row.
     
     - parameters:
        - inTableView: The table instance.
        - viewFor: The column object.
        - row: The 0-based index of the row.
     */
    func tableView(_ inTableView: NSTableView, viewFor inColumn: NSTableColumn?, row inRow: Int) -> NSView? {
        if tableView(inTableView, isGroupRow: inRow) { // If we are a header...
            let ret = NSTextView()
            ret.string = tableData[inRow].key.localizedVariant
            ret.backgroundColor = NSColor.black
            ret.textColor = NSColor.white
            ret.font = NSFont.boldSystemFont(ofSize: 14)
            ret.alignment = .center
            return ret
        } else {
            if let ret = inTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewControllerTableCellView.storyboardID), owner: nil) as? RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewControllerTableCellView {
                ret.keyLabel.stringValue = tableData[inRow].key.localizedVariant
                var leadingBlank = false
                if tableData[inRow].key == deviceInstance?.readProperty?.uuid ?? "" {
                    if !leadingBlank {
                        ret.keyLabel.stringValue += " "
                        leadingBlank = true
                    }
                    ret.keyLabel.stringValue += "SLUG-READ-PROPERTY".localizedVariant
                }
                
                if tableData[inRow].key == deviceInstance?.writeProperty?.uuid ?? "" {
                    if !leadingBlank {
                        ret.keyLabel.stringValue += " "
                    }
                    ret.keyLabel.stringValue += "SLUG-WRITE-PROPERTY".localizedVariant
                }
                
                ret.valueLabel.stringValue = tableData[inRow].value
                var stringArray = [String]()
                if tableData[inRow].read {
                    stringArray.append("SLUG-READ".localizedVariant)
                }
                if tableData[inRow].write {
                    stringArray.append("SLUG-WRITE".localizedVariant)
                }
                if tableData[inRow].indicate {
                    stringArray.append("SLUG-INDICATE".localizedVariant)
                }
                if tableData[inRow].notify {
                    stringArray.append("SLUG-NOTIFY".localizedVariant)
                }
                ret.propertiesLabel.stringValue = stringArray.joined(separator: ", ")
                return ret
            }
        }
        
        return nil
    }
    
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
     Returns the height of a given row.
     
     - parameters:
        - inTableView: The table instance.
        - heightOfRow: The 0-based Int index of the row.
     
     - returns: The height, in display units, of the row.
     */
    func tableView(_ inTableView: NSTableView, heightOfRow inRow: Int) -> CGFloat {
        if  !tableView(inTableView, isGroupRow: inRow),
            let ret = inTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewControllerTableCellView.storyboardID), owner: nil) as? RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewControllerTableCellView {
            return ret.bounds.size.height
        } else {
            return inTableView.rowHeight
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - NSTableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController: NSTableViewDataSource {
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
