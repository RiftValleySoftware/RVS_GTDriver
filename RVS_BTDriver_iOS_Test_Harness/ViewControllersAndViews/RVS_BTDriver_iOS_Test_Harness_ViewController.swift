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
// MARK: - Main List Controller -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_iOS_Test_Harness_ViewController: RVS_BTDriver_iOS_Test_Harness_Base_ViewController {
    /* ################################################################## */
    /**
     The table cell prototype reuse ID
     */
    let cellReuseIDentifier = "device-cell"
    
    /* ################################################################## */
    /**
     This is the index that indicates the segmented Switch is in "not scanning" mode.
     */
    static let segmentedSwitchIsOffIndex = 0
    
    /* ################################################################## */
    /**
     This is the index that indicates the segmented Switch is in "scanning" mode.
     */
    static let segmentedSwitchIsOnIndex = 1
    
    /* ################################################################## */
    /**
     The color to use for the segmented switch when not scanning.
     */
    static let redSelectedColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1)
    
    /* ################################################################## */
    /**
     The color to use for the segmented switch when scanning.
     */
    static let greenSelectedColor = UIColor(red: 0, green: 0.25, blue: 0, alpha: 1)

    /* ################################################################## */
    /**
     The image that we display if there is no Bluetooth available.
     */
    @IBOutlet weak var noBTImageView: UIImageView!
    
    /* ################################################################## */
    /**
     The container view for the controls and table, available if there is an active Bluetooth connection.
     */
    @IBOutlet weak var activeBTItemContainerView: UIView!
    
    /* ################################################################## */
    /**
     The table that displays discovered devices.
     */
    @IBOutlet weak var devicesTableView: UITableView!
    
    /* ################################################################## */
    /**
     The scanning/not scanning switch.
     */
    @IBOutlet weak var scanModeSegmentedSwitch: UISegmentedControl!
}

/* ###################################################################################################################################### */
// MARK: - IBAction Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     The scanning/not scanning switch changed.
     
     - parameter inSwitch: The switch instance.
     */
    @IBAction func scanModeSwitchChanged(_ inSwitch: UISegmentedControl) {
        if type(of: self).segmentedSwitchIsOnIndex == inSwitch.selectedSegmentIndex {
            driverInstance?.startScanning()
        } else {
            driverInstance?.stopScanning()
        }
        setup()
    }
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDelegate Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_ViewController: UITableViewDelegate {
}

/* ###################################################################################################################################### */
// MARK: - UITableViewDataSource Support -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_ViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int {
        return 0
    }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Base Class Override Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Called after the view has completely loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        mainNavController.setUpDriver()
        navigationItem.title = navigationItem.title?.localizedVariant
        // We set up the localized strings for the segmented control.
        for i in 0..<scanModeSegmentedSwitch.numberOfSegments {
            scanModeSegmentedSwitch.setTitle(scanModeSegmentedSwitch.titleForSegment(at: i)?.localizedVariant, forSegmentAt: i)
        }
    }
    
    /* ################################################################## */
    /**
     Called just before the view is to lay out its various subviews.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setup()
    }
}

/* ###################################################################################################################################### */
// MARK: - Internal Instance Methods -
/* ###################################################################################################################################### */
extension RVS_BTDriver_iOS_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI Items.
     */
    func setup() {
        noBTImageView?.isHidden = driverInstance?.isBTAvailable ?? false    // This is the "No Bluetooth" image.
        // In case there is no bluetooth service available, we can hide most of the stuff.
        activeBTItemContainerView.isHidden = !(driverInstance?.isBTAvailable ?? false)
        if driverInstance?.isBTAvailable ?? false {
            scanModeSegmentedSwitch.selectedSegmentIndex = driverInstance?.isScanning ?? false ? type(of: self).segmentedSwitchIsOnIndex : type(of: self).segmentedSwitchIsOffIndex
            // iOS 13 uses a different property to affect the tint color.
            if #available(iOS 13.0, *) {
                scanModeSegmentedSwitch.selectedSegmentTintColor = driverInstance?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
                // White text.
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: driverInstance?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor], for: .normal)
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            } else {
                let textColor = driverInstance?.isScanning ?? false ? type(of: self).redSelectedColor : type(of: self).greenSelectedColor
                scanModeSegmentedSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
                scanModeSegmentedSwitch.tintColor = driverInstance?.isScanning ?? false ? type(of: self).greenSelectedColor : type(of: self).redSelectedColor
            }
            devicesTableView?.reloadData()
        }
    }
}
