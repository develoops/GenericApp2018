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
    var tamanoCelda = CGFloat()
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
        let colorBarra = UIColor(ciColor: CIColor.init(red: 72/255.0, green: 72/255.0, blue: 80/255.0))
        colorBarra.withAlphaComponent(0.28)
        self.view.backgroundColor = colorBarra
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
        
            return tamanoCelda
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let evento = eventosFiltrados[indexPath.row]

        
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento.inicio!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento.fin!)

        cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        cell.labelTitulo?.frame = CGRect(x: 38.0, y: 20.0, width: view.frame.size.width - 152.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 114.0), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelTitulo.text = evento.nombre
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()

        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 114.0), height: 40000.0)

        cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelHora?.frame =  CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 35.0, width: 0.0, height: 0.0)
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora.sizeThatFits(maximumLabelSizeHora)
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()

       let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
        cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelLugar?.frame = CGRect(x: 65.0 + cell.labelHora.frame.width, y: cell.labelTitulo.frame.size.height + 35.0, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width), height: 40.0)
        cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
        cell.labelLugar.text = evento.lugar
        cell.labelLugar?.textAlignment = .left
        cell.labelLugar.numberOfLines = 0
        cell.labelLugar?.sizeToFit()

        if(evento.personas?.allObjects.count != 0){
            
            var personasString = String()
            for object in (evento.personas?.allObjects)!{
                
                let persona = object as! Persona
                
                personasString.append((persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)! + "\n")
            
            }
            let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - 152.0), height: 40000.0)
            cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelSpeaker1?.frame = CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 60.0, width: 0.0, height: 0.0)
            cell.labelSpeaker1.sizeThatFits(maximumLabelSizePonente)
            cell.labelSpeaker1.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelSpeaker1.text = personasString
            cell.labelSpeaker1?.textAlignment = .left
            cell.labelSpeaker1?.sizeToFit()
            

        }
        else{
            cell.labelSpeaker1.text = ""

        }
    
        tamanoCelda = cell.labelTitulo.frame.height + cell.labelLugar.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + CGFloat((evento.personas?.allObjects.count)! * 15)
        cell.imagenMargen.image = getImageWithColor(color: UIColor.green, size: CGSize(width: 10.0, height: tamanoCelda - 4.0))
        
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
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 2.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  }

