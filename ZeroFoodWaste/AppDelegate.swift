//
//  AppDelegate.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 26/4/2023.
//
// https://www.kodeco.com/11395893-push-notifications-tutorial-getting-started#toc-anchor-001


import UIKit
import Firebase
import CoreData

import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var databaseController: DatabaseProtocol?
    var persistentContainer: NSPersistentContainer?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        persistentContainer = NSPersistentContainer(name: "ZFW-DataModel")
        persistentContainer?.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load CoreData stack with error: \(error)")
            }
        }
        
        
        databaseController = FirebaseController()
        
        checkForPermission()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func checkForPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if !granted {
                print("Permission was not granted")
                return
            }
            else {
                print("PermissionGranted: \(granted)")
                let notificationContent = UNMutableNotificationContent()
                
                notificationContent.title = "This is a notification"
                notificationContent.body = "you have a notification!! woowowooww!!!!"
                
                let timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: timeInterval)
                
                                
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current

                dateComponents.second = 5


                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                
//                let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("Errorororoorororrrrrrrrr: \(error)")
                    }
                }

            }
        }
    }
    
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings{ settings in print("Notification settings: \(settings)")
//
//        }
//    }


}

