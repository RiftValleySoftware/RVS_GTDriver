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
#if !DIRECT
    import RVS_GTDriver_iOS
#endif

/* ###################################################################################################################################### */
// MARK: - View Controller Class for The Device Inspector Screen -
/* ###################################################################################################################################### */
/**
 This screen is pushed in when you select a device in the main table.
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
        // We'll be the delegate for this device while we're looking at it.
        gtDevice.delegate = self
        if !gtDevice.name.isEmpty {
            navigationItem.title = gtDevice.name
        } else {
            navigationItem.title = "SLUG-EMPTY-DEVICE-NAME".localizedVariant
        }
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
        #if DEBUG
            print("ERROR: \(String(describing: inError))")
        #endif
        displayError(inError.localizedDescription.localizedVariant)
    }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device object. It will not be viable after this call.
     */
    public func gtDeviceWasRemoved(_ inDevice: RVS_GTDevice) {
        if inDevice == gtDevice {   // Oh dear. Gotta go...
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
