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
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_iOS
#endif

/* ###################################################################################################################################### */
// MARK: - Main Navigation Controller -
/* ###################################################################################################################################### */
/**
 The navigation controller is used to maintain the driver instance.
 
 I know that I should define another class to do that, to be buzzword-compliant, but otherwise, this class would be empty, and there's no sense wasting the namespace.
 */
class RVS_BTDriver_iOS_Test_Harness_NavigationController: UINavigationController {
    /* ################################################################## */
    /**
     This is the instance of our driver class.
     */
    internal var driverInstance: RVS_BTDriver!
    
    /* ################################################################## */
    /**
     These represent the persistent state.
     */
    let prefs = RVS_BTDriver_iOS_Test_Harness_Prefs()
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_NavigationController {
    /* ################################################################## */
    /**
     This establishes the driver instance, wiping out any old one.
     */
    func setUpDriver() {
        let queue: DispatchQueue! = prefs.useDifferentThread ? DispatchQueue.global() : nil
        driverInstance = RVS_BTDriver(delegate: self, queue: queue, allowDuplicatesInBLEScan: prefs.continuousScan, stayConnected: prefs.persistentConnections)
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal UI Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_NavigationController {
    /* ################################################################## */
    /**
     Displays the given message and title in an alert with an "OK" button.
     
     - parameter inTitle: a string to be displayed as the title of the alert. It is localized by this method.
     - parameter message: a string to be displayed as the message of the alert. It is localized by this method.
     - parameter presentedBy: An optional UIViewController object that is acting as the presenter context for the alert. If nil, we use the top controller of the Navigation stack.
     */
    func displayAlert(_ inTitle: String, message inMessage: String, presentedBy inPresentingViewController: UIViewController! = nil ) {
        #if DEBUG
            print("ALERT:\t\(inTitle)\n\t\t\(inMessage)")
        #endif
        DispatchQueue.main.async {  // In case we're called off-thread...
            var presentedBy = inPresentingViewController
            
            if nil == presentedBy {
                presentedBy = self.topViewController
            }
            
            if nil != presentedBy {
                let alertController = UIAlertController(title: inTitle, message: inMessage, preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "SLUG-OK-BUTTON-TEXT".localizedVariant, style: UIAlertAction.Style.cancel, handler: nil)
                
                alertController.addAction(okAction)
                
                presentedBy?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriverDelegate Support -
/* ###################################################################################################################################### */
/**
 These methods handle driver delegate callbacks, which are executed at this level.
 */
extension RVS_BTDriver_iOS_Test_Harness_NavigationController: RVS_BTDriverDelegate {
    /* ################################################################## */
    /**
     Simple error reporting method.
     
     - parameter inDriver: The `RVS_BTDriver` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    func btDriver(_ inDriver: RVS_BTDriver, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("Error Message Received by Navigation Controller: \(inError.localizedDescription)")
        #endif
        assert(inDriver == driverInstance, "Driver Instance Not Ours!")
        displayAlert("SLUG-ERROR-HEADER", message: inError.localizedDescription.localizedVariant)
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
            print("Status Message Received by Navigation Controller")
        #endif
        assert(inDriver == driverInstance, "Driver Instance Not Ours!")
        DispatchQueue.main.async {
            self.topViewController?.view.setNeedsLayout()
        }
    }
}
