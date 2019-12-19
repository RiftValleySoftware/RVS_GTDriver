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
// MARK: - The Base (Common) View Controller Class for Each Device
/* ################################################################################################################################## */
/**
 */
class RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Static Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is the storyboard instantiation ID.
    */
    static let storyboardID = "device-view-controller"

    /* ################################################################## */
    /**
     This is the device instance associated with this screen.
    */
    var deviceInstance: RVS_BTDriver_OBD_DeviceProtocol!
    
    /* ################################################################## */
    /**
     The label for the enter text field.
    */
    @IBOutlet weak var enterTextLabel: NSTextField!
    
    /* ################################################################## */
    /**
     The text entry field, where the user types in the command.
    */
    @IBOutlet weak var enterTextField: NSTextField!
    
    /* ################################################################## */
    /**
     the button the user presses to send the command.
    */
    @IBOutlet weak var sendTextButton: NSButton!
    
    /* ################################################################## */
    /**
     The label for the response display.
    */
    @IBOutlet weak var responseDisplayLabel: NSTextField!

    /* ################################################################## */
    /**
     The text view portion of the scrollable area for the response.
    */
    @IBOutlet var responseTextView: NSTextView!
    
    /* ################################################################## */
    /**
     This is the button that calls out the details modal screen.
    */
    @IBOutlet weak var detailsCalloutButton: NSButton!
}

/* ################################################################################################################################## */
// MARK: - NSTextFieldDelegate Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController: NSTextFieldDelegate {
    /* ################################################################## */
    /**
     Called when text changes in the send text box.
     
     - parameter inNotification: The notification object for the text field.
    */
    func controlTextDidChange(_ inNotification: Notification) {
        if  let textField = inNotification.object as? NSTextField,
            textField == enterTextField {
            #if DEBUG
                print("New Text Entered for \(textField.stringValue)")
            #endif
            
            setUpUI()
        }
    }
}

/* ################################################################################################################################## */
// MARK: - IBAction Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController {
    /* ################################################################## */
    /**
     This will initiate a data send to the device, using whatever is in the command text field.
     
     - parameter: ignored.
     */
    @IBAction func sendButtonHit(_: Any) {
        if  let sendString = enterTextField?.stringValue,
            !sendString.isEmpty {
            #if DEBUG
                print("Sending: \(sendString).")
            #endif
            sendTextButton?.isEnabled = false
            enterTextField?.isEnabled = false
            deviceInstance.sendCommandWithResponse(sendString + "\r\n")
        }
    }
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI elements.
     */
    func setUpUI() {
        if let modelTitle = deviceInstance?.deviceName {
            title = modelTitle
        }
        
        enterTextField?.isEnabled = true
        sendTextButton?.isEnabled = !(enterTextField?.stringValue.isEmpty ?? true)
    }
}

/* ################################################################################################################################## */
// MARK: - Base Class Override Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController {
    /* ################################################################## */
    /**
     Called after the view has loaded and initialized from the storyboard.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        enterTextLabel?.stringValue = (enterTextLabel?.stringValue ?? "ERROR").localizedVariant
        responseDisplayLabel?.stringValue = (responseDisplayLabel?.stringValue ?? "ERROR").localizedVariant
        sendTextButton?.title = (sendTextButton?.title ?? "ERROR").localizedVariant
        detailsCalloutButton?.title = (detailsCalloutButton?.title ?? "ERROR").localizedVariant

        deviceInstance?.subscribe(self)
        deviceInstance?.delegate = self
        self.responseTextView?.string = ""

        setUpUI()
    }
    
    /* ################################################################## */
    /**
     When we are about to appear, we register with the app delegate object.
     */
    override func viewWillAppear() {
        super.viewWillAppear()
        if let uuid = deviceInstance?.uuid {
            appDelegateObject.openDeviceControllers[uuid] = self
        }
        self.enterTextField?.becomeFirstResponder()
    }
    
    /* ################################################################## */
    /**
     We remove ourselves when we are about to go away.
     */
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if let uuid = deviceInstance?.uuid {
            appDelegateObject.openDeviceControllers.removeValue(forKey: uuid)
        }
    }
    
    /* ################################################################## */
    /**
     Called just before we bring in a device details instance screen.
     
     - parameters:
        - for: The Segue instance
        - sender: Data being associated. In this case, it is the device to associate with the screen.
     */
    override func prepare(for inSegue: NSStoryboardSegue, sender inDevice: Any?) {
        if  let destination = inSegue.destinationController as? RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Detail_ViewController {
            destination.deviceInstance = deviceInstance
        }
    }
}

/* ################################################################################################################################## */
// MARK: - RVS_BTDriver_DeviceSubscriberProtocol Handlers
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController {
    /* ################################################################## */
    /**
     Called if the device state changes, in some way.
     
     - parameter inDevice: The device instance that is calling this.
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

/* ################################################################################################################################## */
// MARK: - RVS_BTDriver_OBD_DeviceDelegate Handlers
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController: RVS_BTDriver_OBD_DeviceDelegate {
    /* ################################################################## */
    /**
     REQUIRED: Error reporting method.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func device(_ device: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
            RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
    
    /* ################################################################## */
    /**
     REQUIRED: This is called when an OBD device responds with data.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter returnedThisData: The data returned. It may be nil.
     */
    func device(_ inDevice: RVS_BTDriver_OBD_DeviceProtocol, returnedThisData inData: Data?) {
        if  let data = inData,
            var stringValue = String(data: data, encoding: .utf8) {
            #if DEBUG
                print("Device Returned This Data: \(stringValue)")
            #endif
            DispatchQueue.main.async {
                // First time through, we add the command, and give it a carat.
                if  self.responseTextView?.string.isEmpty ?? true,
                    let initialString = self.enterTextField?.stringValue {
                    stringValue = ">" + initialString + "\r\n" + stringValue
                }
                self.responseTextView?.string += stringValue
                self.responseTextView?.scrollToEndOfDocument(nil)
                self.setUpUI()
                self.enterTextField?.stringValue = ""
                self.enterTextField?.becomeFirstResponder()
            }
        }
    }
}
