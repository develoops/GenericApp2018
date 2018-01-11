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
    
    @IBOutlet weak var botonModulo: UIButton!

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
    var funciones = ["Ir al Mapa","Preguntar","Evaluar"]
    var roles:[String]!
    var evento:PFObject!
    var congreso:PFObject!
    var favoritoAct = [PFObject]()
    var personas = [PFObject]()
    var actividadesAnidadas = [PFObject]()
    var favorito = Bool()
    var dateFormatter = DateFormatter()
    var tamanoCelda = CGFloat()
    var tamanoTabla = CGFloat()
    var tieneModulo: Bool!
    var nombreModulo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "ActContAct", predicate: NSPredicate(format: "contenedor == %@", evento))
        query.fromLocalDatastore()
        query.includeKey("contenedor")
        query.includeKey("contenido")
        query.includeKey("contenido.lugar")
        query.limit = 1000
        query.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            let a = task.result as! [PFObject]
            if(a.count != 0){
                self.actividadesAnidadas = a.map{$0.value(forKey: "contenido") as? PFObject}.flatMap{$0}
            }
            DispatchQueue.main.async() {
        self.tablaActividades.reloadData()
        self.tablaActividades.frame = CGRect(x: 0.0, y: self.textViewInfoDetallePrograma.frame.height + self.textViewInfoDetallePrograma.frame.origin.y, width: self.view.frame.width, height: 0.0)
                self.tablaActividades.tableFooterView = UIView()
                self.tablaFunciones.tableFooterView = UIView()
                self.tablaFunciones.separatorColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.6)
                self.tablaFunciones.isScrollEnabled = false
                self.scrollView.frame = CGRect(x: 0.0, y: -44.0, width: self.view.frame.width, height: self.view.frame.height + 44.0)
                
                if(self.actividadesAnidadas.count == 0){
                    self.tablaFunciones.isHidden = false
                    self.tablaActividades.frame.size.height = 0.0
                    
                }
                else{
                    self.tablaFunciones.isHidden = true
                    self.tablaActividades.frame.size.height = 0.01
                    
                }
                
                self.tablaFunciones.frame = CGRect(x: 0.0, y: self.textViewInfoDetallePrograma.frame.maxY, width: self.view.frame.width, height: (48.0 * CGFloat(self.funciones.count)) + 30.0)

                self.tablaActividades.isScrollEnabled = false
                
        }
            return task
        }
        
        if(tieneModulo == true){
            
            print(nombreModulo)
            botonModulo.isHidden = false
            botonModulo.setTitle(nombreModulo + " >", for: .normal)
            botonModulo.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            botonModulo.titleLabel?.textAlignment = .left
            botonModulo.tintColor = UIColor.white
            botonModulo.frame =  CGRect(x: 15.0, y:51.5, width: self.view.frame.size.width - 76.0, height: 12.0)
            
            labelTituloDetallePrograma.frame = CGRect(x: 15.0, y:botonModulo.frame.maxY + 7.5, width: self.view.frame.size.width - 76.0, height: 0.0)

        }
        else{
            botonModulo.isHidden = true
            labelTituloDetallePrograma.frame = CGRect(x: 15.0, y:51.5, width: self.view.frame.size.width - 76.0, height: 0.0)

        }
        self.tabla.isUserInteractionEnabled = false
        labelTituloDetallePrograma.textColor = UIColor.white
        labelHoraDetallePrograma.textColor = UIColor.white
        labelDiaDetallePrograma.textColor = UIColor.white
        labelLugarDetallePrograma.textColor = UIColor.white
        
        labelTituloDetallePrograma.font =  UIFont.systemFont(ofSize: 15.0)
        labelHoraDetallePrograma.font =  UIFont.systemFont(ofSize: 12.0)
        labelDiaDetallePrograma.font =  UIFont.systemFont(ofSize: 12.0)
        labelLugarDetallePrograma.font =  UIFont.systemFont(ofSize: 12.0)
        

        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelTituloDetallePrograma.sizeThatFits(maximumLabelSizeTitulo)
        labelTituloDetallePrograma.text = evento["nombre"] as? String
        labelTituloDetallePrograma?.textAlignment = .left
        labelTituloDetallePrograma.numberOfLines = 0
        labelTituloDetallePrograma?.sizeToFit()
        
        labelHoraDetallePrograma.frame.origin = CGPoint(x: 15.0, y: labelTituloDetallePrograma.frame.maxY + 5.0)
        

        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelHoraDetallePrograma.sizeThatFits(maximumLabelSizeHora)
        labelHoraDetallePrograma.text = hora
        labelHoraDetallePrograma?.textAlignment = .left
        labelHoraDetallePrograma.numberOfLines = 0
        labelHoraDetallePrograma?.sizeToFit()
        
        
        labelDiaDetallePrograma.frame.origin = CGPoint(x: 15.0, y: labelHoraDetallePrograma.frame.maxY + 2.5)
        
        let maximumLabelSizeDia = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelDiaDetallePrograma.sizeThatFits(maximumLabelSizeDia)
        labelDiaDetallePrograma.text = dia
        labelDiaDetallePrograma?.textAlignment = .left
        labelDiaDetallePrograma.numberOfLines = 0
        labelDiaDetallePrograma?.sizeToFit()
        
        labelLugarDetallePrograma.frame.origin = CGPoint(x: 15.0, y:labelDiaDetallePrograma.frame.maxY + 2.5)
        let lugar = evento["lugar"] as? PFObject
        
        let maximumLabelSizeLugar = CGSize(width: (self.view.frame.size.width - 26.0), height: 40000.0)
        labelLugarDetallePrograma.sizeThatFits(maximumLabelSizeLugar)
        labelLugarDetallePrograma.text = lugar?["nombre"] as? String
        labelLugarDetallePrograma?.textAlignment = .left
        labelLugarDetallePrograma.numberOfLines = 0
        labelLugarDetallePrograma?.sizeToFit()
        
        self.tabla.frame = CGRect(x: 0.0, y: labelLugarDetallePrograma.frame.maxY + 7.5, width: self.view.frame.width, height: CGFloat(personas.count) * 55.5)
        
        self.tabla.isScrollEnabled = false
        
        self.textViewInfoDetallePrograma.frame = CGRect(x: 10.0, y: self.tabla.frame.maxY + 2.5, width:self.view.frame.size.width - 15.0, height: 0.0)
        
        textViewInfoDetallePrograma.text = evento["descripcion"] as? String
        textViewInfoDetallePrograma.translatesAutoresizingMaskIntoConstraints = true
        textViewInfoDetallePrograma?.textAlignment = .left
        textViewInfoDetallePrograma?.sizeToFit()
        textViewInfoDetallePrograma.isScrollEnabled = false
        
        let imagenLinea = UIImageView(frame: CGRect(x: 15.0, y: textViewInfoDetallePrograma.frame.maxY, width: view.frame.width - 25.0, height: 2.5))
        
        let a = getImageWithColor(color: UIColor.lightGray, size: CGSize (width: view.frame.width - 10.0, height: 2.5))
        imagenLinea.image = a
        self.scrollView.addSubview(imagenLinea)
        
        if((evento["descripcion"] as? String) == nil){
            
            textViewInfoDetallePrograma.frame.size.height = 5.0
            
        }
        
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: labelLugarDetallePrograma.frame.maxY + 10.0))
        colorFondoHeaderDetalle.backgroundColor = colorFondo

        self.scrollView.addSubview(colorFondoHeaderDetalle)
        scrollView.sendSubview(toBack: colorFondoHeaderDetalle)
        
        
        if(lugar?["imgPerfil"] != nil){
            
        }
        else{
            funciones.remove(at: 0)
            
        }
        if(evento["tipo"] as? String == "break" || evento["tipo"] as? String == "social"){
            
            
            funciones.remove(at: funciones.count - 1)
            
        }
        self.scrollView.canCancelContentTouches = false
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
        
        let calificacion = action.title?.count
        let rating = PFObject(className: "Rating")
        rating.setObject(calificacion!, forKey: "calificacion")
        rating.setObject(evento, forKey: "evento")
        rating.saveInBackground().continueWith{ (task:BFTask<NSNumber>) -> Any? in
            
            return task
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let queryPersona = PFQuery(className: "PersonaRolAct")
        queryPersona.limit = 1000
        queryPersona.fromLocalDatastore()
        queryPersona.includeKey("persona")
        queryPersona.includeKey("act")
        queryPersona.findObjectsInBackground().continueWith{ (taskPersonas:BFTask<NSArray>) -> Any? in
            
            self.personas = taskPersonas.result as! [PFObject]
            DispatchQueue.main.async {
                self.tablaActividades.reloadData()
            }
            return taskPersonas
        }
        
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "(user == %@) AND (actividad == %@)", PFUser.current()!,self.evento))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.findObjectsInBackground().continueWith{ (taskFav:BFTask<NSArray>) -> Any? in
            
    let fa = taskFav.result as? [PFObject]
    DispatchQueue.main.async {
    
        if(fa?.count != 0){
            
        self.favorito = true
        self.favoritoAct = taskFav.result! as! [PFObject]
        self.agregarBotonFavoritoNav()
        
        }
    else
        {
        self.favorito = false
        self.agregarBotonFavoritoNav()
                    
        }
    }
            return taskFav
        }
        self.tablaFunciones.frame = CGRect(x: 0.0, y: self.textViewInfoDetallePrograma.frame.maxY, width: self.view.frame.width, height: (48.0 * CGFloat(self.funciones.count)) + 30.0)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.tablaFunciones.frame.maxY + 44.0)
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
            return 55.5}
        else if(tableView == tablaFunciones){
            
            return 37.5
        }
        else{
            return tamanoCelda
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        

        if (tableView == tabla){
            let persona = personas[indexPath.row]
            
            cell.accessoryType = .disclosureIndicator
            
            cell.labelNombre.text = (persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String)
            
            let a = roles[safe: indexPath.row]
            cell.imagenPerfil.frame.origin = CGPoint(x: 15.0, y: 7.5)
            cell.imagenPerfil.frame.size = CGSize(width: 40.0, height: 40.0)

            cell.labelNombre.font = UIFont.systemFont(ofSize: 15.0)
            cell.labelNombre.frame.origin = CGPoint(x: cell.imagenPerfil.frame.maxX + 22.5, y: 7.5)
            
            cell.labelRol.font = UIFont.systemFont(ofSize: 12.0)
            cell.labelRol.frame.origin = CGPoint(x: cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.maxY + 2.5)

            cell.labelRol.text = a
            let im = persona["ImgPerfil"] as? PFFile
            if !((im?.isDataAvailable)!) {
                
                cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
            }
            else{
                im?.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
                    DispatchQueue.main.async {
                        cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                    }
                }}
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)
            cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelNombre.frame.origin.x, bottom: 0.0, right: 10.0)

        }
            
        else if (tableView == tablaActividades){
            
            let evento = actividadesAnidadas[indexPath.row] as PFObject
            var object = Array<Any>()
            _ = personas.map{if($0.value(forKey:"act") as? PFObject == evento){
                
                let persona = $0.value(forKey: "persona") as? PFObject
                
                object.append(persona!)
                //            cell.imagenPerfil.frame.origin.x = cell.imagenMargen.frame.maxX + 10.0
                
                }}
            let im = evento["imgPerfil"] as? PFFile
            var margenImg = CGFloat()
            if(im == nil){
                cell.imagenPerfil.frame.origin = CGPoint(x: 10.0, y: 12.5)
                cell.imagenPerfil.isHidden = true
                cell.imagenPerfil.frame.size = CGSize(width: 0.0, height: 0.0)
                margenImg = 10.0
                
            }
                
            else{
                
                cell.imagenPerfil.frame.origin = CGPoint(x: (cell.imagenMargen.frame.maxX + 10.0), y: 12.5)
                cell.imagenPerfil.isHidden = false
                if(evento["tipo"] as? String == "social"){
                    cell.imagenPerfil.frame.size = CGSize(width: 29.41, height: 34.92)
                    
                    
                }
                else if(evento["tipo"] as? String == "break"){
                    
                    cell.imagenPerfil.frame.size = CGSize(width: 46.0, height: 30.5)
                    
                }
                else if(evento["tipo"] as? String == "conferenciaPatrocinada"){
                    cell.imagenPerfil.frame.size = CGSize(width: 62.5, height: 36.5)
                    
                }
                
                margenImg = 12.5
                
                im?.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
                    
                    DispatchQueue.main.async {
                        
                        if ((task.error) != nil){
                            
                            cell.imagenPerfil.image = UIImage(named: "almuerzo.png")
                            
                        }
                        else{
                            cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                        }
                    }
                    return task
                }
            }
            
            let personaActividad = object as? [PFObject]
            let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate!)
            let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate!)
            
            cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
            cell.labelTitulo?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: 7.5, width: view.frame.size.width - (60.0 + cell.imagenPerfil.frame.maxX + margenImg), height:0.0)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.hyphenationFactor = 1.0
            
            let hyphenAttribute = [
                NSAttributedStringKey.paragraphStyle : paragraphStyle,
                ] as [NSAttributedStringKey : Any]
            
            let attributedString = NSMutableAttributedString(string: (evento["nombre"] as? String)!, attributes: hyphenAttribute)
            
            let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - (60.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
            cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
            cell.labelTitulo.font = UIFont.systemFont(ofSize: 15.0)
            cell.labelTitulo.attributedText = attributedString
            cell.labelTitulo?.textAlignment = .left
            cell.labelTitulo.numberOfLines = 0
            cell.labelTitulo?.sizeToFit()
            
            let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width  - (43.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
            
            cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelHora?.frame =  CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: cell.labelTitulo.frame.size.height + 15.0, width: 0.0, height: 0.0)
            cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelHora.sizeThatFits(maximumLabelSizeHora)
            cell.labelHora.text = fechaInicio + " - " + fechaFin
            cell.labelHora?.textAlignment = .left
            cell.labelHora.numberOfLines = 0
            cell.labelHora?.sizeToFit()
            
            
            if(personaActividad != nil){
                
                var personasString = String()
                
                for object in (personaActividad)!{
                    
                    let persona = object
                    
                    personasString.append((persona["preNombre"] as? String)! + " " + (persona["primerNombre"] as? String)! + " " + (persona["primerApellido"] as! String) + "\n")
                }
                
                let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - (43.0 + cell.imagenPerfil.frame.maxX + margenImg)), height: 40000.0)
                cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
                cell.labelSpeaker1?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + margenImg, y: cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height + 22.5, width: 0.0, height: 0.0)
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

            espacio = 43.0 + cell.labelHora.frame.width + cell.imagenPerfil.frame.maxX
            
            let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
            cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelLugar?.frame = CGRect(x: espacio, y: cell.labelHora.frame.origin.y, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width + 5.0 +  cell.imagenPerfil.frame.maxX + margenImg + cell.imagenMargen.frame.maxX), height: 15.0)
            cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
            cell.labelLugar.text = lugar?["nombre"] as? String
            cell.labelLugar?.textAlignment = .left
            cell.labelLugar.numberOfLines = 1
            cell.labelLugar?.sizeToFit()
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)
            cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)

            
            tamanoCelda = cell.labelTitulo.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + 15.0
            
            
            if(tamanoCelda < 75.0)
            {
                tamanoCelda = tamanoCelda + 7.5
                
            }

            tamanoTabla = tamanoTabla + tamanoCelda
            
            tablaActividades.frame.size.height = tamanoTabla
            
            self.tablaFunciones.frame = CGRect(x: 0.0, y:self.tablaActividades.frame.maxY, width: self.view.frame.width, height: (48.0 * CGFloat(self.funciones.count)) + 30.0)
            
            self.tablaFunciones.tableFooterView = UIView()
            
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.tablaFunciones.frame.maxY)
            
            
            var colorImage = UIColor()
            
            if(evento["tipo"] as? String == "conferencia")
            {
                colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
            }
            else if(evento["tipo"] as? String == "conferenciaPatrocinada")
            {
                colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
            }
                
                
            else if (evento["tipo"] as? String == "social") {
                
                colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            }
            else if (evento["tipo"] as? String == "break") {
                
                colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
                
            }
                //
            else{
                colorImage = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            }
            
            cell.imagenMargen.frame.origin = CGPoint(x: 0.0, y: 0.0)
            cell.imagenMargen.frame.size = CGSize(width: 5.5, height: tamanoCelda)
            cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 5.5, height:tamanoCelda))

        }
        else {
            let funcion = funciones[indexPath.row]
            
            cell.labelTitulo?.frame = CGRect(x: 15.0, y: 11.25, width: view.frame.size.width - 100.0, height:0.0)
            let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
            cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
            cell.labelTitulo.font = UIFont.systemFont(ofSize: 15.0)
            cell.labelTitulo.text = funcion
            
            cell.labelTitulo.textColor = UIColor(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.labelTitulo?.textAlignment = .left
            cell.labelTitulo.numberOfLines = 0
            cell.labelTitulo?.sizeToFit()
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)
            cell.layoutMargins = UIEdgeInsets(top: 0.0, left: cell.labelTitulo.frame.origin.x, bottom: 0.0, right: 10.0)

            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func agregarBotonFavoritoNav(){
        
        
        if favorito == true {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_Favorito_marcado"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        else{
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Btn_favoritos_SinMarcar"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        
    }
    
    @objc func cambiarFavorito(sender:UIBarButtonItem!){
        
        
        let favoritoQuery = PFQuery(className: "ActFavUser", predicate: NSPredicate(format: "user == %@", PFUser.current()!))
        favoritoQuery.fromLocalDatastore()
        favoritoQuery.includeKey("actividad")
        favoritoQuery.includeKey("user")
        
        favoritoQuery.findObjectsInBackground().continueWith{ (taskFav:BFTask<NSArray>) -> Any? in
            
            self.favoritoAct = taskFav.result as! [PFObject]
            
            
            let actividades = self.favoritoAct.map{$0.value(forKey: "actividad") as? PFObject}
            
            
            if !(actividades.containss(obj: self.evento)) {
                let f = PFObject(className: "ActFavUser")
                f.setObject(self.evento, forKey: "actividad")
                f.setObject(PFUser.current()!, forKey: "user")
                f.setObject(self.congreso, forKey: "congreso")
                self.favoritoAct.append(f)
                f.pinInBackground().continueWith{ (task:BFTask<NSNumber>) -> Any? in
                    
                    return task
                }
                DispatchQueue.main.async {
                    self.favorito = true
                    self.tablaActividades.reloadData()
                    self.agregarBotonFavoritoNav()
                }
            }
                
            else{
                let object = actividades.filter{(self.evento.isEqual($0))}
                let a = object.first
                
                let filtro = self.favoritoAct.filter{(($0.value(forKey: "actividad")) as! PFObject).isEqual(a!)}
                
                
                if let index = self.favoritoAct.index(of:filtro.first!) {
                    self.favoritoAct.remove(at: index)
                    
                    _ =   filtro.map{$0.unpinInBackground().continueWith{ (task:BFTask<NSNumber>) -> Any? in
                        return task
                    }}
                }
                
                DispatchQueue.main.async {
                    self.favorito = false
                    self.tablaActividades.reloadData()
                    self.agregarBotonFavoritoNav()
                    
                }}
            return taskFav
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nombreEvento = evento["nombre"]

        if(tableView == tablaActividades){
            let evento =  actividadesAnidadas[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
            let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
            let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)
            
            vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
            vc.hora = fechaInicio + " - " + fechaFin
            vc.evento = evento
            vc.nombreModulo = nombreEvento as! String
            
            if (actividadesAnidadas.count == 0){
                vc.tieneModulo = false
            }
            else{
                vc.tieneModulo = true
            }

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
                irAEncuesta()
            }
                
            else{
                irAPreguntas()
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        print(tamanoTabla)
        tamanoTabla = 0.0
        
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
