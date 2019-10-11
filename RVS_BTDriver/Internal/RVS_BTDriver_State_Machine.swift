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

/* ###################################################################################################################################### */
// MARK: - State Machine Protocol Enum -
/* ###################################################################################################################################### */
/**
 This is an enum that is used to indicate the state of the instance that conforms to the RVS_BTDriver_State_Machine protocol.
 */
internal enum RVS_BTDriver_State_Machine_StateEnum {
    /// Brand, spankin' new.
    case uninitialized
    /// Leave me alone, I'm busy.
    case initializationInProgress
    /// Ready for Freddy!
    case initialized
    /// Uh...little problem, here...
    case error
}

/* ###################################################################################################################################### */
// MARK: - State Machine Protocol -
/* ###################################################################################################################################### */
/**
 This protocol is an optional protocol that implements a "state machine," where an instance can go from "unitialized," to "initialized."
 */
internal protocol RVS_BTDriver_State_Machine {
    /* ################################################################## */
    /**
     This is the type for a callback of the state machine.
     
     - parameter stateMachine: The state machine making the call.
     */
    typealias RVS_BTDriver_State_MachineCallback = (_ stateMachine: RVS_BTDriver_State_Machine) -> Void
    
    /* ################################################################## */
    /**
     This is the state of the instance.
     */
    var state: RVS_BTDriver_State_Machine_StateEnum { get }
    
    /* ################################################################## */
    /**
     This is a callback that is called whenever the state changes. It's basically a subscriber.
     
     This can be called in non-main threads.
     */
    var callBack: RVS_BTDriver_State_MachineCallback! { get set }
    
    /* ################################################################## */
    /**
     Start whatever process is necessary to initialize.
     */
    func startInit()
    
    /* ################################################################## */
    /**
     Called if there was a connection, before initializing.
     */
    func connectedPreInit()
    
    /* ################################################################## */
    /**
     Stop the initialization process.
     */
    func abortInit()
    
    /* ################################################################## */
    /**
     Called if there was a connection, after initializing.
     */
    func connectedPostInit()
}

/* ###################################################################################################################################### */
// MARK: - State Machine Protocol Default Implementations -
/* ###################################################################################################################################### */
/**
 These just make the above "optional."
 */
extension RVS_BTDriver_State_Machine {
    /* ################################################################## */
    /**
     Default Implementation returns uninitialized.
     */
    var state: RVS_BTDriver_State_Machine_StateEnum {
        return .uninitialized
    }

    /* ################################################################## */
    /**
     Default Implementation is nil.
     */
    var callBack: RVS_BTDriver_State_MachineCallback! {
        return nil
    }

    /* ################################################################## */
    /**
     Default Implementation does nothing.
     */
    func startInit() { }
    
    /* ################################################################## */
    /**
     Default Implementation does nothing.
     */
    func connectedPreInit() { }
    
    /* ################################################################## */
    /**
     Default Implementation does nothing.
     */
    func abortInit() { }
}
