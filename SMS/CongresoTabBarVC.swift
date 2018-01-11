//
//  CongresoTabBarVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 12-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
class CongresoTabBarVC: UITabBarController,UITabBarControllerDelegate {

    var congreso:PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
    

//    let programaVC = storyboard.instantiateViewController(withIdentifier: "ProgramaVC") as! ProgramaVC
//    let speakerVC = storyboard.instantiateViewController(withIdentifier: "SpeakersVC") as! SpeakersVC
//    let favsVC = storyboard.instantiateViewController(withIdentifier: "FavoritosVC") as! FavoritosVC
//    let moreVC = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        


//        self.viewControllers = [programaVC,speakerVC,favsVC,moreVC]

        if let rootViewController = viewControllers?.first as? ProgramaVC {
            rootViewController.congreso = congreso
            
        }
        if let second = viewControllers?[1] as? SpeakersVC {
            second.congreso = congreso
        }
        
        if let third = viewControllers?[2] as? FavoritosVC {
            third.congreso = congreso
        }
        
        if let cuarto = viewControllers?.last as? MoreVC {

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
