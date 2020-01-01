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

/* ########################################################################################################################################## */
// MARK: - RVS_BTDriver_OBD_Commands -
/* ########################################################################################################################################## */
/**
 */
typealias RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple = (method: (() -> Void)?, description: String)

/* ################################################################################################################################## */
// MARK: - This Allows Us to Send Fixed Commands (For Testing) -
/* ################################################################################################################################## */
/**
 */
class RVS_BTDriver_OBD_MacOS_Test_Harness_Command_ViewController: RVS_BTDriver_OBD_MacOS_Test_Harness_Base_Device_ViewController {
    /* ############################################################################################################################## */
    // MARK: - Static Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is the storyboard instantiation ID.
    */
    static let storyboardID = "command-view-controller"
    
    /* ################################################################## */
    /**
    */
    var commandDictionary: [String: RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple] = [:]
    
    var oldDelegate: RVS_BTDriver_OBD_DeviceDelegate!

    /* ################################################################## */
    /**
    */
    @IBOutlet weak var cancelButton: NSButton!
    
    /* ################################################################## */
    /**
    */
    @IBOutlet weak var commandPopupMenu: NSPopUpButton!
    
    /* ################################################################## */
    /**
    */
    @IBOutlet weak var responseTextLabel: NSTextField!
    
    /* ################################################################## */
    /**
    */
    @IBOutlet var responseTextView: NSTextView!
    
    /* ################################################################## */
    /**
    */
    @IBAction func commandMenuSelected(_ inButton: NSPopUpButton) {
        if 0 < inButton.indexOfSelectedItem {
            let keys = commandDictionary.keys.sorted()
            if let selectedItem = commandDictionary[keys[inButton.indexOfSelectedItem - 1]] {
                #if DEBUG
                    print("Selected: \(String(describing: selectedItem))")
                #endif
                responseTextView?.string = ""
                if let method = selectedItem.method {
                    method()
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton?.title = (cancelButton?.title ?? "ERROR").localizedVariant
        responseTextLabel?.stringValue = (responseTextLabel?.stringValue ?? "ERROR").localizedVariant
        
        // We need to cast to the ELM327-specific protocol.
        if let deviceInstance = deviceInstance as? RVS_BTDriver_OBD_ELM327_DeviceProtocol {
            commandDictionary = [
                /* ################################################################################################################################## */
                // MARK: - General -
                /* ################################################################################################################################## */
                /**
                This applies to the "General" group of commands.
                */
                "getDeviceDescription": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.getDeviceDescription, description: "SLUG-getDeviceDescription"),
                "getDeviceIdentifier": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.getDeviceIdentifier, description: "SLUG-getDeviceIdentifier"),
            //    "setDeviceIdentifier": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setDeviceIdentifier, description: "SLUG-setDeviceIdentifier"),
            //    "setBaudRateDivisor": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setBaudRateDivisor, description: "SLUG-setBaudRateDivisor"),
            //    "setBaudRateHandshakeTimeout": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setBaudRateHandshakeTimeout, description: "SLUG-setBaudRateHandshakeTimeout"),
                "restoreToDefaults": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.restoreToDefaults, description: "SLUG-restoreToDefaults"),
                "turnEchoOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnEchoOn, description: "SLUG-turnEchoOn"),
                "turnEchoOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnEchoOff, description: "SLUG-turnEchoOff"),
                "flushAllEvents": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.flushAllEvents, description: "SLUG-flushAllEvents"),
                "getID": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.getID, description: "SLUG-getID"),
                "turnLinefeedsOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnLinefeedsOn, description: "SLUG-turnLinefeedsOn"),
                "turnLinefeedsOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnLinefeedsOff, description: "SLUG-turnLinefeedsOff"),
                "turnLowPowerModeOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnLowPowerModeOn, description: "SLUG-turnLowPowerModeOn"),
                "turnMemoryOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnMemoryOn, description: "SLUG-turnMemoryOn"),
                "turnMemoryOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnMemoryOff, description: "SLUG-turnMemoryOff"),
                "fetchStoredData": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.fetchStoredData, description: "SLUG-fetchStoredData"),
            //    "storeData": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.storeData, description: "SLUG-storeData"),
                "warmStart": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.warmStart, description: "SLUG-warmStart"),
                "resetAll": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.resetAll, description: "SLUG-resetAll"),

                /* ################################################################################################################################## */
                // MARK: - OBD -
                /* ################################################################################################################################## */
                /**
                 This applies to the "OBD" group of commands.
                 */
                "useLongMessages": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useLongMessages, description: "SLUG-useLongMessages"),
                "useShortMessages": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useShortMessages, description: "SLUG-useShortMessages"),
                "autoReceive": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.autoReceive, description: "SLUG-autoReceive"),
                "useAdaptiveTimingMode1": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useAdaptiveTimingMode1, description: "SLUG-useAdaptiveTimingMode1"),
                "useAdaptiveTimingMode2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useAdaptiveTimingMode2, description: "SLUG-useAdaptiveTimingMode2"),
                "turnAdaptiveTimingOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnAdaptiveTimingOff, description: "SLUG-turnAdaptiveTimingOff"),
                "bufferDump": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.bufferDump, description: "SLUG-bufferDump"),
                "bypassInitialization": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.bypassInitialization, description: "SLUG-bypassInitialization"),
                "describeCurrentProtocol": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.describeCurrentProtocol, description: "SLUG-describeCurrentProtocol"),
                "describeProtocolByNumber": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.describeProtocolByNumber, description: "SLUG-describeProtocolByNumber"),
                "turnHeadersOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnHeadersOn, description: "SLUG-turnHeadersOn"),
                "turnHeadersOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnHeadersOff, description: "SLUG-turnHeadersOff"),
                "monitorAll": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.monitorAll, description: "SLUG-monitorAll"),
            //    "setMonitorForReceiver": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setMonitorForReceiver, description: "SLUG-setMonitorForReceiver"),
            //    "setMonitorForTransmitter": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setMonitorForTransmitter, description: "SLUG-setMonitorForTransmitter"),
            //    "setProtocol": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setProtocol, description: "SLUG-setProtocol"),
            //    "setProtocol2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setProtocol2, description: "SLUG-setProtocol2"),
            //    "setAutoProtocol": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setAutoProtocol, description: "SLUG-setAutoProtocol"),
            //    "setAutoProtocol2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setAutoProtocol2, description: "SLUG-setAutoProtocol2"),
                "useAutoProtocol": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useAutoProtocol, description: "SLUG-useAutoProtocol"),
                "closeProtocol": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.closeProtocol, description: "SLUG-closeProtocol"),
                "turnResponsesOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnResponsesOn, description: "SLUG-turnResponsesOn"),
                "turnResponsesOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnResponsesOff, description: "SLUG-turnResponsesOff"),
            //    "setReceiveAddress": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setReceiveAddress, description: "SLUG-setReceiveAddress"),
            //    "setReceiveAddress2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setReceiveAddress2, description: "SLUG-setReceiveAddress2"),
                "turnPrintSpacesOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnPrintSpacesOn, description: "SLUG-turnPrintSpacesOn"),
                "turnPrintSpacesOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnPrintSpacesOff, description: "SLUG-turnPrintSpacesOff"),
            //    "setHeader1": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setHeader1, description: "SLUG-setHeader1"),
            //    "setHeader2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setHeader2, description: "SLUG-setHeader2"),
                "useStandardSearchOrder": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useStandardSearchOrder, description: "SLUG-useStandardSearchOrder"),
            //    "setTesterAddress": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setTesterAddress, description: "SLUG-setTesterAddress"),
            //    "setTimeOutBy4MillisecondIntervals": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setTimeOutBy4MillisecondIntervals, description: "SLUG-setTimeOutBy4MillisecondIntervals"),
                
                /* ################################################################################################################################## */
                // MARK: - CAN -
                /* ################################################################################################################################## */
                /**
                 This applies to the "CAN" group of commands.
                 */
                "turnCANAutoFormattingOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANAutoFormattingOn, description: "SLUG-turnCANAutoFormattingOn"),
                "turnCANAutoFormattingOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANAutoFormattingOff, description: "SLUG-turnCANAutoFormattingOff"),
            //    "setCANExtendedAddressing": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setCANExtendedAddressing, description: "SLUG-setCANExtendedAddressing"),
                "turnOffCANExtendedAddressing": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnOffCANExtendedAddressing, description: "SLUG-turnOffCANExtendedAddressing"),
            //    "setIDFilter1": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setIDFilter1, description: "SLUG-setIDFilter1"),
            //    "setIDFilter2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setIDFilter2, description: "SLUG-setIDFilter2"),
                "turnCANFlowControlOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANFlowControlOn, description: "SLUG-turnCANFlowControlOn"),
                "turnCANFlowControlOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANFlowControlOff, description: "SLUG-turnCANFlowControlOff"),
                "turnCANSilentModeOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANSilentModeOn, description: "SLUG-turnCANSilentModeOn"),
                "turnCANSilentModeOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnCANSilentModeOff, description: "SLUG-turnCANSilentModeOff"),
                "turnDLCDisplayOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnDLCDisplayOn, description: "SLUG-turnDLCDisplayOn"),
                "turnDLCDisplayOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnDLCDisplayOff, description: "SLUG-turnDLCDisplayOff"),
            //    "setFlowControlData": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setFlowControlData, description: "SLUG-setFlowControlData"),
            //    "setFlowControlHeader": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setFlowControlHeader, description: "SLUG-setFlowControlHeader"),
            //    "setFlowControlMode": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setFlowControlMode, description: "SLUG-setFlowControlMode"),
            //    "setProtocolBOptionsAndBaudRate": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setProtocolBOptionsAndBaudRate, description: "SLUG-setProtocolBOptionsAndBaudRate"),
                "rtrMessage": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.rtrMessage, description: "SLUG-rtrMessage"),
                "turnVariableDLCOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnVariableDLCOn, description: "SLUG-turnVariableDLCOn"),
                "turnVariableDLCOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnVariableDLCOff, description: "SLUG-turnVariableDLCOff"),

                /* ################################################################################################################################## */
                // MARK: - Volts -
                /* ################################################################################################################################## */
                /**
                 This applies to the "Volts" group of commands.
                 */
            //    "setCalibratingVoltage": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setCalibratingVoltage, description: "SLUG-setCalibratingVoltage"),
                "resetCalibratingVoltage": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.resetCalibratingVoltage, description: "SLUG-resetCalibratingVoltage"),

                /* ################################################################################################################################## */
                // MARK: - J1939 -
                /* ################################################################################################################################## */
                /**
                 This applies to the "J1939" group of commands.
                 */
                "monitorForDM1Messages": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.monitorForDM1Messages, description: "SLUG-monitorForDM1Messages"),
                "useElmDataFormat": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useElmDataFormat, description: "SLUG-useElmDataFormat"),
                "useSAEDataFormat": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useSAEDataFormat, description: "SLUG-useSAEDataFormat"),
                "turnJ1939HeaderFormattingOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnJ1939HeaderFormattingOn, description: "SLUG-turnJ1939HeaderFormattingOn"),
                "turnJ1939HeaderFormattingOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnJ1939HeaderFormattingOff, description: "SLUG-turnJ1939HeaderFormattingOff"),
                "use1XTimerMultiplier": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.use1XTimerMultiplier, description: "SLUG-use1XTimerMultiplier"),
                "use5XTimerMultiplier": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.use5XTimerMultiplier, description: "SLUG-use5XTimerMultiplier"),
            //    "setPGNMonitor1": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPGNMonitor1, description: "SLUG-setPGNMonitor1"),
            //    "setPGNMonitor2": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPGNMonitor2, description: "SLUG-setPGNMonitor2"),
            //    "setPGNMonitorGetMessages": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPGNMonitorGetMessages, description: "SLUG-setPGNMonitorGetMessages"),

                /* ################################################################################################################################## */
                // MARK: - J1850 -
                /* ################################################################################################################################## */
                /**
                 This applies to the "J1850" group of commands.
                 */
                "getIFRValueFromHeader": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.getIFRValueFromHeader, description: "SLUG-getIFRValueFromHeader"),
                "getIFRValueFromSource": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.getIFRValueFromSource, description: "SLUG-getIFRValueFromSource"),
                "turnIFRsOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnIFRsOn, description: "SLUG-turnIFRsOn"),
                "useIFRsAuto": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.useIFRsAuto, description: "SLUG-useIFRsAuto"),
                "turnIFRsOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnIFRsOff, description: "SLUG-turnIFRsOff"),

                /* ################################################################################################################################## */
                // MARK: - ISO -
                /* ################################################################################################################################## */
                /**
                 This applies to the "ISO" group of commands.
                 */
                "isoBaudRate10400": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.isoBaudRate10400, description: "SLUG-isoBaudRate10400"),
                "isoBaudRate4800": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.isoBaudRate4800, description: "SLUG-isoBaudRate4800"),
                "isoBaudRate9600": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.isoBaudRate9600, description: "SLUG-isoBaudRate9600"),
            //    "setISOInitAddress": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setISOInitAddress, description: "SLUG-setISOInitAddress"),
                "displayKeywords": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.displayKeywords, description: "SLUG-displayKeywords"),
                "turnKeywordCheckingOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnKeywordCheckingOn, description: "SLUG-turnKeywordCheckingOn"),
                "turnKeywordCheckingOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnKeywordCheckingOff, description: "SLUG-turnKeywordCheckingOff"),
                "performSlowInitiation": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.performSlowInitiation, description: "SLUG-performSlowInitiation"),
            //    "setWakeupIntervalMultiplerBy20ms": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setWakeupIntervalMultiplerBy20ms, description: "SLUG-setWakeupIntervalMultiplerBy20ms"),
            //    "setWakeupMessage": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setWakeupMessage, description: "SLUG-setWakeupMessage"),

                /* ################################################################################################################################## */
                // MARK: - PPs -
                /* ################################################################################################################################## */
                /**
                 This applies to the "PPs" group of commands.
                 */
                "turnAllPPsProgParametersOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnAllPPsProgParametersOn, description: "SLUG-turnAllPPsProgParametersOn"),
                "turnAllPPsProgParametersOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.turnAllPPsProgParametersOff, description: "SLUG-turnAllPPsProgParametersOff"),
            //    "setPPsProgParameterOn": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPPsProgParameterOn, description: "SLUG-setPPsProgParameterOn"),
            //    "setPPsProgParameterOff": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPPsProgParameterOff, description: "SLUG-setPPsProgParameterOff"),
            //    "setPPsProgParameterValue": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.setPPsProgParameterValue, description: "SLUG-setPPsProgParameterValue"),
                "ppSummary": RVS_BTDriver_OBD_ELM327_CommandDictionary_Tuple(method: deviceInstance.ppSummary, description: "SLUG-ppSummary")
                ]
            
            let keys = commandDictionary.keys.sorted()
            let popupItems: [String] = ["SLUG-AnyValue".localizedVariant] + keys.compactMap {
                if let value = commandDictionary[$0] {
                    return value.description.localizedVariant
                }
                
                return nil
            }
            
            commandPopupMenu?.addItems(withTitles: popupItems)
            commandPopupMenu?.selectItem(at: 0)
        }
    }
    
    /* ############################################################################################################################## */
    // MARK: - RVS_BTDriver_OBD_DeviceDelegate Handlers
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when an OBD device updates its transaction.
     
     - parameter updatedTransaction: The transaction that was updated. It may be nil.
     */
    override func deviceUpdatedTransaction(_ updatedTransaction: RVS_BTDriver_OBD_Device_TransactionStruct) {
        if  let data = updatedTransaction.responseData,
            let stringValue = String(data: data, encoding: .ascii) {
            #if DEBUG
                print("Device Returned This Data: \(stringValue)")
            #endif
            DispatchQueue.main.async {
                self.responseTextView?.string = stringValue
                self.responseTextView?.scrollToEndOfDocument(nil)
                self.setUpUI()
            }
        }
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillAppear() {
        super.viewWillAppear()
        oldDelegate = deviceInstance?.delegate
        deviceInstance?.delegate = self
    }
    
    /* ################################################################## */
    /**
     */
    override func viewWillDisappear() {
        super.viewWillDisappear()
        deviceInstance?.delegate = oldDelegate
    }
    
    /* ################################################################## */
    /**
     Error reporting method.
     
     - parameter inDevice: The `RVS_BTDriver_OBD_DeviceProtocol` instance that encountered the error.
     - parameter encounteredThisError: The error that was encountered.
     */
    override func device(_ inDevice: RVS_BTDriver_OBD_DeviceProtocol, encounteredThisError inError: RVS_BTDriver.Errors) {
        #if DEBUG
            print("ERROR! \(String(describing: inError))")
        #endif
        DispatchQueue.main.async {
            RVS_BTDriver_OBD_Mac_Test_Harness_AppDelegate.displayAlert(header: "SLUG-ERROR-HEADER", message: inError.localizedDescription)
        }
    }
}

/* ################################################################################################################################## */
// MARK: - Instance Methods
/* ################################################################################################################################## */
extension RVS_BTDriver_OBD_MacOS_Test_Harness_Command_ViewController {
    /* ################################################################## */
    /**
     Sets up the UI elements.
     */
    func setUpUI() {
        if var modelTitle = deviceInstance?.deviceName {
            if let device = deviceInstance as? RVS_BTDriver_OBD_ELM327_DeviceProtocol {
                modelTitle += " (ELM327 v\(device.elm327Version))"
            }
            title = modelTitle
        }
    }
}
