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

/* ################################################################################################################################## */
// MARK: - Public Calculated Properties
/* ################################################################################################################################## */
/**
 This class extends the prefs class to provide persistent prefs storage.
 */
class RVS_BLEDriver_iOS_Test_Harness_Prefs: RVS_PersistentPrefs {
    /* ############################################################################################################################## */
    // MARK: - Internal Enums
    /* ############################################################################################################################## */
    /**
     These enums are for our keys.
     */
    enum Keys: String {
        /// This is the key for the "Use A Different Thread" pref.
        case useDifferentThread
        /// This is the key for the "Keep Scanning and Include Duplicates" pref.
        case continuousScan
        /// This is the key for "persistent connections." The device remains connected, once discovered.
        case persistentConnections
    }
    
    /* ############################################################################################################################## */
    // MARK: - Internal Calculated Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     - returns: True, if we are to use a thread for operation, other than the main one.
     */
    @objc dynamic var useDifferentThread: Bool {
        get {
            return values[Keys.useDifferentThread.rawValue] as? Bool ?? false
        }
        
        set {
            values[Keys.useDifferentThread.rawValue] = newValue
        }
    }
    
    /* ################################################################## */
    /**
     - returns: True, if we are to scan continuously, in spite of duplicates.
     */
    @objc dynamic var continuousScan: Bool {
        get {
            return values[Keys.continuousScan.rawValue] as? Bool ?? false
        }
        
        set {
            values[Keys.continuousScan.rawValue] = newValue
        }
    }
    
    /* ################################################################## */
    /**
     - returns: True, if we are supposed to maintain persistent connections.
     */
    @objc dynamic var persistentConnections: Bool {
        get {
            return values[Keys.persistentConnections.rawValue] as? Bool ?? false
        }
        
        set {
            values[Keys.persistentConnections.rawValue] = newValue
        }
    }
        
    /* ############################################################################################################################## */
    // MARK: - Public Calculated Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     An Array of String, containing the keys used to store and retrieve the values from persistent storage.
     */
    override public var keys: [String] {
        return [Keys.useDifferentThread.rawValue, Keys.continuousScan.rawValue, Keys.persistentConnections.rawValue]
    }
}
