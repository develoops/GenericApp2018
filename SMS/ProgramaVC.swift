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
    @IBOutlet weak var botonAvanzar: UIButton!
    @IBOutlet weak var botonRetroceder: UIButton!
    @IBOutlet weak var diaControl: UILabel!
    var eventosFiltrados = NSArray()
    var indicador = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        self.navigationController?.title = "Programa"
        botonAvanzar.addTarget(self, action: #selector(avanzar), for: .touchUpInside)
        botonRetroceder.addTarget(self, action: #selector(retroceder), for: .touchUpInside)
        filtrarArray(indicador: indicador)
        eventos()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 115.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let evento = eventosFiltrados[indexPath.row] as! Evento

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

    func diasPrograma() ->[String]{
    
        let formater = DateFormatter()
        formater.dateFormat = "dd-MMM"
        var diasPrograma = [String]()
        for index in 0...(eventos().count - 1) {
        
        let fecha = eventos()[index].inicio?.addingTimeInterval(-978296400)
            let fechaString = formater.string(from: fecha! as Date)
            diasPrograma.append(fechaString)
        }
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        
        return diasProgramaFiltrados
    }

    func diasProgramaDate() ->[String]{
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        var diasPrograma = [String]()
        
        for index in 0...(eventos().count - 1) {
            
            let fecha = eventos()[index].inicio
            let fechaString = formater.string(from: fecha! as Date)
            diasPrograma.append(fechaString)
        }
        
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        print(diasProgramaFiltrados)
        return diasProgramaFiltrados
    }

    
    func avanzar(sender: UIButton!){
        if(indicador < diasPrograma().count - 1){
            indicador = indicador + 1
        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    func retroceder(sender: UIButton!){
        if(indicador > 0){
            indicador = indicador - 1
        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
}
    
    func filtrarArray(indicador:Int) {
    let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
    let date = dateF.date(from: diasProgramaDate()[indicador])
        print(date)
        print(eventos().first?.inicio)
    let array = NSArray(objects: eventos())
    let predicateFecha = NSPredicate(format: "inicio > %@", Date() as NSDate)

       eventosFiltrados = array.filtered(using: predicateFecha) as NSArray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let evento = eventosFiltrados[indexPath.row] as! Evento

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
    

    func uniqueElementsFrom(array: [String]) -> [String] {
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

