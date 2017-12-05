//
//  ViewController.swift
//  SMS
//
//  Created by Arturo Sanhueza on 28-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse


extension Array {
    func containss<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

class ProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var botonAvanzar: UIButton!
    @IBOutlet weak var botonRetroceder: UIButton!
    @IBOutlet weak var diaControl: UILabel!
    var tamanoCelda = CGFloat()
    var dateFormatter = DateFormatter()
    var eventosFiltrados = [PFObject]()
    var personas = [PFObject]()
    var eventosVarLocal = [PFObject]()
    var indicador = 0
    var congreso:PFObject!
    var favs = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.tabla.frame = CGRect(x:0.0 , y: ((self.navigationController?.navigationBar.frame.height)! + 65.0), width: view.frame.width, height:(view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 125.0))
        
        
        let queryPersona = PFQuery(className: "PersonaRolAct")
        queryPersona.limit = 1000
        queryPersona.fromLocalDatastore()
        queryPersona.includeKey("persona")
        queryPersona.includeKey("act")
        
        let eventosQuery =  PFQuery(className: "ActContAct", predicate: NSPredicate(format: "contenedor == %@", congreso))
        eventosQuery.fromLocalDatastore()
        eventosQuery.includeKey("contenido")
        eventosQuery.includeKey("contenedor")
        eventosQuery.limit = 1000
        eventosQuery.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            let actCollection = task.result as! [PFObject]
            let contenido = actCollection.map{$0.value(forKey: "contenido") as? PFObject}

            let a = contenido.map{$0?.objectId}
            
            let query = PFQuery(className: "Actividad")
            query.fromLocalDatastore()
            query.includeKey("lugar")
            query.addAscendingOrder("inicio")

            query.limit = 1000
            
        return query.findObjectsInBackground().continue({ (taskActividades:BFTask<NSArray>) -> Any? in
                let actividades = taskActividades.result as! [PFObject]
                self.eventosVarLocal = actividades.filter{a.containss(obj: $0.objectId!)
            }
    queryPersona.findObjectsInBackground().continue({ (taskPersonas:BFTask<NSArray>) -> Any? in
                    self.personas = (taskPersonas.result as? [PFObject])!
                    
                    return taskPersonas
                    
                })
                
            
                DispatchQueue.main.async() {
                    self.botonAvanzar.addTarget(self, action: #selector(self.avanzar), for: .touchUpInside)
                    self.botonRetroceder.addTarget(self, action: #selector(self.retroceder), for: .touchUpInside)
                    self.botonRetroceder.isHidden = true
                    self.diaControl.text = self.diasPrograma()[self.indicador]
                    self.configurarNavegacion()
                    self.filtrarArray(indicador: self.indicador)
                    let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tabla.frame.origin.y))
                    colorFondoHeaderDetalle.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.03)
                    
                    
                    self.view.addSubview(colorFondoHeaderDetalle)
                    self.view.sendSubview(toBack: colorFondoHeaderDetalle)

                }
                
                return taskActividades
            })
        })}
    
    override func viewDidAppear(_ animated: Bool) {
        let refresh = RefreshData()
        refresh.primerLlamado()

        self.navigationController?.navigationBar.topItem?.title = "Programa"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Congresos", style: .plain, target: self, action: #selector(volver))
    
    self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Ahora", style: .plain, target: self, action: #selector(eem))

        let user = PFUser.current()
        
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "user == %@", user!))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.includeKey("actividad")
        favoritoQuery.includeKey("user")
        
        favoritoQuery.findObjectsInBackground().continue({ (taskFav:BFTask<NSArray>) -> Any? in
            
            self.favs = taskFav.result as! [PFObject]
            
            DispatchQueue.main.async {
                
            
                self.tabla.reloadData()
                
            }
            return taskFav
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if(tamanoCelda < 75.0){
//
//            return 75.0
//        }
//        else{
            return tamanoCelda
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let evento = eventosFiltrados[indexPath.row] as PFObject
        var object = Array<Any>()
        _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
            
            let persona = $0.value(forKey: "persona") as? PFObject
            
                object.append(persona!)
            
        }}
        
        let personaActividad = object as? [PFObject]
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate!)

        cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        cell.labelTitulo?.frame = CGRect(x: 15.0, y: 5.0, width: view.frame.size.width - 100.0, height:0.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        
        let hyphenAttribute = [
            NSAttributedStringKey.paragraphStyle : paragraphStyle,
            ] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: (evento["nombre"] as? String)!, attributes: hyphenAttribute)
       // cell.labelTitulo.attributedText = attributedString

        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 43.0), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 15.0)
        cell.labelTitulo.attributedText = attributedString
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        

        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 43.0), height: 40000.0)

        cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelHora?.frame =  CGRect(x: 15.0, y: cell.labelTitulo.frame.size.height + 15.0, width: 0.0, height: 0.0)
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora.sizeThatFits(maximumLabelSizeHora)
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()

        
//        var personasTamano = CGFloat()
        
        if(personaActividad != nil){
            
            var personasString = String()
            
            for object in (personaActividad)!{
                
                let persona = object
                
                
                personasString.append((persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String) + "\n")

        }
            
            let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - 43.0), height: 40000.0)
            cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelSpeaker1?.frame = CGRect(x: 15.0, y: cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height + 22.5, width: 0.0, height: 0.0)
            cell.labelSpeaker1.sizeThatFits(maximumLabelSizePonente)
            cell.labelSpeaker1.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelSpeaker1.text = personasString
            cell.labelSpeaker1.numberOfLines = 0
            cell.labelSpeaker1?.textAlignment = .left
            cell.labelSpeaker1?.sizeToFit()
        
        }
        else{
            cell.labelSpeaker1.text = ""
        }
        let lugar = evento["lugar"] as? PFObject
        
        var espacio = CGFloat()
        
//        if(cell.labelSpeaker1.text == ""){
        
            espacio = 43.0 + cell.labelHora.frame.width
//        }
//        else{
//            espacio = 43.0 + cell.labelSpeaker1.frame.width
//        }
//
        let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
        cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelLugar?.frame = CGRect(x: espacio, y: cell.labelHora.frame.origin.y, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width + 5.0), height: 15.0)
        cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
        cell.labelLugar.text = lugar?["nombre"] as? String
        cell.labelLugar?.textAlignment = .left
        cell.labelLugar.numberOfLines = 1
        cell.labelLugar?.sizeToFit()

        
        tamanoCelda = cell.labelTitulo.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + 15.0
       
        var colorImage = UIColor()
        
        if(evento["tipo"] as? String == "conferencia")
        {
            colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as? String == "social") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
        }
        else if (evento["tipo"] as? String == "break") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }

        else{
            colorImage = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
        }
        
        print(tamanoCelda)
        if(tamanoCelda < 75.0)
        {
            tamanoCelda = tamanoCelda + 7.5
        }
        
        cell.imagenMargen.frame.size = CGSize(width: 5.5, height: tamanoCelda)
        cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 5.5, height:tamanoCelda))
        
        cell.botonFavorito.center.x = cell.frame.size.width - 25.0
        cell.botonFavorito.tag = indexPath.row
        cell.botonFavorito.addTarget(self, action: #selector(cambiarFavorito), for: .touchUpInside)
        
        let actividadesFavs = favs.map{$0["actividad"]} as! [PFObject]
        if actividadesFavs.contains(evento) {
            cell.botonFavorito.setImage(UIImage(named: "btn_Favorito_marcado"), for: .normal)

        }
        else{
            cell.botonFavorito.setImage(UIImage(named: "Btn_favoritos_SinMarcar"), for: .normal)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let evento = eventosFiltrados[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)

        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.evento = evento
    
        var object = Array<Any>()
        var roles = Array<Any>()
        _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
            let persona = $0.value(forKey: "persona") as? PFObject
            let rol = $0.value(forKey: "rol") as? String
            object.append(persona!)
            roles.append(rol!)
            
            }}
        
        let personaActividad = object as? [PFObject]

        if personaActividad != nil {
            
            vc.personas = personaActividad!
            vc.roles = roles as? [String]
    }
        
    if(evento["tipo"] as? String == "conferencia")
        {
            vc.colorFondo = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as? String == "social") {
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
    else if (evento["tipo"] as? String == "break") {
        
        vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
        
    }

        else{
            vc.colorFondo = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }
        vc.congreso = congreso
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @objc func eem(){
        
        let fechaHoy = Date.init(timeIntervalSinceNow: -(60*60*3))
        
        
        let filteredArray = eventosVarLocal.filter() {
            
            return ($0["fin"] as AnyObject).compare((fechaHoy.addingTimeInterval(60*60*3))) == ComparisonResult.orderedAscending && ($0["fin"] as AnyObject).compare(fechaHoy) == ComparisonResult.orderedDescending
        }
        
        eventosFiltrados = filteredArray
        self.diaControl.isHidden = true
        self.botonAvanzar.isHidden = true
        self.botonRetroceder.isHidden = true
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Programa", style: .plain, target: self, action: #selector(programa))
        self.navigationController?.navigationBar.topItem?.title = "Ahora"

        self.tabla.reloadData()

    }
    
    @objc func programa(){
    
        self.diaControl.text = self.diasPrograma()[self.indicador]
        self.filtrarArray(indicador: self.indicador)

        self.diaControl.isHidden = false
        self.botonAvanzar.isHidden = false
        self.botonRetroceder.isHidden = false
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Ahora", style: .plain, target: self, action: #selector(eem))
        self.tabla.reloadData()
        self.navigationController?.navigationBar.topItem?.title = "Programa"

    }
    
    
    func diasPrograma() ->[String]{
        
        var diasPrograma = [String]()
        if (eventosVarLocal.count != 0){

        for index in 0...(eventosVarLocal.count - 1) {
            let fecha = eventosVarLocal[index]["inicio"] as? NSDate
            let fechaString = dateFormatter.formatoDiaMesLargoString(fecha: fecha!)
            diasPrograma.append(fechaString)
        }
    }
        else{
            let fecha = congreso["inicio"]
            let fechaString = dateFormatter.formatoAnoMesDiaString(fecha:fecha! as! NSDate)
            diasPrograma.append(fechaString)
            
        }
        
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
    
        return diasProgramaFiltrados
    }
    
    
    
    func diasProgramaDate() ->[String]{
        
        var diasPrograma = [String]()

        if (eventosVarLocal.count != 0){
        for index in 0...(eventosVarLocal.count - 1) {

            let fecha = eventosVarLocal[index]["inicio"]
            let fechaString = dateFormatter.formatoAnoMesDiaString(fecha:fecha! as! NSDate)
            diasPrograma.append(fechaString)
            }
        }
            else{
                let fecha = congreso["inicio"]
                let fechaString = dateFormatter.formatoAnoMesDiaString(fecha:fecha! as! NSDate)
                diasPrograma.append(fechaString)

            }
    
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        return diasProgramaFiltrados
    }
    
    
    @objc func avanzar(sender: UIButton!){
        
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
        self.configurarNavegacion()
    }
    
    @objc func retroceder(sender: UIButton!){
        
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
        self.configurarNavegacion()
    }
    
    @objc func cambiarFavorito(sender: UIButton!){
        
        let user = PFUser.current()
        
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "user == %@", user!))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.includeKey("actividad")
        favoritoQuery.includeKey("user")
        
        favoritoQuery.findObjectsInBackground().continue({ (taskFav:BFTask<NSArray>) -> Any? in
            
        self.favs = taskFav.result as! [PFObject]
        let evento = self.eventosFiltrados[sender.tag]

            
        let actividades = self.favs.map{$0.value(forKey: "actividad") as? PFObject}
        
            
        if !(actividades.containss(obj: evento)) {
            let f = PFObject(className: "ActFavUser")
            f.setObject(evento, forKey: "actividad")
            f.setObject(user as Any, forKey: "user")
            f.setObject(self.congreso, forKey: "congreso")
            self.favs.append(f)
            f.pinInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
            
                return task
            })
            DispatchQueue.main.async {
                sender.setImage(UIImage(named: "Btn_favoritos_SinMarcar"), for: .normal)
            self.tabla.reloadData()
            }
        }
                
        else{
            let object = actividades.filter{(evento.isEqual($0))}
            let a = object.first
            
           let filtro = self.favs.filter{(($0.value(forKey: "actividad")) as! PFObject).isEqual(a!)}
            
            
            if let index = self.favs.index(of:filtro.first!) {
                self.favs.remove(at: index)
                
             _ =   filtro.map{$0.unpinInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                    return task
                })}
            }
            
            DispatchQueue.main.async {
                sender.setImage(UIImage(named: "btn_Favorito_marcado"), for: .normal)
                self.tabla.reloadData()
            }}
                return taskFav
        })
    }
    
    func filtrarArray(indicador:Int) {

        let date1 = dateFormatter.formatoAnoMesDiaDate(string:diasProgramaDate()[indicador])
        
        let filteredArray = eventosVarLocal.filter() {
            
            return ($0["inicio"] as AnyObject).compare((date1.addingTimeInterval(60*60*24))) == ComparisonResult.orderedAscending && ($0["inicio"] as AnyObject).compare(date1) == ComparisonResult.orderedDescending
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

    @objc func volver() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func configurarNavegacion(){
        self.diaControl.center.x = self.view.center.x
        self.diaControl.frame.size = CGSize(width: 0.0, height: 20.0)
        self.diaControl.sizeToFit()
        self.botonRetroceder.frame.origin = CGPoint(x: self.diaControl.frame.minX - 42.25, y: self.diaControl.center.y - 15.0)
        self.botonAvanzar.frame.origin = CGPoint(x: self.diaControl.frame.maxX + 32.5, y: self.diaControl.center.y - 15.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  }



