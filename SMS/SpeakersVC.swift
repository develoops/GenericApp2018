//
//  SpeakersVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class SpeakersVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    var tamanoCelda = CGFloat()
    var personas = [PFObject]()
    var personasRolAct = [PFObject]()
    var congreso:PFObject!
    var rolAct = [PFObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.tabla.frame = CGRect(x:0.0 , y: ((self.navigationController?.navigationBar.frame.height)! + 30.0), width: view.frame.width, height:(view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 30.0))

        let query = PFQuery(className: "PersonaRolAct", predicate: NSPredicate(format: "congreso == %@", self.congreso))
        query.limit = 1000
        query.includeKey("act")
        query.includeKey("act.lugar")
        query.includeKey("persona")
        query.includeKey("persona.pais")
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
        
        
            self.rolAct = task.result as! [PFObject]
            
            

            var counts: [PFObject: Int] = [:]
            
            for ite in self.rolAct {
                counts[ite.value(forKey: "persona") as! PFObject] = (counts[ite.value(forKey: "persona") as! PFObject] ?? 0) + 1
        
            }
        
            for (key, value) in counts {
                if(value > 1){
                self.personasRolAct.append(key)
                }
        }
        self.personas  = self.uniqueElementsFrom(array:self.personasRolAct)
        DispatchQueue.main.async() {
                self.tabla.reloadData()
            }
            return task
            
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Ponentes"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let persona = personas[indexPath.row]
        
        let lugar = persona.value(forKey: "pais") as? PFObject
        let institucion = personasRolAct[indexPath.row].value(forKey: "institucion") as? PFObject
        
        
        cell.labelNombre?.frame = CGRect(x: 98.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelNombre.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelLugarPersona?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
        cell.labelLugarPersona?.text = lugar?["nombre"] as? String

        cell.labelInstitucion?.text = institucion?["nombre"] as? String
        cell.labelInstitucion?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + 18.0)
        
        if (persona["ImgPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            let im = persona["ImgPerfil"] as? PFFile
            im?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in

                DispatchQueue.main.async {
                    
                
                cell.imagenPerfil.image = UIImage(data:task.result! as Data)
                    
            }
                return task
            })
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let persona = personas[indexPath.row]
        let personaRA = personasRolAct[indexPath.row]
        
        let lugar = persona.value(forKey: "pais") as? PFObject
        
        vc.nombrePersona = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        vc.institucion = persona["institucion"] as? String
        vc.rol = personaRA["rol"] as? String
        vc.lugarPersona = lugar?["nombre"] as? String
        vc.info = persona["descripcion"] as? String

       let actividades = rolAct.filter({($0["persona"] as! PFObject) == persona})
        
        let act = actividades.map({$0.value(forKey: "act") as? PFObject}).flatMap({$0})
        
        vc.charlasArray = act
        
        if (persona["ImgPerfil"] == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
        let im = persona["ImgPerfil"] as! PFFile

            vc.imagenFile = im
        }
        vc.congreso = congreso
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

