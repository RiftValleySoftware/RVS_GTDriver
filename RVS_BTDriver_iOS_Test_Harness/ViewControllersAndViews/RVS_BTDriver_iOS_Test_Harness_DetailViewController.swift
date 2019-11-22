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
// MARK: - Detail View Table Cell Class -
/* ###################################################################################################################################### */
/**
 This class represents one row of the details display.
 */
class RVS_BTDriver_iOS_Test_Harness_DetailViewControllerTableCell: UITableViewCell {
    /* ################################################################## */
    /**
     The reuse ID for instantiating these.
     */
    static let reuseID = "display-value"
    /* ################################################################## */
    /**
     The label that displays the key.
     */
    @IBOutlet weak var labelLabel: UILabel!
    /* ################################################################## */
    /**
     The label that displays the value.
     */
    @IBOutlet weak var valueLabel: UILabel!
}

/* ###################################################################################################################################### */
// MARK: - Detail View Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Test_Harness_DetailViewController: RVS_BTDriver_iOS_Test_Harness_Base_ViewController {
    /// The device for which this is a detailed view.
    var device: RVS_BTDriver_DeviceProtocol!
    /* ################################################################## */
    /**
     The table that displays the values.
     */
    @IBOutlet weak var displayTableView: UITableView!
    
    /* ################################################################## */
    /**
     This will contain our DeviceInfo strings from the device record.
     */
    var deviceInfo: [String: String] = [:]
    
    /* ################################################################## */
    /**
     Called just prior to the view appearing.
     
     - parameter inAnimated: True, if the appearance is to be animated (ignored, but passed to the superclass).
     */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        
        if let value = device?.uuid {
            deviceInfo["deviceInfoDeviceID"] = value
        }
        
        if let value = device?.manufacturerName {
            deviceInfo["deviceInfoManufacturerName"] = value
        }
        
        if let value = device?.modelName {
            deviceInfo["deviceInfoModelName"] = value
        }
        
        if let value = device?.serialNumber {
            deviceInfo["deviceInfoSerialNumber"] = value
        }

        if let value = device?.hardwareRevision {
            deviceInfo["deviceInfoHardwareRevision"] = value
        }
        
        if let value = device?.firmwareRevision {
            deviceInfo["deviceInfoFirmwareRevision"] = value
        }
        
        if let value = device?.softwareRevision {
            deviceInfo["deviceInfoSoftwareRevision"] = value
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Base Class Override Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_DetailViewController {
    /* ################################################################## */
    /**
     Called after the view has completely loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if let deviceName = device.modelName {
            navigationItem.title = deviceName.localizedVariant
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_DetailViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceInfo.count
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        let keys = deviceInfo.keys.sorted()
        
        let key = keys[inIndexPath.row]
        
        if let ret = inTableView.dequeueReusableCell(withIdentifier: RVS_BTDriver_iOS_Test_Harness_DetailViewControllerTableCell.reuseID) as? RVS_BTDriver_iOS_Test_Harness_DetailViewControllerTableCell {
            ret.labelLabel.text = key.localizedVariant + ":"
            ret.valueLabel.text = "\(deviceInfo[key] ?? "ERROR")"
            return ret
        }
        return UITableViewCell()
    }
}
