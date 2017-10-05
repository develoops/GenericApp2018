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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        
        let configuration = ParseClientConfiguration {
            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "7HdRvQNLc5PS3NQ4gTRUAeTMrgaTkKdx7T1G4rZR"
            $0.clientKey = "rxSe7SYEgYprtm0i1jy1cxpNwT8gGqkBVbuH75j1"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        let query2 = PFQuery(className: "Actividad")
        let query = PFQuery(className: "ActContAct")
        let query3 = PFQuery(className: "Persona")
        let query4 = PFQuery(className: "Org")


        let  queryCollections = [query,query2,query3,query4]
        
        _ = queryCollections.map{$0.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
        
            return PFObject.pinAll(inBackground: task.result as? [PFObject])
        })
    }
        
        
        
    return true
    }

    
       
    func fetchAsync(object: PFQuery<PFObject>) -> BFTask<AnyObject> {
        let task = BFTaskCompletionSource<AnyObject>()
        object.findObjectsInBackground()
        return task.task
    }

       func applicationWillTerminate(_ application: UIApplication) {
    }
}

