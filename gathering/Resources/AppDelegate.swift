//
//  AppDelegate.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-10.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        attemptRegisterForNotifications(application: application)
        return true
    }
    

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


extension AppDelegate:MessagingDelegate,UNUserNotificationCenterDelegate {
    
    private func attemptRegisterForNotifications(application:UIApplication) {
        // MARK: - Firebase Notification
        let messaging = Messaging.messaging()
        messaging.delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }

    
}
