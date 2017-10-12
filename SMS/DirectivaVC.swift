//
//  DirectivaVC.swift
//  SMS
//
//  Created by Alvaro Moya on 9/26/17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class DirectivaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var tamanoCelda = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Directiva"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personas().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let personaRolOrg = personas()[indexPath.row]
        
        let persona = personaRolOrg["persona"] as! PFObject
        print (persona)
        let lugar = (persona["pais"] as! PFObject)
        print(lugar)
        
        let prenombre = (persona["preNombre"] as? String)
        let primerNombre = (persona["primerNombre"] as? String)
        let primerApellido = (persona["primerApellido"] as? String)
        
        
        
        
        
        cell.labelNombre?.frame = CGRect(x: 98.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = prenombre! + " " + primerNombre! + " " + primerApellido!
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelLugarPersona?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
        cell.labelLugarPersona?.text = lugar["nombre"] as? String
        cell.labelLugarPersona.font = UIFont.systemFont(ofSize: 14.0)
        
        cell.labelInstitucion?.text = personaRolOrg["rol"] as? String
        cell.labelInstitucion.font = UIFont.systemFont(ofSize: 14.0)
        
        cell.labelInstitucion?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + 18.0)
        
        if (persona["ImgPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(persona["ImgPerfil"])
            cell.imagenPerfil.image = UIImage(data: persona["ImgPerfil"] as! Data)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let personaRolOrg = personas()[indexPath.row]
        
        let persona = personaRolOrg["persona"] as! PFObject
        let lugar = persona["pais"] as! PFObject
        
        vc.nombrePersona = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        
        vc.institucion = persona["institucion"] as? String
        vc.rol = personaRolOrg["rol"] as? String
        vc.lugarPersona = lugar["nombre"] as? String
        vc.info = persona["descripcion"] as? String
        
        
        
        if (persona["ImgPerfil"] == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(persona["ImgPerfil"])
            vc.imagen = UIImage(data: persona["ImgPerfil"] as! Data)
            
        }
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    func personas() ->[PFObject]{
        
        do {
            let personasQuery =  PFQuery(className:"PersonaRolOrg")
            personasQuery.includeKey("persona.pais")
            
            //  personasQuery.fromLocalDatastore()
            //personasQuery.whereKey("rol", equalTo: "Directiva")
            //personasQuery.fromLocalDatastore()
            return try personasQuery.findObjects()
            
        } catch {
            fatalError("Fallo: \(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

