//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class DetalleProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var tablaActividades: UITableView!
    @IBOutlet weak var tablaFunciones: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var labelTituloDetallePrograma: UILabel!
    @IBOutlet weak var labelHoraDetallePrograma: UILabel!
    
    @IBOutlet weak var labelTitulo: UILabel!
    
    @IBOutlet weak var labelDiaDetallePrograma: UILabel!
    @IBOutlet weak var labelLugarDetallePrograma: UILabel!
    @IBOutlet weak var textViewInfoDetallePrograma: UITextView!

    var hora: String!
    var dia:String!
    var colorFondo:UIColor!
    var a = [String]()
    var funciones = ["Ir al Mapa","Evaluar","Preguntar","Encuesta"]
    var roles:[String]!
    var evento:PFObject!
    var congreso:PFObject!
    var favoritoAct:PFObject!
    var personas = [PFObject]()
    var actividadesAnidadas = [PFObject]()
    var favorito = Bool()
    var dateFormatter = DateFormatter()
    var tamanoCelda = CGFloat()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "ActContAct", predicate: NSPredicate(format: "contenedor == %@", evento))
        query.fromLocalDatastore()
        query.includeKey("contenedor")
        query.includeKey("contenido")
        query.includeKey("contenido.lugar")
        query.limit = 1000
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in

            let a = task.result as! [PFObject]
            print(a)
            if(a.count != 0){
                self.actividadesAnidadas = a.map{$0.value(forKey: "contenido") as? PFObject}.flatMap{$0}
            }
            DispatchQueue.main.async() {
                
                self.tablaActividades.reloadData()

            }
            return task
        })
        
        self.tabla.isUserInteractionEnabled = false
        labelTituloDetallePrograma.textColor = UIColor.white
        labelHoraDetallePrograma.textColor = UIColor.white
        labelDiaDetallePrograma.textColor = UIColor.white
        labelLugarDetallePrograma.textColor = UIColor.white

        labelTituloDetallePrograma.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        labelHoraDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        labelDiaDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        labelLugarDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        
        
        labelTituloDetallePrograma.frame = CGRect(x: 28.0, y: 84.0, width: self.view.frame.size.width - 76.0, height: 0.0)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelTituloDetallePrograma.sizeThatFits(maximumLabelSizeTitulo)
        labelTituloDetallePrograma.text = evento["nombre"] as? String
        labelTituloDetallePrograma?.textAlignment = .left
        labelTituloDetallePrograma.numberOfLines = 0
        labelTituloDetallePrograma?.sizeToFit()

        labelHoraDetallePrograma.frame.origin = CGPoint(x: 28.0, y: 94.0 + labelTituloDetallePrograma.frame.size.height)
        
        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelHoraDetallePrograma.sizeThatFits(maximumLabelSizeHora)
        labelHoraDetallePrograma.text = hora
        labelHoraDetallePrograma?.textAlignment = .left
        labelHoraDetallePrograma.numberOfLines = 0
        labelHoraDetallePrograma?.sizeToFit()

        
        labelDiaDetallePrograma.frame.origin = CGPoint(x: 28.0, y: 99.0 + labelTituloDetallePrograma.frame.size.height + labelHoraDetallePrograma.frame.size.height)
        
        let maximumLabelSizeDia = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelDiaDetallePrograma.sizeThatFits(maximumLabelSizeDia)
        labelDiaDetallePrograma.text = dia
        labelDiaDetallePrograma?.textAlignment = .left
        labelDiaDetallePrograma.numberOfLines = 0
        labelDiaDetallePrograma?.sizeToFit()

        labelLugarDetallePrograma.frame.origin = CGPoint(x: 28.0, y: 104.0 + labelTituloDetallePrograma.frame.size.height + labelHoraDetallePrograma.frame.size.height + labelDiaDetallePrograma.frame.size.height)
        let lugar = evento["lugar"] as? PFObject
        
        let maximumLabelSizeLugar = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelLugarDetallePrograma.sizeThatFits(maximumLabelSizeLugar)
        labelLugarDetallePrograma.text = lugar?["nombre"] as? String
        labelLugarDetallePrograma?.textAlignment = .left
        labelLugarDetallePrograma.numberOfLines = 0
        labelLugarDetallePrograma?.sizeToFit()
        
        self.tabla.frame = CGRect(x: 0.0, y: labelLugarDetallePrograma.frame.origin.y + labelLugarDetallePrograma.frame.size.height + 25.0, width: self.view.frame.width, height: CGFloat(60 * personas.count))

        self.tabla.isScrollEnabled = false
        self.textViewInfoDetallePrograma.frame = CGRect(x: 10.0, y: self.tabla.frame.origin.y + self.tabla.frame.height + 10.0, width: self.view.frame.size
            .width - 10.0, height: 0.0)

        let maximumLabelSizeDetalleInfo = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        textViewInfoDetallePrograma.sizeThatFits(maximumLabelSizeDetalleInfo)
        textViewInfoDetallePrograma.text = evento["descripcion"] as? String
        textViewInfoDetallePrograma?.textAlignment = .left
        textViewInfoDetallePrograma?.sizeToFit()
        textViewInfoDetallePrograma.isScrollEnabled = false
        
        if((evento["descripcion"] as? String) == nil){

            textViewInfoDetallePrograma.frame.size.height = 5.0
        
        }
        if(actividadesAnidadas.count == 0){
            
            self.tablaActividades.frame.size.height = 0.0
        }
        
    
        
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tabla.frame.origin.y - 5.0))
        colorFondoHeaderDetalle.backgroundColor = colorFondo
//
        self.scrollView.addSubview(colorFondoHeaderDetalle)
        scrollView.sendSubview(toBack: colorFondoHeaderDetalle)


        if(lugar?["imgPerfil"] != nil){

        }
        else{
            funciones.remove(at: 0)

        }
    
        self.tablaActividades.frame = CGRect(x: 0.0, y: textViewInfoDetallePrograma.frame.height + textViewInfoDetallePrograma.frame.origin.y, width: self.view.frame.width, height: view.frame.height - (textViewInfoDetallePrograma.frame.height + textViewInfoDetallePrograma.frame.origin.y))
        self.tablaActividades.tableFooterView = UIView()
        

        self.tablaFunciones.frame = CGRect(x: 0.0, y: textViewInfoDetallePrograma.frame.height + self.tablaActividades.frame.origin.y, width: view.frame.width, height: (48.0 * CGFloat(funciones.count)) + 30.0)
        self.tablaFunciones.tableFooterView = UIView()
        
        self.tablaFunciones.separatorColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.6)
        tablaFunciones.isScrollEnabled = false
        scrollView.frame = CGRect(x: 0.0, y: -44.0, width: view.frame.width, height: view.frame.height + 44.0)
        scrollView.contentSize = CGSize(width: view.frame.width, height: tablaFunciones.frame.maxY)
        
        print(tablaFunciones.frame.height)
        print(tablaFunciones.frame.origin)
        print(tablaFunciones.frame.maxY)
    }
    
    func irAPreguntas(){
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PreguntasVC") as! PreguntasVC
        
        vc.evento = evento!
        navigationController?.show(vc, sender: nil)

    }
    
    func irAEncuesta(){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EncuestaVC") as! EncuestaVC
        
        vc.evento = evento!
        vc.tipoEncuesta = "actividad"

        navigationController?.show(vc, sender: nil)
        
    }


    func evaluar(){
        
        let alert = UIAlertController(title: "Rating", message: "¿Qué te pareció ésta charla?", preferredStyle: .actionSheet)
        
        for i in ["★", "★★", "★★★", "★★★★","★★★★★"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: doSomething))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func doSomething(action: UIAlertAction) {

        let calificacion = action.title?.characters.count
        let rating = PFObject(className: "Rating")
        rating.setObject(calificacion!, forKey: "calificacion")
        rating.setObject(evento, forKey: "evento")
        rating.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
            
            return task
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let queryPersona = PFQuery(className: "PersonaRolAct")
        queryPersona.limit = 1000
        queryPersona.fromLocalDatastore()
        queryPersona.includeKey("persona")
        queryPersona.includeKey("act")
        queryPersona.findObjectsInBackground().continue({ (taskPersonas:BFTask<NSArray>) -> Any? in
            
            self.personas = taskPersonas.result as! [PFObject]
            DispatchQueue.main.async {
                
                self.tablaActividades.reloadData()
            }
            return taskPersonas
        })
        
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "(user == %@) AND (actividad == %@)", PFUser.current()!,self.evento))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.getFirstObjectInBackground().continue({ (taskFav:BFTask<PFObject>) -> Any? in
            
            if(taskFav.result != nil){
                
                self.favorito = true
                self.favoritoAct = taskFav.result!
                
            }
            else{
                self.favorito = false
                
            }
            DispatchQueue.main.async {
                self.agregarBotonFavoritoNav()
                
            }
            
            return taskFav
        })
    }
    func irAMapa()
    {   let lugar = evento["lugar"] as? PFObject
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        if (lugar?["imgPerfil"] != nil){
            
            vc.mapa = lugar?["imgPerfil"] as! PFFile
        }
        
        vc.nombreSalon = lugar?["nombre"] as! String
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tableView == tabla)
        {
            return personas.count
            
        }
         else if(tableView == tablaActividades)
        {
            return actividadesAnidadas.count
            
        }

        else{
        
            return funciones.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == tabla){
            return 60.0}
        else if(tableView == tablaFunciones){
            
            return 48.0
        }
        else{
            return tamanoCelda + 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if (tableView == tabla){
        let persona = personas[indexPath.row]
        
        cell.labelNombre.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)


        let a = roles[indexPath.row]
        cell.imagenPerfil.frame.origin = CGPoint(x: 16.0, y: 5.0)
        cell.labelRol.text = a
        
            if (persona["ImgPerfil"] == nil) {
                
                cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
            }
            else{
                let im = persona["ImgPerfil"] as? PFFile
                im?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
                    DispatchQueue.main.async {
                        
                        cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                }
            })}}
            
        else if (tableView == tablaActividades){

        
            let evento = actividadesAnidadas[indexPath.row] as PFObject
            
            _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
                
                let persona = $0.value(forKey: "persona") as? PFObject
                
                if !(evento.allKeys.containss(obj: "personas")){
                    evento.addUniqueObject(persona as Any, forKey: "personas")
                    
                }}}
            
            let personaActividad = evento["personas"] as? [PFObject]
            
            let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate!)
            let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate!)
            
            cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
            cell.labelTitulo?.frame = CGRect(x: 38.0, y: 20.0, width: view.frame.size.width - 100.0, height:0.0)
            let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
            cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
            cell.labelTitulo.font = UIFont.systemFont(ofSize: 16.0)
            cell.labelTitulo.text = evento["nombre"] as? String
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
            
            
            let lugar = evento["lugar"] as? PFObject
            
            let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
            cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelLugar?.frame = CGRect(x: 65.0 + cell.labelHora.frame.width, y: cell.labelTitulo.frame.size.height + 35.0, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width), height: 40.0)
            cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
            cell.labelLugar.text = lugar?["nombre"] as? String
            cell.labelLugar?.textAlignment = .left
            cell.labelLugar.numberOfLines = 0
            cell.labelLugar?.sizeToFit()
            
            var personasTamano = Int()
            
            if(personaActividad != nil){
                
                var personasString = String()
                
                for object in (personaActividad)!{
                    
                    let persona = object
                
                    personasString.append((persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String) + "\n")
                    personasTamano = personasTamano + (28 / (personaActividad?.count)!)
                }
                let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - 152.0), height: 40000.0)
                cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
                cell.labelSpeaker1?.frame = CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 60.0, width: 0.0, height: 0.0)
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

            
            tamanoCelda = cell.labelTitulo.frame.height + cell.labelLugar.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + CGFloat(personasTamano)
            
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
            
            cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 10.0, height:tamanoCelda))
            
        }
        else {
        let funcion = funciones[indexPath.row]
            
            cell.labelTitulo?.frame = CGRect(x: 28.0, y: 20.0, width: view.frame.size.width - 100.0, height:0.0)
            let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
            cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
            cell.labelTitulo.font = UIFont.systemFont(ofSize: 16.0)
            cell.labelTitulo.text = funcion

            cell.labelTitulo.textColor = UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.labelTitulo?.textAlignment = .left
            cell.labelTitulo.numberOfLines = 0
            cell.labelTitulo?.sizeToFit()
            
        }
        return cell
    }
    
    
    func agregarBotonFavoritoNav(){
        
        
        if favorito == true {

       navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_Favorito_marcado"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        else{

           navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Btn_favoritos_SinMarcar"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        
    }

    @objc func cambiarFavorito(sender: UIBarButtonItem!){
        

        if favorito == true {
        
            if(favoritoAct != nil){
            favoritoAct.unpinInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                DispatchQueue.main.async {
                    sender.image = UIImage(named: "Btn_favoritos_SinMarcar")
                    
                }
                self.favorito = false
                return task
            })}
        }
        else{
            let fav = PFObject(className: "ActFavUser")
            fav.setObject(PFUser.current()!, forKey: "user")
            fav.setObject(evento, forKey: "actividad")
            fav.setObject(congreso, forKey: "congreso")
            fav.pinInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                DispatchQueue.main.async {
                    sender.image = UIImage(named: "btn_Favorito_marcado")

                }
                self.favorito = true
                return task
                
                })
            
            }}
        
   // }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == tablaActividades){
        let evento =  actividadesAnidadas[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)
        
        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.evento = evento
        if(evento["tipo"] as? String == "conferencia")
        {
            vc.colorFondo = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
        
        if(evento["tipo"] as? String == "social"){
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
        if(evento["tipo"] as? String == "break"){
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }

        else{
            vc.colorFondo = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }
        vc.congreso = congreso
        
        var object = Array<Any>()
        var roles = Array<Any>()
        _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
            let persona = $0.value(forKey: "persona") as? PFObject
            let rol = $0.value(forKey: "rol") as? String
            object.append(persona!)
            roles.append(rol!)
            
            }
            
        }
        
        let personaActividad = object as? [PFObject]
        
        if personaActividad != nil {
            
            vc.personas = personaActividad!
            vc.roles = roles as? [String]
        }
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
            
        }
        else if(tableView == tablaFunciones){
        
        let funcion = funciones[indexPath.row]
        
            if(funcion == "Ir al Mapa"){
                self.irAMapa()
            }
            else if(funcion == "Evaluar"){
                
                evaluar()
            }
            else if(funcion == "Encuesta"){
                
                irAEncuesta()
            }

            else{
                irAPreguntas()
            }}
        tableView.deselectRow(at: indexPath, animated: true)
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

