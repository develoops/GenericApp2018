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
    //var institucion = PFObject
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let refresh = RefreshData()
        refresh.primerLlamado()
        
        self.tabla.frame = CGRect(x:0.0 , y: ((self.navigationController?.navigationBar.frame.height)! + 30.0), width: view.frame.width, height:(view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 30.0))
        
        let query = PFQuery(className: "PersonaRolAct")
        query.fromLocalDatastore()
        query.limit = 1000
        query.includeKey("act")
        query.includeKey("act.lugar")
        query.includeKey("persona")
        query.includeKey("persona.pais")
        query.includeKey("institucion")
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
        self.rolAct = task.result as! [PFObject]
            
            var counts: [PFObject: Int] = [:]
            
            for ite in self.rolAct {
                counts[ite.value(forKey: "persona") as! PFObject] = (counts[ite.value(forKey: "persona") as! PFObject] ?? 0) + 1
                
            }
            
            for (key, value) in counts {
                if(value >= 1){
                    self.personasRolAct.append(key)
                }
            }
            let arrayDePersonas  = self.uniqueElementsFrom(array:self.personasRolAct)

            self.personas = arrayDePersonas.sorted { ($0["primerApellido"] as AnyObject).localizedCaseInsensitiveCompare($1["primerApellido"] as! String) == ComparisonResult.orderedAscending }

            
            DispatchQueue.main.async() {
                self.tabla.reloadData()
            }
            return task
        })

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
        
        return tamanoCelda
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let persona = personas[indexPath.row]
        let lugar = persona.value(forKey: "pais") as? PFObject
        
        
        //arreglar
       /*  let queryInstitucion = PFQuery(className: "PersonaRol", predicate: NSPredicate(format: "persona = %@", persona))
         queryInstitucion.fromLocalDatastore()
         queryInstitucion.getFirstObjectInBackground().continue({ (task2:BFTask<PFObject>) -> Any? in
            
            institucion = task2.result?.value(forKey: "institucion")
         })
        */
        //let institucion = persona["institucion"] as? PFObject
        
        let im = persona["ImgPerfil"] as? PFFile
        
        cell.imagenPerfil.frame = CGRect(x: 15.0, y: 7.5, width: 50.0, height: 50.0)
        
        if (im == nil) {
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
            
        else{
            im?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
                
                DispatchQueue.main.async {
                    
                    if ((task.error) != nil){
                        
                        cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
                        
                    }
                    else{
                        cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                    }
                    
                }
                
                
                return task
            })
        }

        cell.labelNombre?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + 27.5 , y: 7.5, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelNombre.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelLugarPersona?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.maxY + 15.0)
        cell.labelLugarPersona?.text = lugar?["nombre"] as? String

        cell.labelInstitucion?.text = institucion?["nombre"] as? String
        cell.labelInstitucion?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + 20.0)
        
        
        tamanoCelda = cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + cell.labelInstitucion.frame.height + 37.0

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let persona = personas[indexPath.row]
        
        let lugar = persona.value(forKey: "pais") as? PFObject
        
        vc.nombrePersona = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        vc.lugarPersona = lugar?["nombre"] as? String
        vc.info = persona["descripcion"] as? String

       let actividades = rolAct.filter({($0["persona"] as! PFObject) == persona})
        
        let act = actividades.map({$0.value(forKey: "act") as? PFObject}).flatMap({$0})
        
        vc.charlasArray = act
        
        print(act)
        
        
        let im = persona["ImgPerfil"] as! PFFile

        if (persona["ImgPerfil"] == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{

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

extension Data {
    init(reading input: InputStream) {
        self.init()
        input.open()
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate(capacity: bufferSize)
        
        input.close()
    }
}
