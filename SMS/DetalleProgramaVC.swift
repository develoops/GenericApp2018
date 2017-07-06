//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class DetalleProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tabla: UITableView!
    
    @IBOutlet weak var labelTituloDetallePrograma: UILabel!
    @IBOutlet weak var labelHoraDetallePrograma: UILabel!
    @IBOutlet weak var labelDiaDetallePrograma: UILabel!
    @IBOutlet weak var labelLugarDetallePrograma: UILabel!
    @IBOutlet weak var textViewInfoDetallePrograma: UITextView!
    @IBOutlet weak var botonMapa: UIButton!

    var tituloCharla:String!
    var hora: String!
    var dia:String!
    var lugar:String!
    var info:String!
    var ponentesArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTituloDetallePrograma.text = tituloCharla
        labelHoraDetallePrograma.text = hora
        labelLugarDetallePrograma.text = lugar
        labelDiaDetallePrograma.text = dia
        labelLugarDetallePrograma.text = lugar
        textViewInfoDetallePrograma.text = info
        botonMapa.addTarget(self, action: #selector(irAMapa), for: .touchUpInside)

    }

    func irAMapa()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.nombreMapa = "mapa_enjoyvina_ballroom.png"
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ponentesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let persona = ponentesArray.object(at: indexPath.row) as! Persona
        
        cell.labelNombre.text = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!

        cell.labelRol.text = persona.rol
        if (persona.imagenPerfil?.length == 4) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            cell.imagenPerfil.image = UIImage(data: persona.imagenPerfil! as Data)
        }

        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

