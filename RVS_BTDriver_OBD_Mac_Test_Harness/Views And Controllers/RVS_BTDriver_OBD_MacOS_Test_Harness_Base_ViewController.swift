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
     Error reporting method.
     
     - parameter inDevice: The `RVS_BTDriver_DeviceProtocol` instance that has the service.
     - parameter encounteredThisError: The error that was encountered.
     */
    public func subscribedDevice(_ inDevice: RVS_BTDriver_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) { }
    
    /* ################################################################## */
    /**
     This is called when an OBD device updates its transaction.
     
     - parameter updatedTransaction: The transaction that was updated. It may be nil.
     */
    public func deviceUpdatedTransaction(_ updatedTransaction: RVS_BTDriver_OBD_Device_TransactionStruct) { }

    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_OBD_DeviceDelegate Support
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     Error reporting method.
     
     - parameter inDevice: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    public func device(_ inDevice: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
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
