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
    
    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_DeviceSubscriberProtocol Support
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This will be used to hold an automatically-generated UUID for this subscriber.
     */
    var _uuid: UUID!

    /* ################################################################## */
    /**
     This is the device instance associated with this screen.
    */
    var deviceInstance: RVS_BTDriver_OBD_DeviceProtocol!
    @IBOutlet weak var enterTextLabel: NSTextField!
    @IBOutlet weak var enterTextField: NSTextField!
    @IBOutlet weak var sendTextButton: NSButton!
    @IBOutlet weak var responseDisplayLabel: NSTextField!
    @IBOutlet var responseTextView: NSTextView!
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

        if let modelTitle = deviceInstance?.deviceName {
            title = modelTitle
        }
        
        enterTextLabel?.stringValue = (enterTextLabel?.stringValue ?? "ERROR").localizedVariant
        responseDisplayLabel?.stringValue = (responseDisplayLabel?.stringValue ?? "ERROR").localizedVariant
        sendTextButton?.title = (sendTextButton?.title ?? "ERROR").localizedVariant
        
        deviceInstance?.subscribe(self)
        deviceInstance?.delegate = self
        sayHelloToMyLeetleFriend()
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
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController {
    /* ################################################################## */
    /**
     Initiate AT commands to the device.
     */
    func sayHelloToMyLeetleFriend() {
        let initialAT = "ATZ\r\n"
        
        #if DEBUG
            print("Sending Initial ATZ.")
        #endif
        deviceInstance.sendCommandWithResponse(initialAT)
    }
}

/* ################################################################################################################################## */
// MARK: - RVS_BTDriver_DeviceSubscriberProtocol Handlers
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Device_Base_ViewController: RVS_BTDriver_DeviceSubscriberProtocol {
    /* ################################################################## */
    /**
     Called if the device encounters an error.
     
     - parameters:
        - inDevice: The device instance that is calling this.
        - encounteredThisError: The error that is being returned.
     */
    func device(_ inDevice: RVS_BTDriver_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("DEVICE ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
        }
    }
    
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
    func device(_ device: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError: RVS_BTDriver.Errors) {
        
    }
    
    /* ################################################################## */
    /**
     REQUIRED: This is called when an OBD device responds with data.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter returnedThisData: The data returned. It may be nil.
     */
    func device(_ inDevice: RVS_BTDriver_OBD_DeviceProtocol, returnedThisData inData: Data?) {
        if let data = inData {
            #if DEBUG
                let stringValue = String(data: data, encoding: .utf8) ?? "ERROR!"
                print("Device Returned This Data: \(stringValue)")
            #endif
        }
    }
}
