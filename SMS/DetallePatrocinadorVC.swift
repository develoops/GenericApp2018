//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class DetallePatrocinadorVC: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var fono: UITextView!
    @IBOutlet weak var web: UITextView!
    @IBOutlet weak var direccion: UITextView!
    @IBOutlet weak var imagenLlamar: UIImageView!
    @IBOutlet weak var imagenHeader: UIImageView!

    var nombrePatrocinador:String!
    var direc: String!
    var fon:String!
    var we:String!
    var info:String!
    var imagen:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextView.text = info
        direccion.text = direc
        fono.text = fon
        web.text = we
        imagenHeader.image = imagen
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

