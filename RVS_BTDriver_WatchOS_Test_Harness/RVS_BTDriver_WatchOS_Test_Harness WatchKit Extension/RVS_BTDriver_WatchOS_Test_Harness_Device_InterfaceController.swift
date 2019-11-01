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
typealias RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple = (key: String, value: String)

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController: WKInterfaceController {
    var owner: RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var deletePromptLabel: WKInterfaceLabel!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var yesButton: WKInterfaceButton!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var noButton: WKInterfaceButton!
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController {
    /* ################################################################## */
    /**
     */
    @IBAction func yesButtonHit() {
        #if DEBUG
            print("Delete Yes Hit")
        #endif
        
        owner?.deleteMyself()
        
        dismiss()
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func noButtonHit() {
        #if DEBUG
            print("Delete No Hit")
        #endif
        
        dismiss()
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController {
    /* ################################################################## */
    /**
     */
    override func awake(withContext inContext: Any?) {
        super.awake(withContext: inContext)
        if let context = inContext as? RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
            owner = context
            setTitle(nil)   // This will cause the system "Cancel" to show. Redundant, but good to have.
            deletePromptLabel.setText("SLUG-DELETE-QUESTION".localizedVariant)
            yesButton.setTitle("SLUG-DELETE-YES".localizedVariant)
            noButton.setTitle("SLUG-DELETE-NO".localizedVariant)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_TableRowController: NSObject {
    /* ################################################################## */
    /**
     */
    static let rowID = "display-device-value"
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var keyLabel: WKInterfaceLabel!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var valueLabel: WKInterfaceLabel!
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    let deleteSegueID = "delete-segue"
    
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    var prefs = RVS_BTDriver_WatchOS_Test_Harness_Prefs()
    
    /* ################################################################## */
    /**
     */
    var deviceInstance: RVS_BTDriver_DeviceProtocol!
    
    /* ################################################################## */
    /**
     */
    var deviceData: [RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple] = []
    
    /* ################################################################## */
    /**
     */
    var owner: RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController!
    
    /* ################################################################## */
    /**
     A semaphore, indicating that this device was deleted, so we will dismiss as soon as we come into play.
     */
    var iOffedMyself = false
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var deletButton: WKInterfaceButton!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var displayTable: WKInterfaceTable!
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
    /* ################################################################## */
    /**
     */
    func deleteMyself() {
        if  let owner = owner,
            let deviceInstance = deviceInstance {
            #if DEBUG
                print("Deleting This Device")
            #endif
            owner.deleteDevice(deviceInstance)
            deviceData = [RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: "SLUG-DELETED".localizedVariant, value: "")]
            iOffedMyself = true
        }
    }
    
    /* ################################################################## */
    /**
     */
    func populateTable() {
        if  0 < deviceData.count {
            displayTable.setNumberOfRows(deviceData.count, withRowType: RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_TableRowController.rowID)
            
            for i in deviceData.enumerated() {
                if let deviceRow = self.displayTable.rowController(at: i.offset) as? RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_TableRowController {
                    deviceRow.keyLabel.setText(i.element.key)
                    deviceRow.valueLabel.setText(i.element.value)
                }
            }
        } else {
            displayTable.setNumberOfRows(0, withRowType: "")
        }
    }
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
    /* ################################################################################################################################## */
    // MARK: -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func awake(withContext inContext: Any?) {
        super.awake(withContext: inContext)
        if let context = inContext as? RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController_DeviceContext {
            iOffedMyself = false
            deviceInstance = context.device
            owner = context.owner
            setTitle(deviceInstance?.modelName?.localizedVariant)
            deletButton.setTitle("SLUG-DELETE".localizedVariant)
            deviceData = []
            if let manufacturerName = deviceInstance?.manufacturerName {
                let key = "deviceInfoManufacturerName".localizedVariant
                let value = manufacturerName
                let data = RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: key, value: value)
                deviceData.append(data)
            }
            
            if let modelName = deviceInstance?.modelName {
                let key = "deviceInfoModelName".localizedVariant
                let value = modelName
                let data = RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: key, value: value)
                deviceData.append(data)
            }
            
            if let hardwareRevision = deviceInstance?.firmwareRevision {
                let key = "deviceInfoHardwareRevision".localizedVariant
                let value = hardwareRevision
                let data = RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: key, value: value)
                deviceData.append(data)
            }
            
            if let firmwareRevision = deviceInstance?.firmwareRevision {
                let key = "deviceInfoFirmwareRevision".localizedVariant
                let value = firmwareRevision
                let data = RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: key, value: value)
                deviceData.append(data)
            }
            
            if let id = deviceInstance?.uuid {
                let key = "deviceInfoDeviceID".localizedVariant
                let value = id
                let data = RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: key, value: value)
                deviceData.append(data)
            }
            populateTable()
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func willActivate() {
        super.willActivate()
        if iOffedMyself {
            deletButton.setHidden(true) // We can't delete the deleted.
            populateTable()
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func didDeactivate() {
        super.didDeactivate()
        iOffedMyself = false
    }
    
    /* ################################################################## */
    /**
     */
    override func contextForSegue(withIdentifier inSegueIdentifier: String) -> Any? {
        if deleteSegueID == inSegueIdentifier {
            #if DEBUG
                print("Delete Button Hit")
            #endif
        }
        
        return self
    }
}
