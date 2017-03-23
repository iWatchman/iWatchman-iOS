//
//  AppDelegate.swift
//  iWatchman
//
//  Created by Tejas Deshpande on 2/18/17.
//  Copyright © 2017 Tejas Deshpande. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            handleRemoteNotification(userInfo: remoteNotification as! [AnyHashable : Any])
        }
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Push Notification device token: \(deviceTokenString)")
        DataManager.sharedInstance.registerDeviceTokenForPushNotifications(deviceToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        handleRemoteNotification(userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable:Any]) {
        let remoteID = String(userInfo["id"] as! Int)
        let dateString = userInfo["date"] as! String
        
        let newEvent = Event(remoteID: remoteID, eventDateString: dateString)
        DataManager.sharedInstance.downloadThumbnail(event: newEvent, completionHandler: {(thumbnaukData) in})
        
        DispatchQueue.main.async {
            () -> Void in
            let realm = try! Realm()
            try! realm.write {
                realm.add(newEvent, update: true)
            }
        }
    
        NotificationCenter.default.post(name: NSNotification.Name.init("SHOW_EVENT_DETAIL"), object: newEvent)
        NotificationCenter.default.post(name: NSNotification.Name.init("RELOAD_COLLECTION_VIEW"), object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

