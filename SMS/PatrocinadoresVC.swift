//
//  PatrocinadoresVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class PatrocinadoresVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Patrocinadores"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patrocinadores().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patrocinador = patrocinadores()[indexPath.row]

        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.labelNombre.text = patrocinador["nombre"] as? String
        if(patrocinador["imagenPerfil"] == nil){
            cell.imagenPerfil.image = UIImage(named: "")
}
        else{
            let imagen = patrocinador["imagenPerfil"] as! PFFile
            
            
            imagen.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
               
                cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                
               return task.result
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patrocinador = patrocinadores()[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePatrocinadorVC") as! DetallePatrocinadorVC
        
        vc.nombrePatrocinador = patrocinador["nombre"] as? String
        vc.info = patrocinador["bio"] as? String
        vc.direc = patrocinador["direccion"] as? String
        vc.we = patrocinador["sitioWeb"] as? String
        vc.fon = patrocinador["telefono"] as? String
        
        if(patrocinador["imagenFondo"] == nil){
            vc.imagen = patrocinador["imagenPerfil"] as! PFFile
        }
        else{
            vc.imagen = patrocinador["imagenFondo"] as! PFFile
        }


        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func patrocinadores() ->[PFObject]{
        
        do {
            let patrocinadoresQuery =  PFQuery(className:"Organizacion")
            patrocinadoresQuery.fromLocalDatastore()
            return try patrocinadoresQuery.findObjects()
            
        } catch {
            fatalError("Fallo: \(error)")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

