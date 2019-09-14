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
import RVS_GTDriver_iOS

/* ###################################################################################################################################### */
// MARK: - View Controller Class for Device Tabs -
/* ###################################################################################################################################### */
/**
 One of these is instantiated for each device managed by the app.
 */
class RVS_GTDriver_iOS_Test_Harness_Device_ViewController: UIViewController {
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
    func gtDevice(_ inDevice: RVS_GTDevice, errorEncountered inError: Error) {
    }
    
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device instance calling this.
     */
    func gtDeviceWillBeRemoved(_ inDevice: RVS_GTDevice) {
    }
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter inDevice: The device object. It will not be viable after this call.
     */
    func gtDeviceWasBeRemoved(_ inDevice: RVS_GTDevice) {
    }
}