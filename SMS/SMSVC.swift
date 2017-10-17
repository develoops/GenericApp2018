//
//  SMSVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class SMSVC: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var fono: UITextView!
    @IBOutlet weak var mail: UITextView!
    @IBOutlet weak var web: UITextView!
    @IBOutlet weak var direccion: UITextView!
    @IBOutlet weak var imagenLlamar: UIImageView!
    @IBOutlet weak var imagenHeader: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
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
