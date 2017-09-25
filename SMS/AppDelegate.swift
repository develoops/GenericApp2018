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
//            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "iOXJQbQMF2gDMHb4sFHNGvaVkN3ILoLxPvvsAFVr"
            $0.clientKey = "UnHbd5aNiE89zalzgT1i8OtcHDdsTOVNMvYvowgm"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        return true
    }

       func applicationWillTerminate(_ application: UIApplication) {
    }
}

