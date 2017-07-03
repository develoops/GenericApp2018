//
//  ViewController.swift
//  SMS
//
//  Created by Arturo Sanhueza on 28-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData

class ProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var avanzar: UIButton!
    @IBOutlet weak var retroceder: UIButton!
    @IBOutlet weak var diaControl: UILabel!

    var indicador = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.navigationController?.title = "Programa"
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventos().count
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
        
        let DF = DateFormatter()
        DF.dateFormat = "HH:mm"
        cell.labelTitulo.text = evento.nombre
        cell.labelLugar.text = evento.lugar
        cell.labelHora.text = DF.string(from: evento.inicio?.addingTimeInterval(-978296400) as! Date) + " - " + DF.string(from: evento.fin?.addingTimeInterval(-978296400) as! Date)

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

    func navegacionPorDia(){
    
        let formater = DateFormatter()
        formater.dateFormat = "DD:dd"
        
        
    print(eventos().count)
    
        for index in 0...(eventos().count - 1) {
        
        let fechas = eventos()[index].fec
            print(index)

        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let evento = eventos()[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        vc.tituloCharla = evento.nombre

        vc.hora = (dateFormatter.string(from:evento.inicio! as Date)) + " - " + (dateFormatter.string(from:evento.fin! as Date))
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

