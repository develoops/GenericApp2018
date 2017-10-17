//
//  TabBarAppVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 12-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class TabBarAppVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navCongreso = storyboard.instantiateViewController(withIdentifier: "navCongresos") as! UINavigationController
        let navSociedad = storyboard.instantiateViewController(withIdentifier: "navSociedad") as! UINavigationController
        let navDirectiva = storyboard.instantiateViewController(withIdentifier: "navDirectiva") as! UINavigationController

        viewControllers = [navCongreso,navSociedad,navDirectiva]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
