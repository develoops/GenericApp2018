//
//  CongresoNavViewController.swift
//  SMS
//
//  Created by Arturo Sanhueza on 14-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class CongresoNavViewController: UINavigationController,UINavigationControllerDelegate {

    var congreso:PFObject!
    
    override func viewDidLoad() {
                super.viewDidLoad()
        
    
        if let rootViewController = viewControllers.first as? CongresoTabBarVC {
            rootViewController.congreso = congreso
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
