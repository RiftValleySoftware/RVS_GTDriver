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

import CoreBluetooth

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Vendor_OBD_ELM327 -
/* ###################################################################################################################################### */
/**
 A base class for various OBD dongle handlers, based on the ELM327 chipset.
 */
class RVS_BTDriver_Vendor_OBD_ELM327: RVS_BTDriver_Vendor_OBD {
    /* ###################################################################################################################################### */
    // MARK: - Enums for Proprietary OBD ELM327 BLE Service and Characteristic UUIDs -
    /* ###################################################################################################################################### */
    /**
     These are String-based enums that we use to reference various services and characteristics in our driver.
     */
    fileprivate enum RVS_BLE_GATT_UUID: String {
        /// The device ID string.
        case deviceSpecificID   =   "ELM327"
    }
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
}

/* ###################################################################################################################################### */
// MARK: - OBD ELM327 Device Specialization -
/* ###################################################################################################################################### */
/**
 This is a specialization of the device for OBD ELM327 Devices.
 */
class RVS_BTDriver_Device_OBD_ELM327: RVS_BTDriver_Device_OBD, RVS_BTDriver_OBD_ELM327_DeviceProtocol {
    /* ################################################################## */
    /**
     This is the command that we send to retrieve the version.
     */
    internal static let initialQueryCommand = "ATZ\r\n"
    
    /* ################################################################## */
    /**
     This returns an easy-to-display description string
     */
    public override var description: String {
        return super.description + "-" + RVS_BTDriver_Vendor_OBD_ELM327.RVS_BLE_GATT_UUID.deviceSpecificID.rawValue
    }
    
    /* ################################################################## */
    /**
     This will hold the ELM327 version string.
     */
    public var elm327Version: String = ""
    
    /* ################################################################## */
    /**
     This method should be called after all setup has been done, so that subclasses can do what needs doing.
     We use it to send an initial "ATZ" command.
     */
    internal override func initialSetup() {
        self.sendCommandWithResponse(Self.initialQueryCommand)
        super.initialSetup()
    }

    /* ################################################################## */
    /**
     This is a NOP, because we fetch the ELM version before closing the books.
     */
    internal override func reportCompletion() { }
    
    /* ################################################################## */
    /**
    - parameter inPeripheral: The peripheral that owns this service.
    - parameter didUpdateValueFor: The characteristic that was updated.
    - parameter error: Any error that may have occurred. It can be nil.
    */
    internal override func peripheral(_ inPeripheral: CBPeripheral, didUpdateValueFor inCharacteristic: CBCharacteristic, error inError: Error?) {
        #if DEBUG
            print("OBD ELM327 Device Callback: peripheral: \(inPeripheral) didUpdateValueFor (Characteristic): \(inCharacteristic).")
            print("OBD ELM327 Device Characteristic Value: \(String(describing: inCharacteristic.value))")
            if  let value = inCharacteristic.value,
                let string = String(data: value, encoding: .utf8) {
                print("OBD ELM327 Device Characteristic Value As String: \(string)")
            }
            
            if let error = inError {
                print("With Error: \(error)")
            }
        #endif
        
        // Make sure this is for us.
        if  inPeripheral == peripheral {
            if  let value = inCharacteristic.value {
                if  elm327Version.isEmpty,
                    let trimmedResponse = String(data: value, encoding: .utf8)?.trimmingCharacters(in: CharacterSet([" ", "\t", "\n", "\r", ">", "?"])) {
                    if 9 < trimmedResponse.count {  // We need to have at least nine characters in the response.
                        let indexOfSubstring = trimmedResponse.index(trimmedResponse.startIndex, offsetBy: 8)
                        let substring = String(trimmedResponse[indexOfSubstring...])
                        #if DEBUG
                            print("The ELM327 Version is \(substring)")
                        #endif
                        elm327Version = substring
                        super.reportCompletion()    // Now, we are ready to end the chapter.
                    } else {    // Anything else is an error.
                        deviceType = .unknown
                        if let index = owner?.internal_holding_pen.firstIndex(of: self) {
                            #if DEBUG
                                print("Removing Unqualified Device From Holding Pen, at Index \(index).")
                            #endif
                            owner?.internal_holding_pen.remove(at: index)
                        }
                    }
                } else {
                    #if DEBUG
                        print("Send straight to the delegate.")
                    #endif
                    delegate?.device(self, returnedThisData: value)
                }
            }
        } else {    // Otherwise, kick the can down the road.
            super.peripheral(inPeripheral, didUpdateValueFor: inCharacteristic, error: inError)
        }
    }
}
