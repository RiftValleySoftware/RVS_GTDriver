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

/* ###################################################################################################################################### */
// MARK: - Main Application Delegate Class -
/* ###################################################################################################################################### */
/**
 */
@NSApplicationMain
class RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate: NSObject, NSApplicationDelegate {
    /* ################################################################## */
    /**
     This is the internal holder for the driver instance. It is initialized as a singleton, the first time it's accessed.
     */
    private var _driverInstance: RVS_BTDriver!

    /* ############################################################################################################################## */
    // MARK: - Internal Class Computed Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is a quick way to get this object instance (it's a SINGLETON), cast as the correct class.
     
     - returns: the app delegate object, in its natural environment.
     */
    @objc dynamic class var appDelegateObject: RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate {
        return (NSApplication.shared.delegate as? RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate)!
    }
    
    /* ############################################################################################################################## */
    // MARK: - Internal Instance Computed Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is our instance of the actual BLE driver.
     We initialize the singleton, here.
     */
    @objc dynamic var driverInstance: RVS_BTDriver! {
        if nil == _driverInstance {
            setUpDriver()
        }
        
        return _driverInstance
    }
    
    /* ############################################################################################################################## */
    // MARK: - Internal Instance Computed Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This indicates that the driver is scanning for new devices. If set to true, and the driver is initialized, the driver will start scanning (unless it is already scanning).
     If it is set to false, and the driver is initialized and scanning, the driver will stop scanning.
     Otherwise, it is ignored.
     */
    @objc dynamic var isScanning: Bool {
        get {
            return type(of: self).appDelegateObject.driverInstance?.isScanning ?? false
        }
        
        set {
            if  newValue,
                let driverInstance = type(of: self).appDelegateObject.driverInstance,
                !driverInstance.isScanning {
                driverInstance.startScanning()
            } else if let driverInstance = type(of: self).appDelegateObject.driverInstance {
                driverInstance.stopScanning()
            }
        }
    }
    
    /* ################################################################## */
    /**
     Returns true, if bluetooth is available. READ-ONLY
     */
    @objc dynamic var isBTAvailable: Bool {
        return type(of: self).appDelegateObject.driverInstance?.isBTAvailable ?? false
    }
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate {
    /* ################################################################## */
    /**
     This establishes the driver instance, wiping out any old one.
     
     If the driver was previously scanning, it will start scanning again. This may mean that deleted devices get rediscovered.
     */
    func setUpDriver() {
        let wasScanning = nil != _driverInstance ? driverInstance.isScanning : false
        let prefs = RVS_BTDriver_Test_Harness_Prefs()
        let queue: DispatchQueue! = prefs.useDifferentThread ? DispatchQueue.global() : nil
        _driverInstance = RVS_BTDriver(delegate: self, queue: queue, allowDuplicatesInBLEScan: prefs.continuousScan, stayConnected: prefs.persistentConnections)
        isScanning = wasScanning
        
        #if DEBUG
            print(String(describing: _driverInstance))
        #endif
    }
    
    /* ################################################################## */
    /**
     This displays a simple alert, with an OK button.
     
     - parameter header: The header to display at the top.
     - parameter message: A String, containing whatever messge is to be displayed below the header.
     */
    class func displayAlert(header inHeader: String, message inMessage: String = "") {
        let alert = NSAlert()
        alert.messageText = inHeader.localizedVariant
        alert.informativeText = inMessage.localizedVariant
        alert.addButton(withTitle: "SLUG-OK-BUTTON-TEXT".localizedVariant)
        alert.runModal()
    }
}

/* ################################################################################################################################## */
// MARK: - RVS_BTDriverDelegate Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate: RVS_BTDriverDelegate {
    /* ################################################################## */
    /**
     Simple error reporting method.
     
     - parameter inDriver: The `RVS_BTDriver` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func btDriver(_ inDriver: RVS_BTDriver, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
            type(of: self).displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
    
    /* ################################################################## */
    /**
     Called when a new device is discovered while scanning.
     
     - parameter inDriver: The `RVS_BTDriver` instance that is calling this.
     - parameter newDeviceAdded: The new device instance.
     */
    func btDriver(_ inDriver: RVS_BTDriver, newDeviceAdded inDevice: RVS_BTDriver_DeviceProtocol) {
        #if DEBUG
            print("New Device Added: \(String(describing: inDevice))")
        #endif
    }
        
    /* ################################################################## */
    /**
     Called to indicate that the driver's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     */
    func btDriverStatusUpdate(_ inDriver: RVS_BTDriver) {
        #if DEBUG
            print("Status Message Received")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called to indicate that the driver started or stopped scanning.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter driver: The `RVS_BTDriver` instance calling this.
     - parameter isScanning: True, if the new state is scanning is on.
     */
    func btDriverScanningChanged(_ driver: RVS_BTDriver, isScanning: Bool) {
        #if DEBUG
            print("The driver is" + (isScanning ? " now" : " not") + " scanning.")
        #endif
    }
}
