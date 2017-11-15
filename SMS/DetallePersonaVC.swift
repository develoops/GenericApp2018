//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class DetallePersonaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var textViewInfoDetallePersona: UITextView!
    @IBOutlet weak var labelNombreDetallePersona: UILabel!
    @IBOutlet weak var labelInstitucionDetallePersona: UILabel!
    @IBOutlet weak var labelLugarPersonaDetallePersona: UILabel!
    @IBOutlet weak var labelRolDetallePersona: UILabel!
    @IBOutlet weak var imagenPersona: UIImageView!

    var nombrePersona:String!
    var congreso:PFObject!
    var charlasArray: [PFObject]!
    var personasCharla:[AnyObject] = []
    var institucion: String!
    var lugarPersona: String!
    var info:String!
    var rol:String!
    var imagenFile:PFFile!
    var imagen:UIImage!
    var tamanoCelda = CGFloat()
    var dateFormatter = DateFormatter()
    var personas = [PFObject]()
    var roles = [String]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelNombreDetallePersona.text = nombrePersona
        labelLugarPersonaDetallePersona.text = lugarPersona
        
        labelInstitucionDetallePersona.text = institucion

        labelRolDetallePersona.text = rol
        textViewInfoDetallePersona.text = info
        
        if(imagen != nil){
            imagenPersona.image = imagen
            
        }
        else{
          imagenFile.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
            
            DispatchQueue.main.async {
                
            
            self.imagenPersona.image = UIImage(data: task.result! as Data)
            }
            return task
            })
        }
        
        labelNombreDetallePersona.textColor = UIColor.white
        labelLugarPersonaDetallePersona.textColor = UIColor.white
        labelInstitucionDetallePersona.textColor = UIColor.white
        labelRolDetallePersona.textColor = UIColor.white

        
        labelNombreDetallePersona.font = UIFont.systemFont(ofSize: 16.0)
        labelLugarPersonaDetallePersona.font = UIFont.systemFont(ofSize: 14.0)
        labelInstitucionDetallePersona.font = UIFont.systemFont(ofSize: 14.0)
        labelRolDetallePersona.font = UIFont.systemFont(ofSize: 14.0)
        
        textViewInfoDetallePersona.font = UIFont.systemFont(ofSize: 14.0)
        
        imagenPersona.frame.origin = CGPoint(x: 20.0, y: 84.0)
        labelNombreDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.width + 45.0, y: 84.0)
        
        if(labelInstitucionDetallePersona.text ==  "" || labelInstitucionDetallePersona.text ==  nil){
            
            
        labelRolDetallePersona.frame = CGRect(x: imagenPersona.frame.width + 45.0, y: labelNombreDetallePersona.frame.origin.y + labelNombreDetallePersona.frame.size.height, width: 100.0, height: 30.0)
            labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.width + 45.0, y: labelRolDetallePersona.frame.origin.y + labelRolDetallePersona.frame.size.height)

        }
        else {
            labelInstitucionDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.width + 45.0, y: 99.0 + labelNombreDetallePersona.frame.size.height)
            labelInstitucionDetallePersona.frame.size = CGSize(width: 30.0, height: 30.0)

            labelRolDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.width + 45.0, y: 104.0 + labelInstitucionDetallePersona.frame.size.height  + labelNombreDetallePersona.frame.size.height)
            labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.width + 45.0, y: 109.0 + labelRolDetallePersona.frame.size.height + labelInstitucionDetallePersona.frame.size.height + labelNombreDetallePersona.frame.size.height)
        }
        

      
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.labelLugarPersonaDetallePersona.frame.origin.y + self.labelLugarPersonaDetallePersona.frame.size.height + 30.0))
        colorFondoHeaderDetalle.backgroundColor = UIColor.lightGray
        
        textViewInfoDetallePersona.frame.origin = CGPoint(x: 20.0, y: self.labelLugarPersonaDetallePersona.frame.origin.y + self.labelLugarPersonaDetallePersona.frame.size.height + 30.0)
        textViewInfoDetallePersona.frame.size = CGSize(width: view.frame.width - 20.0, height: 0.0)
        
        textViewInfoDetallePersona.sizeToFit()
        
        
        if(textViewInfoDetallePersona.text == ""){
        
            self.tabla.frame.origin = CGPoint(x: 0.0, y: colorFondoHeaderDetalle.frame.origin.y + colorFondoHeaderDetalle.frame.size.height)

        }
        else{
            self.tabla.frame.origin = CGPoint(x: 0.0, y: textViewInfoDetallePersona.frame.origin.y + textViewInfoDetallePersona.frame.size.height)
self.tabla.frame.size = CGSize(width: view.frame.size.width, height: view.frame.height - (textViewInfoDetallePersona.frame.origin.y + textViewInfoDetallePersona.frame.size.height + 30))
        }
        

        tabla.tableFooterView = UIView()

        self.view.addSubview(colorFondoHeaderDetalle)
        view.sendSubview(toBack: colorFondoHeaderDetalle)
}
    
    override func viewDidAppear(_ animated: Bool) {
        roles = []
        personas = []
        for act in charlasArray {
            
            let personaQuery = PFQuery(className: "PersonaRolAct", predicate: NSPredicate(format: "act == %@", act))
            personaQuery.fromLocalDatastore()
            personaQuery.includeKey("persona")
            personaQuery.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
                
                let object = [act,task.result]
                
                self.personasCharla.append(object as AnyObject)
                DispatchQueue.main.async {
                    
                    self.tabla.reloadData()
                }
                return task
            })
        }
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let charlasArray = charlasArray {
            return charlasArray.count
        }

        else{
         
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda + 20.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let evento =  charlasArray[indexPath.row]
        
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)
        
        cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        cell.labelTitulo?.frame = CGRect(x: 38.0, y: 20.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelTitulo.text = evento["nombre"] as? String
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 114.0), height: 40000.0)
        
        cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelHora?.frame =  CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 35.0, width: 0.0, height: 0.0)
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora.sizeThatFits(maximumLabelSizeHora)
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()
        
        let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
        cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelLugar?.frame = CGRect(x: 65.0 + cell.labelHora.frame.width, y: cell.labelTitulo.frame.size.height + 35.0, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width), height: 40.0)
        cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
        cell.labelLugar.text = evento["lugar"] as? String
        cell.labelLugar?.textAlignment = .left
        cell.labelLugar.numberOfLines = 0
        cell.labelLugar?.sizeToFit()
        
        var personasTamano = Int()
        
        let personaActividad = personasCharla[safe: indexPath.row]
        
        if(evento == personaActividad?.firstObject as? PFObject){
            
            let personasAct = personaActividad?.lastObject as! [PFObject]
        
            var personasString = String()

            for object in (personasAct){

                let persona = object["persona"] as! PFObject

                personasString.append((persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String) + "\n")
                personasTamano = personasTamano + (28 / (personaActividad?.count)!)
            }
            let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - 152.0), height: 40000.0)
            cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelSpeaker1?.frame = CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 60.0, width: 0.0, height: 0.0)
            cell.labelSpeaker1.sizeThatFits(maximumLabelSizePonente)
            cell.labelSpeaker1.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelSpeaker1.text = personasString
            cell.labelSpeaker1.numberOfLines = 0
            cell.labelSpeaker1?.textAlignment = .left
            cell.labelSpeaker1?.sizeToFit()

        }
        else{
            cell.labelSpeaker1.text = ""
        }
        tamanoCelda = cell.labelTitulo.frame.height + cell.labelLugar.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + CGFloat(personasTamano)
        
        var colorImage = UIColor()
        if(evento["tipo"] as? String == "conferencia")
        {
            colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as? String == "social") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
        else{
            colorImage = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }
        
        cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 10.0, height:tamanoCelda))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let evento =  charlasArray[indexPath.row] 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)
        
        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.evento = evento
        
        let personaActividad = personasCharla[indexPath.row]
        let personasAct = personaActividad.lastObject as! [PFObject]
            for object in (personasAct){
                
                roles.append(object["rol"] as! String)
                let persona = object["persona"] as! PFObject
                personas.append(persona)

        }
        
        vc.personas = personas
        vc.roles = roles
        
        if(evento["tipo"] as? String == "conferencia")
        {
            vc.colorFondo = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as? String == "social") {
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
        else if (evento["tipo"] as? String == "break") {
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
            
        else{
            vc.colorFondo = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }
        vc.congreso = congreso
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 2.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
        
}

    extension Collection where Indices.Iterator.Element == Index {
        subscript (safe index: Index) -> Iterator.Element? {
            return indices.contains(index) ? self[index] : nil
        }
}


