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
    var patrocinadores = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.tabla.frame = CGRect(x:0.0 , y: ((self.navigationController?.navigationBar.frame.height)! + 30.0), width: view.frame.width, height:(view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 30.0))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let refresh = RefreshData()
        refresh.primerLlamado()
        let patrocinadoresQuery =  PFQuery(className: "Org", predicate: NSPredicate(format:" tipo == %@","patrocinador"))
        patrocinadoresQuery.fromLocalDatastore()
        patrocinadoresQuery.addAscendingOrder("nombre")
        patrocinadoresQuery.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            self.patrocinadores = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return task
        }

        self.navigationController?.navigationBar.topItem?.title = "Patrocinadores"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patrocinadores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patrocinador = patrocinadores[indexPath.row]

        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.imagenPerfil.frame = CGRect(x: 15.0, y: 7.5, width: 75.0, height: 75.0)
        
        if(patrocinador["imgPerfil"] == nil){
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
}
        else{
            let imagen = patrocinador["imgPerfil"] as! PFFile
            imagen.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
               
                DispatchQueue.main.async {
                
                if ((task.error) != nil){
                    
                    cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
                    
                }
                else{
                    cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                }

            }
               return task.result
            }
        }
        cell.labelNombre.frame.origin = CGPoint(x: 102.5, y: 15.0)
        cell.labelNombre.text = patrocinador["nombre"] as? String
      
        cell.imagenPerfil.layer.cornerRadius = (cell.imagenPerfil.frame.size.width) / 2
        cell.imagenPerfil.layer.masksToBounds = true

        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)
        cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patrocinador = patrocinadores[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePatrocinadorVC") as! DetallePatrocinadorVC
        
        vc.nombrePatrocinador = patrocinador["nombre"] as? String
        vc.info = patrocinador["descripcion"] as? String
        vc.direc = patrocinador["direccion"] as? String
        vc.we = patrocinador["sitioWeb"] as? String
        vc.fon = patrocinador["telefono"] as? String
        
        if(patrocinador["imgFondo"] == nil){
            
            if (patrocinador["imgPerfil"] == nil){
                
            }
            else{
                vc.imagen = patrocinador["imgPerfil"] as! PFFile
            }
            
        }
        else{
            vc.imagen = patrocinador["imgFondo"] as! PFFile
        }


        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

