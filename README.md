![Icon](./icon.png)

PRIVATE BRANCH REPO
-

RVS_BTDriver (in GitHub as RVS_GTDriver, for Historical Reasons)
=
This project is an open-source, low-level native Cocoa ([iOS](https://apple.com/ios), [macOS](https://apple.com/macos), [watchOS](https:apple.com/watchos) and [tvOS](https://apple.com/tvos)) [BLE (**B**luetooth **L**ow **E**nergy)](https://www.bluetooth.com) driver for mesh communication devices, like the  [goTenna](https://gotenna.com) devices.

Documentation Links:
-

- [This is the documentation site for the public API.](https://riftvalleysoftware.github.io/RVS_GTDriver/)
- [This is the documentation site for the public project internals.](https://riftvalleysoftware.github.io/RVS_GTDriver/internal/)

NOT A DEVICE DRIVER 
-
RVS_BTDriver is a low-level native Swift (Apple) driver. It is not a "device driver," which usually sit at an operating system level (kernel or user space). It is designed to translate between a bluetooth connection to a device, and a user application; presenting an object model of the device.

REQUIREMENTS
-
The Driver is provided as a [Swift](https://developer.apple.com/swift/)-only shared dynamic [framework](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Frameworks.html).

This is meant for [iOS](https://www.apple.com/ios/), [macOS](https://www.apple.com/macos/), [watchOS](https://www.apple.com/watchos/), [tvOS](https://www.apple.com/tvos/) and [ipadOS](https://www.apple.com/ipados/) only.

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
