//
//  DetalleMaterialesVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 16-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class DetalleMaterialesVC: UIViewController,UIWebViewDelegate {

    var media:PFObject!
    var webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.frame = view.frame
        self.webView.scalesPageToFit = true
        self.view.backgroundColor = UIColor.white
        if((media.value(forKey: "tipo") as! String) == "url"){
            
            webView.loadRequest(URLRequest(url: URL(string: media.value(forKey: "url") as! String)!))

        }
        else if((media.value(forKey: "tipo") as! String) == "pdf"){
        
            let mediaFile = media["archivo"] as! PFFile
            webView.loadRequest(URLRequest(url: URL(string: mediaFile.url!)!))
            
        }
        
        self.view.addSubview(webView)
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
