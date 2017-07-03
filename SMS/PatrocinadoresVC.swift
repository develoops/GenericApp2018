//
//  PatrocinadoresVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData

class PatrocinadoresVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.navigationController?.title = "Patrocinadores"

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return patrocinadores().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patrocinador = patrocinadores()[indexPath.row]

        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.labelNombre.text = patrocinador.nombre
        if(patrocinador.imagenPerfil == nil){
            cell.imagenPerfil.image = UIImage(named: "")
}
        else{
            cell.imagenPerfil.image = UIImage(data: patrocinador.imagenPerfil! as Data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patrocinador = patrocinadores()[indexPath.row]

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePatrocinadorVC") as! DetallePatrocinadorVC
        
        vc.nombrePatrocinador = patrocinador.nombre
        vc.info = patrocinador.bio
        vc.direc = patrocinador.direccion
        vc.we = patrocinador.sitioWeb
        vc.fon = patrocinador.telefono
        if(patrocinador.imagenFondo == nil){
            vc.imagen = UIImage(named:"")
        }
        else{
            vc.imagen = UIImage(data: patrocinador.imagenFondo! as Data)
        }


        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func patrocinadores() ->[Organizacion]{
        
        let orgFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Organizacion")
        
        do {
            let fetchedOrg = try getContext().fetch(orgFetch) as! [Organizacion]
            
            return fetchedOrg
            
        } catch {
            fatalError("Fallo: \(error)")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

