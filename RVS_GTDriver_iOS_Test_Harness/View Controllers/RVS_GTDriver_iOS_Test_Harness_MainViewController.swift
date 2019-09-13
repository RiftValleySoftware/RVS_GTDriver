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
// MARK: - Single Table View Cell Class -
/* ###################################################################################################################################### */
/**
 Each row of the table is composed of an instance of this class.
 */
class RVS_GTDriver_iOS_Test_Harness_MainViewController_TableViewCell: UITableViewCell {
    var gtDevice: RVS_GTDevice!
}

/* ###################################################################################################################################### */
// MARK: - Main Window ViewController Class -
/* ###################################################################################################################################### */
/**
 The main window view controller class.
 
 It displays a table, with each row representing one discovered goTenna device.
 
 Selecting a row will open a view for that device (pushed onto the nav stack).
 */
class RVS_GTDriver_iOS_Test_Harness_MainViewController: UIViewController {
    /* ################################################################################################################################## */
    // MARK: - Internal Static Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the reuse ID for creating new table cells.
     */
    static let reuseID = "DeviceRow"
    
    /* ################################################################################################################################## */
    // MARK: - Internal Calculated Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This returns the driver instance, from the app delegate
     */
    var gtDriver: RVS_GTDriver! {
        return RVS_GTDriver_iOS_Test_Harness_AppDelegate.appDelegateObject.gtDriver
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int {
        return gtDriver?.count ?? 0
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        guard let cell = inTableView.dequeueReusableCell(withIdentifier: type(of: self).reuseID) as? RVS_GTDriver_iOS_Test_Harness_MainViewController_TableViewCell else { return UITableViewCell() }
        cell.gtDevice = gtDriver[inIndexPath.row]
        return cell
    }
}

/* ###################################################################################################################################### */
// MARK: - Overridden Base Class Methods -
/* ###################################################################################################################################### */
extension RVS_GTDriver_iOS_Test_Harness_MainViewController {
    /* ################################################################## */
    /**
     Make sure that the navbar is hidden for the main view.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}
