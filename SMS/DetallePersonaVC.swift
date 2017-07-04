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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
      let evento =  charlasArray.object(at: indexPath.row) as! Evento

        let fechaInicio = dateFormatter.string(from: evento.inicio!.addingTimeInterval(-978296400) as Date)
        let fechaFin = dateFormatter.string(from: evento.fin!.addingTimeInterval(-978296400) as Date )
        

        cell.labelTitulo.text = evento.nombre
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelLugar.text = evento.lugar
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let evento =  charlasArray.object(at: indexPath.row) as! Evento
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMMM"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.string(from: evento.inicio!.addingTimeInterval(-978296400) as Date)
        let fechaFin = dateFormatter.string(from: evento.fin!.addingTimeInterval(-978296400) as Date )
        
        vc.tituloCharla = evento.nombre
        vc.dia = dateFormatter2.string(from: evento.inicio! as Date)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.lugar = evento.lugar
        vc.ponentesArray = (evento.personas?.allObjects)! as NSArray
        vc.info = evento.descripcion
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

