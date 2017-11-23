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
     
        if let rootViewController = viewControllers?.first as? ProgramaVC {
            rootViewController.congreso = congreso
            
        }
        if let second = viewControllers?[1] as? SpeakersVC {
            second.congreso = congreso
        }
        
        if let third = viewControllers?[2] as? FavoritosVC {
            third.congreso = congreso
        }
        
        if let quinto = viewControllers?[3] as? DirectorioVC {
            quinto.congreso = congreso
        }
        
        if let sexto = viewControllers?[4] as? MaterialesVC {
            sexto.congreso = congreso
        }
        
        if let septimo = viewControllers?[5] as? EncuestaGeneralVC {
            septimo.tipoEncuesta = "general"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
