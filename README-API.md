![Icon](./icon.png)
PRIVATE BRANCH REPO
-

RVS_BTDriver PUBLIC API DOCUMENTATION
=
This project is an open-source, low-level native Cocoa ([iOS](https://apple.com/ios), [macOS](https://apple.com/macos), [watchOS](https:apple.com/watchos) and [tvOS](https://apple.com/tvos)) [BLE (**B**luetooth **L**ow **E**nergy)](https://www.bluetooth.com) driver for mesh communication devices, like the  [goTenna](https://gotenna.com) devices.

Internal Documentation Links:
-

- [This is the documentation site for the public project internals.](https://riftvalleysoftware.github.io/RVS_GTDriver/internal/)

WHERE THIS DRIVER FITS
=

![Overall Image](./img/SystemBlock.png)
This is where the driver project fits in our system.

The driver is a low-level transport abstraction layer. It is Bluetooth-specific, but is designed to abstract between [Bluetooth LE](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy) and Bluetooth BR/EDR ("Classic"); presenting a common object model of data and interactions with Bluetooth devices.

SIMPLE API
-
The job of the driver is to *abstract* the general Bluetooth structure, and present a set of [Swift Protocols](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html), in a hierarchical arrangement.

The user of the API will instantiate an instance of RVS_BTDriver, which will, in turn, present collections of "devices" (RVS_BTDriver_DeviceProtocol), which will contain "Services" (RVS_BTDriver_ServiceProtocol), which will aggregate "properties" (RVS_BTDriver_PropertyProtocol).

EXAMPLE MENTAL MODEL OF THE DRIVER
-
![Block Diagram](./img/MentalModel.png)
This is an example of how the driver might present three goTenna devices (two Mesh devices and a Pro).

REQUIREMENTS
-
The Driver is provided as a [Swift](https://developer.apple.com/swift/)-only shared dynamic [framework](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Frameworks.html).

This is meant for [iOS](https://www.apple.com/ios/), [macOS](https://www.apple.com/macos/), [watchOS](https://www.apple.com/watchos/), [tvOS](https://www.apple.com/tvos/) and [ipadOS](https://www.apple.com/ipados/) only.

USING THE DRIVER
-
In order to establish a connection to supported devices, you will need to include the driver module into your application:

**TODO - ADD DETAILS ON INTEGRATION**

You then need to instantiate the `RVS_BTDriver` class:

    let driverInstance = RVS_BTDriver(delegate: <REQUIRED: YOUR DELEGATE INSTANCE>,
                                         queue: <OPTIONAL: ALTERNATIVE DISPATCH QUEUE>,
                      allowDuplicatesInBLEScan: <OPTIONAL: TRUE IF WE ALLOW THE SCAN TO INCLUDE DUPLICATES>,
                                 stayConnected: <OPTIONAL: TRUE IF WE WANT THE DRIVER TO MAINTAIN A CONNECTION AFTER DISCOVERY AND INITIAL QUERY>)


The above parameters are:
- `delegate`: The delegate to be used with this instance. It cannot be nil, and is a weak reference.
- `queue`: This is a desired queue for the CB manager to operate from. It is optional, and default is nil (main queue).
- `allowDuplicatesInBLEScan`: This is a flag that specifies that the scanner can be continuously running, and "re-finding" duplicate devices.  If true, it could adversely affect battery life. Default is false.
- `stayConnected`:  This is set to true, if you want all your device connections to be persistent. That is, once connected, they must be explicitly disconencted by the user. Otherwise, each device will be connected only while interacting. This is optional. Default is false.

At minimum, you need to have a delegate. The driver uses the [Delegation](https://en.wikipedia.org/wiki/Delegation_pattern) pattern and the [Observer](https://en.wikipedia.org/wiki/Observer_pattern) pattern to operate.

**EXAMPLE PROJECTS:**

The four test harness projects, supplied with the driver, are designed to provide high-quality, easy-to-understand examples of using the driver:

- [The MacOS Test Harness Project](https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_MacOS_Test_Harness) ([Documentation](https://riftvalleysoftware.github.io/RVS_GTDriver/macOSTestHarness))
- [The WatchOS Test Harness Project](https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_WatchOS_Test_Harness)
- [The iOS/iPadOS Test Harness Project](https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_iOS_Test_Harness)
- [The TVOS Test Harness Project](https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_tvOS_Test_Harness)

LICENSE
-
© Copyright 2019, [The Great Rift Valley Software Company](https://riftvalleysoftware.com)

[MIT License](https://opensource.org/licenses/MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
