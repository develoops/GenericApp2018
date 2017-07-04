//
//  FavoritosVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData

class FavoritosVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
        
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Favoritos"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let evento = eventos()[indexPath.row]
        
        if(evento.personas?.allObjects.count != 0){
            
            let persona = evento.personas?.allObjects.first as! Persona
            
            cell.labelSpeaker1.text = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!
        }
        else{
            cell.labelSpeaker1.text = ""
        }
        
        cell.labelTitulo.text = evento.nombre
        cell.labelHora.text = (evento.inicio?.description)! + (evento.fin?.description)!
        cell.labelLugar.text = evento.lugar
        
        return cell
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func eventos() ->[Evento]{
        
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Evento")
        
        do {
            let fetchedEventos = try getContext().fetch(employeesFetch) as! [Evento]
            
            return fetchedEventos
            
        } catch {
            fatalError("Fallo: \(error)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let evento = eventos()[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        vc.tituloCharla = evento.nombre
        vc.hora = "11:30 - 13:30"
        
        vc.lugar = evento.lugar
        vc.ponentesArray = (evento.personas?.allObjects)! as NSArray
        vc.info = evento.descripcion
        
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
}

