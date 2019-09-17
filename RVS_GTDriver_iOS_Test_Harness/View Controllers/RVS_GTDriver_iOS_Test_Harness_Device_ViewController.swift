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

import UIKit
import CoreBluetooth
import RVS_GTDriver_iOS

/* ###################################################################################################################################### */
// MARK: - View Controller Class for Device Tabs -
/* ###################################################################################################################################### */
/**
 One of these is instantiated for each device managed by the app.
 */
class RVS_GTDriver_iOS_Test_Harness_Device_ViewController: UIViewController, RVS_GTDriver_iOS_Test_Harness_AppDelegateAccess {
    /* ################################################################################################################################## */
    // MARK: - Internal Static Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    static let storyboardID = "RVS_GTDriver_iOS_Test_Harness_Device_ViewController"
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the device that is associated with this view.
     */
    var gtDevice: RVS_GTDevice!
    
    /* ################################################################## */
    /**
     The label for our manufacturer name
     */
    @IBOutlet weak var manufacturerNameLabel: UILabel!
    
    /* ################################################################## */
    /**
     The label for our model name
     */
    @IBOutlet weak var modelNameLabel: UILabel!
    
    /* ################################################################## */
    /**
     The label for our hardware revision
     */
    @IBOutlet weak var hardwareRevisionLabel: UILabel!
    
    /* ################################################################## */
    /**
     The label for our firmware revision
     */
    @IBOutlet weak var firmwareRevisionLabel: UILabel!
    
    /* ################################################################## */
    /**
     The label for our ID String
     */
    @IBOutlet weak var idLabel: UILabel!
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_Device_ViewController {
    /* ################################################################## */
    /**
     Make sure that we display the navbar.
     
     - parameter inAnimated: Ignored, but sent to the superclass.
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        navigationController?.isNavigationBarHidden = false
    }
    
    /* ################################################################## */
    /**
     Load up on our fixed data header.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        gtDevice.delegate = self
        manufacturerNameLabel.text = "SLUG-MANUFACTURERNAME-LABEL-PREFIX".localizedVariant + " " + gtDevice.manufacturerName
        modelNameLabel.text = "SLUG-MODELNAME-LABEL-PREFIX".localizedVariant + " " + gtDevice.modelNumber
        hardwareRevisionLabel.text = "SLUG-HARDWAREREVISION-LABEL-PREFIX".localizedVariant + " " + gtDevice.hardwareRevision
        firmwareRevisionLabel.text = "SLUG-FIRMWAREREVISION-LABEL-PREFIX".localizedVariant + " " + gtDevice.firmwareRevision
        idLabel.text = "SLUG-ID-LABEL-PREFIX".localizedVariant + " " + gtDevice.id
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDeviceDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_Device_ViewController: RVS_GTDeviceDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance that experienced the error.
     - parameter errorEncountered: The error encountered.
     */
    public func gtDevice(_ inDevice: RVS_GTDevice, errorEncountered inError: RVS_GTDriver.Errors) {
    }
    
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance calling this.
     */
    public func gtDeviceWillBeRemoved(_ inDevice: RVS_GTDevice) {
    }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device object. It will not be viable after this call.
     */
    public func gtDeviceWasRemoved(_ inDevice: RVS_GTDevice) {
    }
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device object.
     */
    public func gtDeviceWasConnected(_ inDevice: RVS_GTDevice) {
    }
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    public func gtDevice(_ inDevice: RVS_GTDevice, wasDisconnected inError: Error?) {
    }

    /* ################################################################## */
    /**
     Called when a device discovers a new service
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance calling this.
     - parameter discoveredService: The discovered service.
     */
    public func gtDevice(_ inDevice: RVS_GTDevice, discoveredService inService: RVS_GTService) {
        inService.delegate = self
        print("Discovered Service: \(inService)")
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTServiceDelegate Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_Device_ViewController: RVS_GTServiceDelegate {
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter inService: The device instance that experienced the error.
     - parameter errorEncountered: The error encountered.
     */
    public func gtService(_ inService: RVS_GTService, errorEncountered inError: RVS_GTDriver.Errors) {
        displayError(inError.localizedDescription.localizedVariant)
    }
    
    /* ################################################################## */
    /**
     Called when a new characteristic has been added to the service.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inService: The service instance calling this.
     - parameter dicoveredCharacteristic: The new characteristic instance.
     */
    func gtService(_ inService: RVS_GTService, dicoveredCharacteristic inCharacteristic: RVS_GTCharacteristic) {
        #if DEBUG
            print("Adding Characteristic: \(inCharacteristic)")
        print("\tValue: \(String(describing: inCharacteristic.value))")
        #endif
        for descriptor in inCharacteristic {
            #if DEBUG
                print("\tDescriptor: \(descriptor)")
            #endif
        }
    }
}
