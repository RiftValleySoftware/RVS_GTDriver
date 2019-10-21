//
//  NotificationController.swift
//  RVS_BTDriver_WatchOS_Test_Harness (Direct) WatchKit Extension
//
//  Created by Chris Marshall on 10/21/19.
//  Copyright © 2019 The Great Rift Valley Software Company. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
#if !DIRECT // We declare the DIRECT preprocessor macro in the target settings.
    import RVS_BTDriver_WatchOS
#endif

class RVS_BTDriver_WatchOS_Test_Harness_NotificationController: WKUserNotificationInterfaceController {

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
}
