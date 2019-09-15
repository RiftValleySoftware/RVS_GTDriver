/*
 This is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2 of the License, or
 (at your option) any later version.
 
 This Software is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this code.  If not, see <http: //www.gnu.org/licenses/>.
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import Foundation   // Required for the NS stuff.

/* ###################################################################################################################################### */
// MARK: - Debug Tools Protocol -
/* ###################################################################################################################################### */
/**
 This protocol is a "junk drawer" of vrious debug/testing tools.
 */
public protocol RVS_DebugTools {
    /* ################################################################## */
    /**
     This is used to see whether or not we are running under unit tests. It is optional, and isn't really supposed to be replaced.
     
     - returns: True, if we are currently in a unit test.
     */
    var isRunningUnitTests: Bool { get }
}

/* ###################################################################################################################################### */
// MARK: - Make Things Optional -
/* ###################################################################################################################################### */
extension RVS_DebugTools {
    /* ################################################################## */
    /**
     This is used to see whether or not we are running under unit tests.
     
     - returns: True, if we are currently in a unit test.
     */
    public var isRunningUnitTests: Bool {
        // Searches for an environment setting that describes the XCTest path (only present under unit test, and always present when under unit test).
        return nil != ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]
    }
}
