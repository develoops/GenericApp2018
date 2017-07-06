//
//  SpeakersVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData

class SpeakersVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
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
        
        return personas().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let persona = personas()[indexPath.row]
      
        cell.labelNombre?.frame = CGRect(x: 98.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelNombre.text = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()

        cell.labelLugarPersona.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
        cell.labelLugarPersona.text = persona.procedencia
        
        cell.labelInstitucion.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + 18.0)

        if (persona.imagenPerfil?.length == 4) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else if (persona.imagenPerfil?.length == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }

        else{
            cell.imagenPerfil.image = UIImage(data: persona.imagenPerfil! as Data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detallePersonaVC") as! DetallePersonaVC
        let persona = personas()[indexPath.row]
                
        vc.nombrePersona = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!
        vc.institucion = persona.institucion
        vc.rol = persona.rol
        vc.lugarPersona = persona.procedencia
        vc.info = persona.bio
        vc.charlasArray = (persona.eventos?.allObjects)! as NSArray

        
        if (persona.imagenPerfil?.length == 4) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else if (persona.imagenPerfil?.length == nil) {
            
            vc.imagen = UIImage(named: "Ponente_ausente_Hombre.png")
        }
            
        else{
            vc.imagen = UIImage(data: persona.imagenPerfil! as Data)
        }


        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func personas() ->[Persona]{
        
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Persona")
        let sortDescriptor = NSSortDescriptor(key: "apellido", ascending: true)
        employeesFetch.sortDescriptors = [sortDescriptor]

        do {
            let fetchedEventos = try getContext().fetch(employeesFetch) as! [Persona]
            
            return fetchedEventos
            
        } catch {
            fatalError("Fallo: \(error)")
        }
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
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

