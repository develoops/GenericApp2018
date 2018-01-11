//
//  DirectorioVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 14-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

import UIKit
import Parse

class DirectorioVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var tamanoCelda = CGFloat()
    var personas = [PFObject]()
    var congreso:PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        tabla.tableFooterView = UIView()

        let queryDirectiva = PFQuery(className: "PersonaRolOrg", predicate: NSPredicate(format: "tipo = %@", "congreso"))
        queryDirectiva.order(byAscending: "order")
        queryDirectiva.fromLocalDatastore()
        queryDirectiva.includeKey("persona.pais")
        queryDirectiva.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            DispatchQueue.main.async {
                
                self.personas = task.result as! [PFObject]
                self.tabla.reloadData()
                
            }
            
            return task
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Autoridades del Congreso"

    }
    
    func irAtras () {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = ""

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
        
        let personaRolOrg = personas[indexPath.row]
        
        let persona = personaRolOrg["persona"] as! PFObject
        let lugar = (persona["pais"] as? PFObject)
                
        let im = persona["ImgPerfil"] as? PFFile
        cell.imagenPerfil.frame = CGRect(x: 15.0, y: 7.5, width: 50.0, height: 50.0)
        
        if (im == nil) {
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
            
        else{
            im?.getDataInBackground().continueWith(block: { (task:BFTask<NSData>) -> Any? in
                
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
        
        cell.labelNombre?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + 12.5 , y: 7.5, width: self.view.frame.width - (cell.imagenPerfil.frame.maxX + 27.5), height:0.0)
        let maximumLabelSize = CGSize(width: (self.view.frame.width - (cell.imagenPerfil.frame.maxX + 27.5)), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSize)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 15.0)
        cell.labelNombre?.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelLugarPersona?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.maxY + 5.0)
        
        cell.labelLugarPersona.sizeThatFits(maximumLabelSize)
        cell.labelLugarPersona.font = UIFont.systemFont(ofSize: 12.0)
        cell.labelLugarPersona?.text = lugar?["nombre"] as? String
        cell.labelLugarPersona?.textAlignment = .left
        cell.labelLugarPersona.numberOfLines = 0
        cell.labelLugarPersona?.sizeToFit()
        
        cell.labelInstitucion?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelLugarPersona.frame.maxY + 5.0)
        
        cell.labelInstitucion.sizeThatFits(maximumLabelSize)
        cell.labelInstitucion.font = UIFont.systemFont(ofSize: 12.0)
        cell.labelInstitucion?.text = personaRolOrg["rol"] as? String
        cell.labelInstitucion?.textAlignment = .left
        cell.labelInstitucion.numberOfLines = 0
        cell.labelInstitucion?.sizeToFit()
        
        tamanoCelda = cell.imagenPerfil.frame.origin.y + cell.imagenPerfil.frame.size.height + 15.0
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)
        cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let personaRolOrg = personas[indexPath.row]
        
        let persona = personaRolOrg["persona"] as! PFObject
        let lugar = persona["pais"] as? PFObject
        
        vc.nombrePersona = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)
        
        vc.institucion = persona["institucion"] as? String
        vc.rol = personaRolOrg["rol"] as? String
        vc.lugarPersona = lugar?["nombre"] as? String
        vc.info = persona["descripcion"] as? String
        
        
        if (persona["ImgPerfil"] == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            let im = persona["ImgPerfil"] as! PFFile
            
            vc.imagenFile = im
        }
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
