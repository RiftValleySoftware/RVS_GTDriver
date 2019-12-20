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

/* ################################################################################################################################## */
// MARK: - The Base (Common) View Controller Class
/* ################################################################################################################################## */
/**
 This class provides some common tools for all view controllers.
 */
class RVS_BTDriver_OBD_MacOS_Test_Harness_Base_ViewController: NSViewController, RVS_BTDriver_DeviceSubscriberProtocol, RVS_BTDriver_OBD_DeviceDelegate {
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
            RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
    
    /* ################################################################## */
    /**
     REQUIRED: This is called when an OBD device responds with data. Default does nothing.
     
     - parameter device: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter returnedThisData: The data returned. It may be nil.
     */
    func device(_ device: RVS_BTDriver_OBD_DeviceProtocol, returnedThisData: Data?) { }

    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_OBD_DeviceDelegate Support
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     Error reporting method.
     
     - parameter inDevice: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func device(_ inDevice: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
            RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
    
    /* ############################################################################################################################## */
    // MARK: - Instance Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     These are the shared persistent prefs for the test harness app.
     */
    @objc dynamic internal let prefs = RVS_BTDriver_Test_Harness_Prefs()
    
    /* ############################################################################################################################## */
    // MARK: - Instance Computed Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is an accessor to our app delegate object. READ-ONLY
     */
    @objc dynamic var appDelegateObject: RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate {
        return RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject
    }
    
    /* ################################################################## */
    /**
     This is our instance of the actual BLE driver. We fetch it from the app delegate. READ-ONLY
     */
    @objc dynamic var driverInstance: RVS_BTDriver! {
        return RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.appDelegateObject.driverInstance
    }
    
    /* ################################################################## */
    /**
     This is KVO (READ-ONLY)
     
     - returns: true, if all of the vendor interfaces have Bluetooth powered on.
     */
    @objc dynamic public var isBTAvailable: Bool {
        return driverInstance?.isBTAvailable ?? false
    }
}
