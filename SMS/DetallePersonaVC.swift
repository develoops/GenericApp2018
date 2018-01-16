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
    var funcionesPersona: [String]!
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
        funcionesPersona = ["Sesiones","Materiales","Evaluar","Preguntar"]
        self.tabla.separatorColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.6)
        self.tabla.isScrollEnabled = false
        textViewInfoDetallePersona.text = info
        self.textViewInfoDetallePersona.frame = CGRect(x: 15.0, y: self.tabla.frame.maxY + 2.5, width:self.view.frame.size.width - 15.0, height: 0.0)
        
        if(imagen != nil){
            imagenPersona.image = imagen
        }
        else{
          imagenFile.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
            
            DispatchQueue.main.async {
                
                if (task.error != nil){
                    self.imagenPersona.image = UIImage(named: "Ponente_ausente_Hombre.png")
                    
                }
                else{
                    
                    self.imagenPersona.image = UIImage(data: (task.result as Data?)!)
                    
                }}
            return task
            }
        }
        imagenPersona.layer.cornerRadius = (imagenPersona.frame.size.width) / 2
        imagenPersona.layer.masksToBounds = true

        labelNombreDetallePersona.textColor = UIColor.white
        labelLugarPersonaDetallePersona.textColor = UIColor.white
        labelInstitucionDetallePersona.textColor = UIColor.white
        labelRolDetallePersona.textColor = UIColor.white

        
        labelNombreDetallePersona.font = UIFont.systemFont(ofSize: 15.0)
        labelLugarPersonaDetallePersona.font = UIFont.systemFont(ofSize: 15.0)
        labelInstitucionDetallePersona.font = UIFont.systemFont(ofSize: 15.0)
        labelRolDetallePersona.font = UIFont.systemFont(ofSize: 15.0)
        textViewInfoDetallePersona.font = UIFont.systemFont(ofSize: 14.0)
        
        imagenPersona.frame.origin = CGPoint(x: 15.0
            , y: 79.0)

        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - (imagenPersona.frame.maxX + 30.0)), height: 40000.0)
        labelNombreDetallePersona.sizeThatFits(maximumLabelSizeTitulo)
        labelNombreDetallePersona.text = nombrePersona
        labelNombreDetallePersona?.textAlignment = .left
        labelNombreDetallePersona.numberOfLines = 0
        labelNombreDetallePersona?.sizeToFit()

        
        let maximumLabelSizeInstitucion = CGSize(width: (self.view.frame.size.width - (imagenPersona.frame.maxX + 30.0)), height: 40000.0)
        labelInstitucionDetallePersona.sizeThatFits(maximumLabelSizeInstitucion)
        labelInstitucionDetallePersona.text = institucion
        labelInstitucionDetallePersona?.textAlignment = .left
        labelInstitucionDetallePersona.numberOfLines = 0
        labelInstitucionDetallePersona?.sizeToFit()

        let maximumLabelSizeLugar = CGSize(width: (self.view.frame.size.width - (imagenPersona.frame.maxX + 30.0)), height: 40000.0)
        labelLugarPersonaDetallePersona.sizeThatFits(maximumLabelSizeLugar)
        labelLugarPersonaDetallePersona.text = lugarPersona
        labelLugarPersonaDetallePersona?.textAlignment = .left
        labelLugarPersonaDetallePersona.numberOfLines = 0
        labelLugarPersonaDetallePersona?.sizeToFit()
        
        labelRolDetallePersona.text = rol

        let maximumLabelSizeRol = CGSize(width: (self.view.frame.size.width - (imagenPersona.frame.maxX + 30.0)), height: 40000.0)
        labelRolDetallePersona.sizeThatFits(maximumLabelSizeRol)
        labelRolDetallePersona.text = rol
        labelRolDetallePersona?.textAlignment = .left
        labelRolDetallePersona.numberOfLines = 0
        labelRolDetallePersona?.sizeToFit()
        
        labelNombreDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: 79.0)
        
        if(labelInstitucionDetallePersona.text ==  "" || labelInstitucionDetallePersona.text ==  nil){
        
        labelRolDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelNombreDetallePersona.frame.maxY + 5.0)
           
            if((labelRolDetallePersona.text == "") || labelRolDetallePersona.text == nil){
                
                labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelRolDetallePersona.frame.maxY)
                
            }
            else{
                labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelRolDetallePersona.frame.maxY + 5.0)
                
            }

        }
        else {
            labelInstitucionDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelNombreDetallePersona.frame.maxY + 5.0)

            labelRolDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y:labelInstitucionDetallePersona.frame.maxY + 5.0)
            
            if((labelRolDetallePersona.text == "") || labelRolDetallePersona.text == nil){
                
                labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelRolDetallePersona.frame.maxY)

            }
            else{
                labelLugarPersonaDetallePersona.frame.origin = CGPoint(x: imagenPersona.frame.maxX + 15.0, y: labelRolDetallePersona.frame.maxY + 5.0)
                
            }
        }
        
      
        var coordenadaFinalY = CGFloat()
    
        if(self.labelLugarPersonaDetallePersona.frame.maxY > self.imagenPersona.frame.maxY){
            
            coordenadaFinalY = self.labelLugarPersonaDetallePersona.frame.maxY + 15.0
            
        }
        else{
            
            coordenadaFinalY = self.imagenPersona.frame.maxY + 15.0
        }
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: coordenadaFinalY))
        
        let colorFondo = UIColor(red: 186.0/255.0, green: 119.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        colorFondoHeaderDetalle.backgroundColor = colorFondo

        textViewInfoDetallePersona.frame.origin = CGPoint(x: 10.0, y:colorFondoHeaderDetalle.frame.maxY + 7.5)
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
        if charlasArray != nil{
        for act in charlasArray {
            
            let personaQuery = PFQuery(className: "PersonaRolAct", predicate: NSPredicate(format: "act == %@", act))
            personaQuery.fromLocalDatastore()
            personaQuery.includeKey("persona")
            personaQuery.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
                
                let object = [act,task.result]
                
                self.personasCharla.append(object as AnyObject)
                DispatchQueue.main.async {
                    
                    self.tabla.reloadData()
                }
                return task
            }
        }}}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let funcionesPersona = funcionesPersona {
            return funcionesPersona.count
            
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 37.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let funcion = funcionesPersona[indexPath.row]
        cell.labelTitulo?.frame = CGRect(x: 15.0, y: 11.25, width: view.frame.size.width - 100.0, height:0.0)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 15.0)
        cell.labelTitulo.text = funcion
        
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)
        cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)
        if (funcion == "Sesiones" || funcion == "Materiales") {
            cell.accessoryType = .disclosureIndicator
            cell.labelTitulo.textColor = UIColor.darkText

        }
        else{
            cell.accessoryType = .none
            cell.labelTitulo.textColor = UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        }

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


