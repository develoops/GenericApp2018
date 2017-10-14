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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Favoritos"
        rightButton = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showEditing(sender:))
)
        
        let queryPersona = PFQuery(className: "PersonaRolAct")
        queryPersona.includeKey("persona")
        queryPersona.includeKey("act")

        let user = PFUser.current()
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "user == %@", user!))
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
        
        
        let evento = eventosFavoritos[indexPath.row]
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)
        
        _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
            
            let persona = $0.value(forKey: "persona") as? PFObject
            
            if !(evento.allKeys.containss(obj: "personas")){
                evento.addUniqueObject(persona as Any, forKey: "personas")
                
            }}}
        
        let personaActividad = evento["personas"] as? [PFObject]

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
        
        if(personaActividad != nil){
            
            var personasString = String()
            
            for object in (personaActividad)!{
                
                let persona = object
                
                
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
    
    func showEditing(sender: UIBarButtonItem)
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
                
                _ =   filtro.map{$0.deleteInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                    return task
                })}
            }
            
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }}
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

