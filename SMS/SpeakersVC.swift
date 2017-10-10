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

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        
        let query = PFQuery(className: "Persona")
        query.includeKey("pais")
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            self.personas = task.result as! [PFObject]
            
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
      
        cell.labelNombre?.frame = CGRect(x: 98.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelNombre.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelLugarPersona?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
       // cell.labelLugarPersona?.text = persona["procedencia"] as? String

      //  cell.labelInstitucion?.text = persona["institucion"] as? String
        cell.labelInstitucion?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + 18.0)
        
        if (persona["imagenPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(persona["imagenPerfil"])
            cell.imagenPerfil.image = UIImage(data: persona["imagenPerfil"] as! Data)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let persona = personas[indexPath.row]
                
        vc.nombrePersona = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        vc.institucion = persona["institucion"] as? String
        vc.rol = persona["rol"] as? String
        vc.lugarPersona = persona["procedencia"] as? String
        vc.info = persona["bio"] as? String

        let eventosPersona = persona["eventos"] as? [PFObject]
        
        vc.charlasArray = eventosPersona
        
        if (persona["imagenPerfil"] == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(persona["imagenPerfil"])
            vc.imagen = UIImage(data: persona["imagenPerfil"] as! Data)
            
        }

        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

