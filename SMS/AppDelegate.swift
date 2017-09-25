//
//  AppDelegate.swift
//  SMS
//
//  Created by Arturo Sanhueza on 28-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData
import Bolts
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "fJdyYQHNfWWqvC1NbgqlMTvNhbpWWFynRhYWt3oT"
            $0.clientKey = "Kt8tpCc4XK3APky1JsHa53fYjHMwWK9bCMPy7FvC"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)        
        return true
    }

       func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SMS")
        
        let seededData: String = "SMS"
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let storeurl = URL(fileURLWithPath: paths).appendingPathComponent("SMS.sqlite")
        
        if(!FileManager.default.fileExists(atPath: storeurl.path)){
            
            var preloadUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource:"SMS", ofType: "sqlite")!)
            do {
                try FileManager.default.copyItem(at: preloadUrl, to: storeurl)
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }

        if !FileManager.default.fileExists(atPath: (storeurl.path)) {
            let seededDataUrl = Bundle.main.url(forResource: seededData, withExtension: "sqlite")
            try! FileManager.default.copyItem(at: seededDataUrl!, to: storeurl)
            
        }
        
        
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeurl)]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error \(error),")
            }
        })
        
        return container
        
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

