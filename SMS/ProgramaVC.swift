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
    var dateFormatter = DateFormatter()
    var eventosFiltrados = [Evento]()
    var indicador = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        botonAvanzar.addTarget(self, action: #selector(avanzar), for: .touchUpInside)
        botonRetroceder.addTarget(self, action: #selector(retroceder), for: .touchUpInside)
        botonRetroceder.isHidden = true
        
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Programa"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
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
        
        let evento = eventosFiltrados[indexPath.row]

        if(evento.personas?.allObjects.count != 0){
            
            let persona = evento.personas?.allObjects.first as! Persona

            cell.labelSpeaker1.text = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!
        }
        else{
            cell.labelSpeaker1.text = ""
        }
        
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento.inicio!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento.fin!)

        cell.labelTitulo.text = evento.nombre
        cell.labelLugar.text = evento.lugar
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let evento = eventosFiltrados[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento.inicio!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento.fin!)

        vc.tituloCharla = evento.nombre
        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento.inicio!)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.lugar = evento.lugar
        vc.ponentesArray = (evento.personas?.allObjects)! as NSArray
        vc.info = evento.descripcion
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
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
        
        var diasPrograma = [String]()
        for index in 0...(eventos().count - 1) {
            
            let fecha = eventos()[index].inicio
            let fechaString = dateFormatter.formatoDiaMesCortoString(fecha: fecha!)
            diasPrograma.append(fechaString)
        }
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        
        return diasProgramaFiltrados
    }
    
    func diasProgramaDate() ->[String]{
        
        var diasPrograma = [String]()
        
        for index in 0...(eventos().count - 1) {
            
            let fecha = eventos()[index].inicio
            let fechaString = dateFormatter.formatoAnoMesDiaString(fecha:fecha!)
            diasPrograma.append(fechaString)
        }
        
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        print(diasProgramaFiltrados)
        return diasProgramaFiltrados
    }
    
    
    func avanzar(sender: UIButton!){
        
        if(indicador < diasPrograma().count - 1){
            indicador = indicador + 1
            botonRetroceder.isHidden = false
        }
        
                    
        if(indicador == diasPrograma().count-1){
            botonAvanzar.isHidden = true
        }
        else {
            botonAvanzar.isHidden = false

        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    func retroceder(sender: UIButton!){
        
        if(indicador==1){
            botonRetroceder.isHidden = true
        }
        else {
            botonRetroceder.isHidden = false
        }
        if(indicador > 0){
            indicador = indicador - 1
        }
        
        if(indicador != diasPrograma().count-1){
            botonAvanzar.isHidden = false
        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    func filtrarArray(indicador:Int) {
        let date = dateFormatter.formatoAnoMesDiaDate(string:diasProgramaDate()[indicador])
        
        let filteredArray = eventos().filter() {
            
            return $0.inicio?.compare((date.addingTimeInterval(60*60*24))) == ComparisonResult.orderedAscending && $0.inicio?.compare(date) == ComparisonResult.orderedDescending
        }
        
        eventosFiltrados = filteredArray
        self.tabla.reloadData()
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

