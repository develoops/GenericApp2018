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
        Thread.sleep(forTimeInterval: 4.0)
        
        let configuration = ParseClientConfiguration {
            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "ClUXXsCBfTmS6E9zxXKck1oX4hYSC2pyHarv4U8E"
            $0.clientKey = "IZ08jbbJwcLnDlEh79edrsxNIcU0iM9FG6Uwpj92"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        let query2 = PFQuery(className: "Actividad")
        query2.includeKey("lugar")
        let query = PFQuery(className: "ActContAct")
        query.includeKey("contenido")
        query.includeKey("contenedor")
        
        let query4 = PFQuery(className: "Org")
        let query5 = PFQuery(className: "PersonaRolOrg")
        let query7 = PFQuery(className: "Media")

        let query6 = PFQuery(className: "PersonaRolAct")
        query6.includeKey("act")
        query6.includeKey("persona")
        
        let query3 = PFQuery(className: "Persona")
        query3.includeKey("pais")


        query.limit = 1000
        query2.limit = 1000
        query3.limit = 1000
        query4.limit = 1000
        query5.limit = 1000
        query6.limit = 1000
        query7.limit = 1000
        
        let  queryCollections = [query2,query,query3,query4,query5,query6,query7]
        
        
        
        let tasks = queryCollections.map{$0.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
        
            
            return task
        })
    }
        PFAnonymousUtils.logInInBackground().continue({ (task:BFTask<PFUser>) -> Any? in
            
            return task
        })
        
        var localTimeZoneAbbreviation: String { return  NSTimeZone.local.abbreviation(for: Date())! }
        
        print(Date.init(timeIntervalSinceNow: -(60*60*3)))
        
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
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task -> Any? in
            
            PFObject.pinAll(inBackground: (task.result as! [PFObject])).continue(successBlock: { (i:BFTask<NSNumber>) -> Any? in
                
                    print(i)
            })
        
        })
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

       
    func fetchAsync(object: PFQuery<PFObject>) -> BFTask<AnyObject> {
        let task = BFTaskCompletionSource<AnyObject>()
        object.findObjectsInBackground()
        return task.task
    }

       func applicationWillTerminate(_ application: UIApplication) {
    }
}

