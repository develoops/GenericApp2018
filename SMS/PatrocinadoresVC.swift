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
        patrocinadoresQuery.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            self.patrocinadores = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return task
        })

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
        
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patrocinador = patrocinadores[indexPath.row]

        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.labelNombre.text = patrocinador["nombre"] as? String
        if(patrocinador["imgPerfil"] == nil){
            cell.imagenPerfil.image = UIImage(named: "")
}
        else{
            let imagen = patrocinador["imgPerfil"] as! PFFile
            
            
            imagen.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
               
                DispatchQueue.main.async {
                    cell.imagenPerfil.image = UIImage(data: task.result! as Data)

                }
                
               return task.result
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patrocinador = patrocinadores[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePatrocinadorVC") as! DetallePatrocinadorVC
        
        vc.nombrePatrocinador = patrocinador["nombre"] as? String
        vc.info = patrocinador["bio"] as? String
        vc.direc = patrocinador["direccion"] as? String
        vc.we = patrocinador["sitioWeb"] as? String
        vc.fon = patrocinador["telefono"] as? String
        
        if(patrocinador["imgFondo"] == nil){
            
            if (patrocinador["imgPerfil"] == nil){
                
              //  vc.imagen = PFFile(

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
    
//    func patrocinadores() ->[PFObject]{
//        
//        do {
//            
//        } catch {
//            fatalError("Fallo: \(error)")
//        }
//        
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

