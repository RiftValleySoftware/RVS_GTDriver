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
// MARK: - RVS_GTDeviceDelegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol.
 */
public protocol RVS_GTDeviceDelegate: class {
    /* ###################################################################################################################################### */
    // MARK: - Required Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when an error is encountered by a single device.
     
     This is required, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     - parameter errorEncountered: The error encountered.
     */
    func gtDevice(_ device: RVS_GTDevice, errorEncountered: RVS_GTDriver.Errors)
    
    /* ###################################################################################################################################### */
    // MARK: - Optional Methods
    /* ###################################################################################################################################### */
    /* ################################################################## */
    /**
     Called when a device is about to be removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device instance calling this.
     */
    func gtDeviceWillBeRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was removed.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    func gtDeviceWasRemoved(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was connected.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     */
    func gtDeviceWasConnected(_ device: RVS_GTDevice)
    
    /* ################################################################## */
    /**
     Called when a device was disconnected for any reason.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?)
    
    /* ################################################################## */
    /**
     Called to indicate that the device's status should be checked.
     
     It may be called frequently, and there may not be any changes. This is mereley a "make you aware of the POSSIBILITY of a change" call.
     
     This is optional, and is NOT guaranteed to be called in the main thread.
     
     - parameter device: The driver instance calling this.
     */
    func gtDeviceStatusUpdate(_ device: RVS_GTDevice)
}

/* ###################################################################################################################################### */
// MARK: - RVS_GTDeviceDelegate Protocol Extension (Optional Methods) -
/* ###################################################################################################################################### */
extension RVS_GTDeviceDelegate {
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter device: The device instance calling this.
     */
    public func gtDeviceWillBeRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter device: The device object. It will not be viable after this call.
     */
    public func gtDeviceWasRemoved(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter device: The device object.
     */
    public func gtDeviceWasConnected(_ device: RVS_GTDevice) { }
    
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter device: The device object.
     - parameter wasDisconnected: Any error that may have occurred. May be nil.
     */
    public func gtDevice(_ device: RVS_GTDevice, wasDisconnected: Error?) { }
    
    /* ################################################################## */
    /**
     default implementation does nothing.
     
     - parameter device: The driver instance calling this.
     */
    public func gtDeviceStatusUpdate(_ device: RVS_GTDevice) { }
}

/* ###################################################################################################################################### */
// MARK: - Public Declaractions -
/* ###################################################################################################################################### */
/**
 This is the "Public Face" of the device. This is what we want our consumers to see and use. Some of the other stuff is public, but isn't
 meant for consumer use. It needs to be public in order to conform to delegate protocols.
 
 The device interface is likely to be the one that your implementation uses the most. The driver acts as an "aggregator," but devices are
 where the action is at.
 */
extension RVS_GTDevice {
    /* ################################################################################################################################## */
    // MARK: - Public Calculated Instance Properties -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is our delegate instance. It can be nil. READ/WRITE
     NOTE: This May not be in the main thread!
     */
    public var delegate: RVS_GTDeviceDelegate! {
        get {
            return internal_delegate
        }
        
        set {
            internal_delegate = newValue
            internal_delegate?.gtDeviceStatusUpdate(self)   // Even though they already know, we may send a status update.
        }
    }

    /* ################################################################## */
    /**
     This manages and reports our connection. Changing this value will connect or disconnect this device.
     It is KVO-observable, but can only be changed inside the driver. READ-ONLY (PUBLIC)
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public internal(set) var isConnected: Bool {
        get {
            return .connected == internal_peripheral.state
        }
        
        set {
            if newValue && .disconnected == internal_peripheral.state {
                internal_owner.connectDevice(self)
            } else if !newValue {
                internal_owner.disconnectDevice(self)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is a flag that tells us to remain connected continuously, until explicitly disconnected by the user. Default is false.
     It is KVO-observable. READ/WRITE
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var shouldStayConnected: Bool {
        get {
            return internal_stayConnected
        }
        
        set {
            internal_stayConnected = newValue
        }
    }

    /* ################################################################## */
    /**
     This is the manufacturer name. It will be filled at initialization time.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var manufacturerName: String {
        return internal_manufacturerName
    }
    
    /* ################################################################## */
    /**
     This is the "model number." It will be filled at initialization time.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var modelNumber: String {
        return internal_modelNumber
    }
    
    /* ################################################################## */
    /**
     This is the hardware revision. It will be filled at initialization time.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var hardwareRevision: String {
        return internal_hardwareRevision
    }
    
    /* ################################################################## */
    /**
     This is the firmware revision. It will be filled at initialization time.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var firmwareRevision: String {
        return internal_firmwareRevision
    }
    
    /* ################################################################## */
    /**
     This is the unique ID for the peripheral.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var id: String {
        return internal_peripheral?.identifier.uuidString ?? ""
    }
    
    /* ################################################################## */
    /**
     This is the peripheral's name.
     It is KVO-observable. READ-ONLY
     NOTE: This May not be in the main thread!
     */
    @objc dynamic public var name: String {
        return internal_peripheral?.name ?? ""
    }

    /* ################################################################################################################################## */
    // MARK: - Public Instance Methods -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Causes the device to connect.
     
     - parameter remainConnected: If true (this is optional, and default is false), then the device will retain its connection until explicitly disconnected by the user.
     */
    public func connect(remainConnected inRemainConnected: Bool = false) {
        shouldStayConnected = inRemainConnected
        isConnected = true
    }
    
    /* ################################################################## */
    /**
     Causes the device to disconnect.
     */
    public func disconnect() {
        isConnected = false
    }

    /* ################################################################## */
    /**
     If you call this, the driver will delete the device, and it will be eligible for rediscovery.
     
     We also call the delegate with the "before and after" calls.
     */
    public func deleteThisDevice() {
        disconnect() // Make sure that we're not connected anymore.
        delegate?.gtDeviceWillBeRemoved(self)
        internal_owner.removeDeviceFromDriver(self)
        delegate?.gtDeviceWasRemoved(self)
    }
}
