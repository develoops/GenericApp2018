//
//  FavoritosVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class FavoritosVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
        
    @IBOutlet weak var tabla: UITableView!
    var dateFormatter = DateFormatter()
    var tamanoCelda = CGFloat()
    var eventosFavoritos = [PFObject]()
    var personas = [PFObject]()
    var favs = [PFObject]()
    var rightButton = UIBarButtonItem()
    var congreso:PFObject!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.tabla.frame = CGRect(x:0.0 , y: ((self.navigationController?.navigationBar.frame.height)! + 30.0), width: view.frame.width, height:(view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 30.0))
        self.tabla.tableFooterView = UIView()

    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Favoritos"
        rightButton = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showEditing(sender:))
)
        
        let queryPersona = PFQuery(className: "PersonaRolAct")
        queryPersona.fromLocalDatastore()
        queryPersona.includeKey("persona")
        queryPersona.includeKey("act")

        let user = PFUser.current()
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "(user == %@ ) AND (congreso == %@)", user!,congreso))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.includeKey("actividad")
        favoritoQuery.includeKey("user")
        
        favoritoQuery.findObjectsInBackground().continue({ (taskFav:BFTask<NSArray>) -> Any? in
            
           self.favs =  taskFav.result as! [PFObject]
            
            
            DispatchQueue.main.async {
                
                self.eventosFavoritos = self.favs.map{$0.value(forKey: "actividad") as! PFObject}
                self.tabla.reloadData()
            
            }
            return queryPersona.findObjectsInBackground().continue({ (taskPersona:BFTask<NSArray>) -> Any? in
                
                self.personas = taskPersona.result as! [PFObject]
                return taskPersona
            })
        })

        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventosFavoritos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let evento = eventosFavoritos[indexPath.row] as PFObject
        var object = Array<Any>()
        _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
            
            let persona = $0.value(forKey: "persona") as? PFObject
            
            object.append(persona!)
            //            cell.imagenPerfil.frame.origin.x = cell.imagenMargen.frame.maxX + 10.0
            
            }}
        let im = evento["imgPerfil"] as? PFFile
        var margenImg = CGFloat()
        if(im == nil){
            cell.imagenPerfil.frame.origin = CGPoint(x: 10.0, y: 12.5)
            cell.imagenPerfil.isHidden = true
            cell.imagenPerfil.frame.size = CGSize(width: 0.0, height: 0.0)
            margenImg = 10.0
            
        }
            
        else{
            cell.imagenPerfil.frame.origin = CGPoint(x: (cell.imagenMargen.frame.maxX + 10.0), y: 12.5)
            cell.imagenPerfil.isHidden = false
            if(evento["tipo"] as? String == "social"){
                cell.imagenPerfil.frame.size = CGSize(width: 29.41, height: 34.92)
                
                
            }
            else if(evento["tipo"] as? String == "break"){
                
                cell.imagenPerfil.frame.size = CGSize(width: 46.0, height: 30.5)
                
            }
            else if(evento["tipo"] as? String == "conferenciaPatrocinada"){
                cell.imagenPerfil.frame.size = CGSize(width: 62.5, height: 36.5)
                
            }
            
            margenImg = 12.5
            
            im?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
                
                DispatchQueue.main.async {
                    
                    if ((task.error) != nil){
                        
                        cell.imagenPerfil.image = UIImage(named: "almuerzo.png")
                        
                    }
                    else{
                        cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                    }
                }
                return task
            })
        }
        
        let personaActividad = object as? [PFObject]
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate!)
        
        cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        cell.labelTitulo?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: 7.5, width: view.frame.size.width - (60.0 + cell.imagenPerfil.frame.maxX + margenImg), height:0.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        let hyphenAttribute = [
            NSAttributedStringKey.paragraphStyle : paragraphStyle,
            ] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: (evento["nombre"] as? String)!, attributes: hyphenAttribute)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - (60.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 15.0)
        cell.labelTitulo.attributedText = attributedString
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        
        
        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width  - (43.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
        
        cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelHora?.frame =  CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: cell.labelTitulo.frame.size.height + 15.0, width: 0.0, height: 0.0)
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora.sizeThatFits(maximumLabelSizeHora)
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()
        
                
        if(personaActividad != nil){
            
            var personasString = String()
            
            for object in (personaActividad)!{
                
                let persona = object
                
                personasString.append((persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String) + "\n")
            }
            
            let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - (43.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
            cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelSpeaker1?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height + 22.5, width: 0.0, height: 0.0)
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
        let lugar = evento["lugar"] as? PFObject
        
        var espacio = CGFloat()
        
        
        espacio = 43.0 + cell.labelHora.frame.width + cell.imagenPerfil.frame.maxX
        
        let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
        cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelLugar?.frame = CGRect(x: espacio, y: cell.labelHora.frame.origin.y, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width + 5.0 +  cell.imagenPerfil.frame.maxX + margenImg + cell.imagenMargen.frame.maxX), height: 15.0)
        cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
        cell.labelLugar.text = lugar?["nombre"] as? String
        cell.labelLugar?.textAlignment = .left
        cell.labelLugar.numberOfLines = 1
        cell.labelLugar?.sizeToFit()
        
        
        tamanoCelda = cell.labelTitulo.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + 15.0
        
        var colorImage = UIColor()
        
        if(evento["tipo"] as? String == "conferencia")
        {
            colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
        else if(evento["tipo"] as? String == "conferenciaPatrocinada")
        {
            colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
            
        else if (evento["tipo"] as? String == "social") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
        }
        else if (evento["tipo"] as? String == "break") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
            //
        else{
            colorImage = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
        }
        
        if(tamanoCelda < 75.0)
        {
            tamanoCelda = tamanoCelda + 7.5
            
        }

        cell.imagenMargen.frame.size = CGSize(width: 5.5, height: tamanoCelda)
        cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 5.5, height:tamanoCelda))
        
        return cell
    }

    @objc func showEditing(sender: UIBarButtonItem)
    {
        if(self.tabla.isEditing == true)
        {
            self.tabla.setEditing(false, animated: true)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Editar"
        }
        else
        {
            self.tabla.setEditing(true, animated: true)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Listo"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let evento = self.eventosFavoritos[indexPath.row]
            let object = self.eventosFavoritos.filter{(evento.isEqual($0))}
            let a = object.first
            
            let filtro = self.favs.filter{(($0.value(forKey: "actividad")) as! PFObject).isEqual(a!)}
            
            
            if let index = self.favs.index(of:filtro.first!) {
                self.favs.remove(at: index)
                
                _ =   filtro.map{$0.unpinInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                  
                    
                    DispatchQueue.main.async {
                        self.tabla.reloadData()
                    }
                    return task
                    
                })}
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let evento = eventosFavoritos[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha:evento["fin"] as! NSDate)
        
        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.evento = evento
        if(evento["tipo"] as? String == "conferencia")
        {
            vc.colorFondo = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as? String == "social") {
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
        else{
            vc.colorFondo = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }


    func uniqueElementsFrom(array: [String]) -> [String] {
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
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

