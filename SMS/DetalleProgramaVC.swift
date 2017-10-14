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

    @IBOutlet weak var labelTituloDetallePrograma: UILabel!
    @IBOutlet weak var labelHoraDetallePrograma: UILabel!
    
    @IBOutlet weak var labelTitulo: UILabel!
    
    @IBOutlet weak var labelDiaDetallePrograma: UILabel!
    @IBOutlet weak var labelLugarDetallePrograma: UILabel!
    @IBOutlet weak var textViewInfoDetallePrograma: UITextView!
    @IBOutlet weak var botonMapa: UIButton!

    var hora: String!
    var dia:String!
    var colorFondo:UIColor!
    var a = [String]()
    var evento:PFObject!
    var favoritoAct:PFObject!
    var personas = [PFObject]()
    var actividadesAnidadas = [PFObject]()
    var favorito:Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "ActContAct", predicate: NSPredicate(format: "contenedor == %@", evento))
        query.includeKey("contenido")
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            print(task.result?.count as Any)
            let a = task.result as! [PFObject]

            DispatchQueue.main.async() {
                
                if(a.count != 0){
                self.actividadesAnidadas = a.map{$0.value(forKey: "contenido") as! PFObject}
                
                self.tablaActividades.reloadData()
                }
            }
            return task
        })
        
        botonMapa.addTarget(self, action: #selector(irAMapa), for: .touchUpInside)
        self.tabla.isUserInteractionEnabled = false
        labelTituloDetallePrograma.textColor = UIColor.white
        labelHoraDetallePrograma.textColor = UIColor.white
        labelDiaDetallePrograma.textColor = UIColor.white
        labelLugarDetallePrograma.textColor = UIColor.white

        labelTituloDetallePrograma.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
        labelHoraDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
        labelDiaDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
        labelLugarDetallePrograma.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
        
        
        labelTituloDetallePrograma.frame = CGRect(x: 38.0, y: 84.0, width: self.view.frame.size.width - 76.0, height: 0.0)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        labelTituloDetallePrograma.sizeThatFits(maximumLabelSizeTitulo)
        labelTituloDetallePrograma.text = evento["nombre"] as? String
        labelTituloDetallePrograma?.textAlignment = .left
        labelTituloDetallePrograma.numberOfLines = 0
        labelTituloDetallePrograma?.sizeToFit()

        labelHoraDetallePrograma.frame.origin = CGPoint(x: 38.0, y: 94.0 + labelTituloDetallePrograma.frame.size.height)
        
        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        labelHoraDetallePrograma.sizeThatFits(maximumLabelSizeHora)
        labelHoraDetallePrograma.text = hora
        labelHoraDetallePrograma?.textAlignment = .left
        labelHoraDetallePrograma.numberOfLines = 0
        labelHoraDetallePrograma?.sizeToFit()

        
        labelDiaDetallePrograma.frame.origin = CGPoint(x: 38.0, y: 99.0 + labelTituloDetallePrograma.frame.size.height + labelHoraDetallePrograma.frame.size.height)
        
        let maximumLabelSizeDia = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        labelDiaDetallePrograma.sizeThatFits(maximumLabelSizeDia)
        labelDiaDetallePrograma.text = dia
        labelDiaDetallePrograma?.textAlignment = .left
        labelDiaDetallePrograma.numberOfLines = 0
        labelDiaDetallePrograma?.sizeToFit()

        labelLugarDetallePrograma.frame.origin = CGPoint(x: 38.0, y: 104.0 + labelTituloDetallePrograma.frame.size.height + labelHoraDetallePrograma.frame.size.height + labelDiaDetallePrograma.frame.size.height)
        
        let maximumLabelSizeLugar = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        labelLugarDetallePrograma.sizeThatFits(maximumLabelSizeLugar)
        labelLugarDetallePrograma.text = evento["lugar"] as? String
        labelLugarDetallePrograma?.textAlignment = .left
        labelLugarDetallePrograma.numberOfLines = 0
        labelLugarDetallePrograma?.sizeToFit()
        
        self.tabla.frame = CGRect(x: 0.0, y: labelLugarDetallePrograma.frame.origin.y + labelLugarDetallePrograma.frame.size.height + 25.0, width: self.view.frame.width, height: CGFloat(60 * personas.count))

        self.tabla.isScrollEnabled = false
        self.textViewInfoDetallePrograma.frame = CGRect(x: 10.0, y: self.tabla.frame.origin.y + self.tabla.frame.height + 10.0, width: self.view.frame.size
            .width, height: 0.0)

        let maximumLabelSizeDetalleInfo = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        textViewInfoDetallePrograma.sizeThatFits(maximumLabelSizeDetalleInfo)
        textViewInfoDetallePrograma.text = evento["descripcion"] as? String
        textViewInfoDetallePrograma?.textAlignment = .left
        textViewInfoDetallePrograma?.sizeToFit()

        /////
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tabla.frame.origin.y - 10.0))
        colorFondoHeaderDetalle.backgroundColor = colorFondo
        
        self.view.addSubview(colorFondoHeaderDetalle)
        view.sendSubview(toBack: colorFondoHeaderDetalle)
        ////
        botonMapa.frame.origin = CGPoint(x: 28.0, y: textViewInfoDetallePrograma.frame.origin.y + textViewInfoDetallePrograma.frame.size.height)
        
        self.agregarBotonFavoritoNav()
    }

    func irAMapa()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        if (evento["lugar"] as! String == "Salón Piccadilly y Esmeralda"){
            vc.nombreMapa = "mapaVinaPlantacasino2.png"
        }
        else{
            vc.nombreMapa = "mapaVinapiso3.png"

        }
        vc.nombreSalon = evento["lugar"] as! String
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
        else{
        
            return actividadesAnidadas.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if (tableView == tabla){
        let persona = personas[indexPath.row]
        
        cell.labelNombre.text = (persona["preNombre"] as! String) + " " + (persona["primerNombre"] as! String) + " " + (persona["primerApellido"] as! String)


        let a = persona["rol"] as! NSArray
      
        cell.labelRol.text = a.firstObject as? String
        
        if (persona["imagenPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(persona["imagenPerfil"])
            cell.imagenPerfil.image = UIImage(data: persona["imagenPerfil"] as! Data)
            }
        }
        else{
        
            let actividad = actividadesAnidadas[indexPath.row] as PFObject
            
            cell.labelNombre.text = actividad["nombre"] as? String
        }

        return cell
    }
    
    func agregarBotonFavoritoNav(){
        
    var barBotonFavorito = UIBarButtonItem(image: UIImage(named: "btnFavorito.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        
        if favorito == true {
        
        barBotonFavorito = UIBarButtonItem(image: UIImage(named: "favMarcado.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        else{
            barBotonFavorito = UIBarButtonItem(image: UIImage(named: "btnFavorito.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        
        navigationItem.rightBarButtonItem = barBotonFavorito
    }

    func cambiarFavorito(sender: UIBarButtonItem!){
        if favorito == true {

            favoritoAct.deleteInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                DispatchQueue.main.async {

                sender.image = UIImage(named: "btnFavorito.png")
                }
                return task
            })
        }
        else{
            let fav = PFObject(className: "ActFavUser")
            fav.setObject(PFUser.current()!, forKey: "user")
            fav.setObject(evento, forKey: "actividad")

            fav.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                DispatchQueue.main.async {
                    
                    sender.image = UIImage(named: "favMarcado.png")

                }
                return task
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

