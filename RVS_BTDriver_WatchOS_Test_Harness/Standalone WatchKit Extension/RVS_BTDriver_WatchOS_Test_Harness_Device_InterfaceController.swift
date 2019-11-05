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
import Foundation

#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_WatchOS
#endif

/* ###################################################################################################################################### */
// MARK: - The Key/Value Type
/* ###################################################################################################################################### */
/**
 This is a simple key/value tuple type that we use for our display.
 
 - properties:
    - key: A String, with the localized key of the value.
    - value: A String, with the value to display.
 */
typealias RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple = (key: String, value: String)

/* ###################################################################################################################################### */
// MARK: - The Delete Confirmation Screen Controller
/* ###################################################################################################################################### */
/**
 This handles the "Delete" confirmation screen.
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: - Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the presenting view controller.
     
     We use this to send the delete call up the chain.
     */
    var owner: RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController!
    
    /* ################################################################################################################################## */
    // MARK: - IBOutlet Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The lable for the "DELETE?" question.
     */
    @IBOutlet weak var deletePromptLabel: WKInterfaceLabel!
    
    /* ################################################################## */
    /**
     The "YES" button.
     */
    @IBOutlet weak var yesButton: WKInterfaceButton!
    
    /* ################################################################## */
    /**
     The "NO" button.
     */
    @IBOutlet weak var noButton: WKInterfaceButton!
}

/* ###################################################################################################################################### */
// MARK: - IBAction Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController {
    /* ################################################################## */
    /**
     Called when the "YES" button is hit.
     
     This deletes the device, and closes the screen.
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
     Called when the "NO" button is hit.
     
     This cancels the screen with no changes.
     */
    @IBAction func noButtonHit() {
        #if DEBUG
            print("Delete No Hit")
        #endif
        
        dismiss()
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DeleteConfirmController {
    /* ################################################################## */
    /**
     Called when the instance is being initialized for use.
     
     - parameters:
        - inContext: The context (We ignore, but pass it to the base class).
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
// MARK: - The Device Info Display Single Table Row Controller
/* ###################################################################################################################################### */
/**
 This class defines one row of the table that displays the values.
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_TableRowController: NSObject {
    /* ################################################################################################################################## */
    // MARK: - Static Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The row ID for this class.
     */
    static let rowID = "display-device-value"
    
    /* ################################################################################################################################## */
    // MARK: - IBOutlet Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The label for the value key.
     */
    @IBOutlet weak var keyLabel: WKInterfaceLabel!
    
    /* ################################################################## */
    /**
     The label for the value.
     */
    @IBOutlet weak var valueLabel: WKInterfaceLabel!
}

/* ###################################################################################################################################### */
// MARK: - The Device Info Display Screen Controller
/* ###################################################################################################################################### */
/**
 This displays the information for one device.
 */
class RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    // MARK: - Instance Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The ID of the delete segue
     */
    let deleteSegueID = "delete-segue"
    
    /* ################################################################################################################################## */
    // MARK: - Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    var prefs = RVS_BTDriver_Test_Harness_Prefs()
    
    /* ################################################################## */
    /**
     This is a reference to the device from the driver.
     */
    var deviceInstance: RVS_BTDriver_DeviceProtocol!
    
    /* ################################################################## */
    /**
     This is an Array of key/value tuples, representing the data to be displayed.
     */
    var deviceData: [RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple] = []
    
    /* ################################################################## */
    /**
     This refers to our presenting controller. We use this to kick the delete command back up the chain.
     */
    var owner: RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController!
    
    /* ################################################################## */
    /**
     A semaphore, indicating that this device was deleted, so we will dismiss as soon as we come into play.
     */
    var iOffedMyself = false
    
    /* ################################################################################################################################## */
    // MARK: - IBOutlet Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The table, displaying the values.
     */
    @IBOutlet weak var displayTable: WKInterfaceTable!

    /* ################################################################## */
    /**
     The Delete Button, shown at the bottom of the screen.
     */
    @IBOutlet weak var deletButton: WKInterfaceButton!
}

/* ###################################################################################################################################### */
// MARK: - Instance Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
    /* ################################################################## */
    /**
     Called by the delete screen, to delete this device.
     */
    func deleteMyself() {
        if  let owner = owner,
            let deviceInst = deviceInstance {
            #if DEBUG
                print("Deleting This Device")
            #endif
            owner.deleteDevice(deviceInst)
            deviceData = [RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController_DisplayStringTuple(key: "SLUG-DELETED".localizedVariant, value: "")]
            iOffedMyself = true
            deviceInstance = nil
        }
    }
    
    /* ################################################################## */
    /**
     Called to set up the table of values.
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
// MARK: - Overridden Base Class Methods
/* ###################################################################################################################################### */
extension RVS_BTDriver_WatchOS_Test_Harness_Device_InterfaceController {
    /* ################################################################## */
    /**
     Called when the sheet is loaded.
     
     - parameters:
        - withContext: The context that may have been set by the presenting view controller.
     */
    override func awake(withContext inContext: Any?) {
        super.awake(withContext: inContext)
        if let context = inContext as? RVS_BTDriver_WatchOS_Test_Harness_Main_InterfaceController_DeviceContext {
            iOffedMyself = false
            deviceInstance = context.device
            owner = context.owner
            setTitle(deviceInstance?.modelName?.localizedVariant)
            deletButton.setTitle("SLUG-DELETE".localizedVariant)
            
            // We need to make sure that the various items we will use to populate the sheet are actually present in the device instance.
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
     Called just before the screen is shown.
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
     Called just after the screen disappears.
     */
    override func didDeactivate() {
        super.didDeactivate()
        iOffedMyself = false
    }
    
    /* ################################################################## */
    /**
     This is called just as a segue to the delete screen is called.
     
     - parameters:
        - withIdentifier: The segue ID. It should always be for the delete screen.
     */
    override func contextForSegue(withIdentifier inSegueIdentifier: String) -> Any? {
        assert(deleteSegueID == inSegueIdentifier, "The segue ID is not the expected one!")
        
        #if DEBUG
            print("Delete Button Hit")
        #endif
        
        return self
    }
}
