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

import Foundation

/* ###################################################################################################################################### */
// MARK: - RVS_BTDriver_Device -
/* ###################################################################################################################################### */
/**
 */
class RVS_BTDriver_Device: RVS_BTDriver_DeviceProtocol {
    /* ################################################################################################################################## */
    // MARK: - RVS_BTDriver_Device Sequence Support -
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This contains instances that have not yet passed a credit check.
     */
    private var _holding_pen: [RVS_BTDriver_Service] = []
    
    /* ################################################################## */
    /**
     This contains the service list for this instance of the driver.
     */
    private var _service_list: [RVS_BTDriver_Service] = []
}

/* ###################################################################################################################################### */
// MARK: -
/* ###################################################################################################################################### */
/**
 */
extension RVS_BTDriver_Device {
    /* ################################################################## */
    /**
     This is the public read-only access to the service list.
     */
    public var services: [RVS_BTDriver_ServiceProtocol] {
        return _service_list
    }
    
    /* ################################################################## */
    /**
     This is the read-only count of services.
     */
    public var count: Int {
        return _service_list.count
    }

    /* ################################################################## */
    /**
     This is a public read-only subscript to the service list.
     */
    public subscript(_ inIndex: Int) -> RVS_BTDriver_ServiceProtocol {
        precondition((0..<_service_list.count).contains(inIndex), "Index Out of Range")
        return services[inIndex]
    }
}
