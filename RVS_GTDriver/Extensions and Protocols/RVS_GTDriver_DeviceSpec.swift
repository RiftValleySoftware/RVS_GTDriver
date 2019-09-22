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
// MARK: - Protocol for Device- or Manufacturer-Specific Handlers -
/* ###################################################################################################################################### */
/**
 This protocol describes a "factory" implementation, allowing the development of special classes that can generate specialized instances of
 classes that handle services and characteristics that may be specific to ceertain manufacturers.
 */
internal protocol RVS_GTDevice_DeviceSpec {
    /* ################################################################## */
    /**
     - returns: An Array, with the UUIDs of all the services this handler will take.
     */
    var serviceUUIDs: [CBUUID] { get }
    
    /* ################################################################## */
    /**
     - returns: An Array, with the UUIDs of the service[s] that the handler advertises (for a search).
     */
    var advertisedServiceUUIDs: [CBUUID] { get }
    
    /* ################################################################## */
    /**
     This allows the handler to "adopt" a service.
     
     - parameter inService: The discovered Core Bluetooth service.
     - parameter forPeripheral: The Core Bluetooth peripheral that "owns" the discovered service.
     - parameter andDevice: The Instance of the device that "owns" this service.
     - returns: An instance of a subclass of RVS_GTService, if it is handled by this instance, or nil, if not.
     */
    func handleDiscoveredService(_ inService: CBService, forPeripheral inPeripheral: CBPeripheral, andDevice: RVS_GTDevice) -> RVS_GTService!
}
