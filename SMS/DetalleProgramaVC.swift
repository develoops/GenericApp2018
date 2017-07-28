//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import CoreData

class DetalleProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tabla: UITableView!
    
    @IBOutlet weak var labelTituloDetallePrograma: UILabel!
    @IBOutlet weak var labelHoraDetallePrograma: UILabel!
    @IBOutlet weak var labelDiaDetallePrograma: UILabel!
    @IBOutlet weak var labelLugarDetallePrograma: UILabel!
    @IBOutlet weak var textViewInfoDetallePrograma: UITextView!
    @IBOutlet weak var botonMapa: UIButton!


    var hora: String!
    var dia:String!
    var colorFondo:UIColor!
    var a = [String]()
    var evento:Evento!


    override func viewDidLoad() {
        super.viewDidLoad()        
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
        labelTituloDetallePrograma.text = evento.nombre
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
        labelLugarDetallePrograma.text = evento.lugar
        labelLugarDetallePrograma?.textAlignment = .left
        labelLugarDetallePrograma.numberOfLines = 0
        labelLugarDetallePrograma?.sizeToFit()
        
        
        
        self.tabla.frame = CGRect(x: 0.0, y: labelLugarDetallePrograma.frame.origin.y + labelLugarDetallePrograma.frame.size.height + 25.0, width: self.view.frame.width, height: CGFloat(60 * (evento.personas?.allObjects.count)!))

        self.tabla.isScrollEnabled = false
        self.textViewInfoDetallePrograma.frame = CGRect(x: 10.0, y: self.tabla.frame.origin.y + self.tabla.frame.height + 10.0, width: self.view.frame.size
            .width, height: 0.0)

        let maximumLabelSizeDetalleInfo = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
        textViewInfoDetallePrograma.sizeThatFits(maximumLabelSizeDetalleInfo)
        textViewInfoDetallePrograma.text = evento.descripcion
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
        if (evento.lugar == "Salón Piccadilly y Esmeralda"){
            vc.nombreMapa = "mapaVinaPlantacasino2.png"
        }
        else{
            vc.nombreMapa = "mapaVinapiso3.png"

        }
        vc.nombreSalon = evento.lugar
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (evento.personas?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let persona = evento.personas?.allObjects[indexPath.row] as! Persona
        
        cell.labelNombre.text = (persona.tratamiento)! + " " + (persona.nombre)! + " " + (persona.apellido)!

        cell.labelRol.text = persona.rol
        if (persona.imagenPerfil?.length == 4) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            cell.imagenPerfil.image = UIImage(data: persona.imagenPerfil! as Data)
        }

        return cell
    }
    
    func agregarBotonFavoritoNav(){
        
    var barBotonFavorito = UIBarButtonItem(image: UIImage(named: "btnFavorito.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        
        if evento.favorito == true {
        
        barBotonFavorito = UIBarButtonItem(image: UIImage(named: "favMarcado.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        else{
            barBotonFavorito = UIBarButtonItem(image: UIImage(named: "btnFavorito.png"), style: .plain, target: self, action: #selector(cambiarFavorito))
        }
        
        navigationItem.rightBarButtonItem = barBotonFavorito
    }

    func cambiarFavorito(sender: UIBarButtonItem!){
        if evento.favorito == true {
            evento.setValue(false, forKey: "favorito")
            sender.image = UIImage(named: "btnFavorito.png")
        }
        else{
            evento.setValue(true, forKey: "favorito")
            sender.image = UIImage(named: "favMarcado.png")
        }
        do {
            try getContext().save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

