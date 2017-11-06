//
//  AppDelegate.swift
//  SMS
//
//  Created by Arturo Sanhueza on 28-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Bolts
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        
        let defaults = UserDefaults.standard
        let contador = defaults.integer(forKey: "contadorInicio")
        defaults.set(contador + 1, forKey: "contadorInicio")
        defaults.synchronize()
        let configuration = ParseClientConfiguration {
            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "ClUXXsCBfTmS6E9zxXKck1oX4hYSC2pyHarv4U8E"
            $0.clientKey = "IZ08jbbJwcLnDlEh79edrsxNIcU0iM9FG6Uwpj92"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
      
//        PFAnonymousUtils.logInInBackground().continue({ (task:BFTask<PFUser>) -> Any? in
//            return task
//        })
        
        
        PFUser.enableAutomaticUser()
        let user = PFUser.current()
        user?.setValue(arc4random(), forKey: "nombreUsuario")
        PFUser.current()?.saveInBackground()
        let defaultACL = PFACL()
        
        defaultACL.getPublicReadAccess = true
        PFACL.setDefault(defaultACL, withAccessForCurrentUser:true)

        var localTimeZoneAbbreviation: String { return  NSTimeZone.local.abbreviation(for: Date())!
            
        }
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UIApplication.shared.registerForRemoteNotifications()

            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
            
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                }
        }
         else {
            if #available(iOS 7, *) {
                application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
            } else {
                let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
                let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
                
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
      
    return true
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    @objc(application:didRegisterForRemoteNotificationsWithDeviceToken:) func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
        PFPush.subscribeToChannel(inBackground: "globalChannel")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PFPush.handle(userInfo)
    }

       func applicationWillTerminate(_ application: UIApplication) {
    }
}

