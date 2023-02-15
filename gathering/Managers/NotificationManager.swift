//
//  NotificationManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-14.
//

import UIKit

struct NotificationManager {
    static let shared = NotificationManager()
    
    
    func requestForNotification(){
        
        // user notifications auth
        // all of this works for iOS 10+
        let options:UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Failed to request Auth:", error)
                return
            }
            
            if granted {
                print("Auth Granted")
            } else {
                print("Auth denied")
            }
        }
        
    }
    
}
