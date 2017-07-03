//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class DetallePersonaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var textViewInfoDetallePersona: UITextView!
    @IBOutlet weak var labelNombreDetallePersona: UILabel!
    @IBOutlet weak var labelInstitucionDetallePersona: UILabel!
    @IBOutlet weak var labelLugarPersonaDetallePersona: UILabel!
    @IBOutlet weak var labelRolDetallePersona: UILabel!
    @IBOutlet weak var imagenPersona: UIImageView!

    var nombrePersona:String!
    var charlasArray: NSArray!
    var institucion: String!
    var lugarPersona: String!
    var info:String!
    var rol:String!
    var imagen:UIImage!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelNombreDetallePersona.text = nombrePersona
        labelLugarPersonaDetallePersona.text = lugarPersona
        labelInstitucionDetallePersona.text = institucion
        labelRolDetallePersona.text = rol
        textViewInfoDetallePersona.text = info
        imagenPersona.image = imagen
}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return charlasArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
      let evento =  charlasArray.object(at: indexPath.row) as! Evento

        cell.labelTitulo.text = evento.nombre
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

