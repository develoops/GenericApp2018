//
//  ViewController.swift
//  encuestaNativa
//
//  Created by Arturo Sanhueza on 21-06-18.
//  Copyright © 2018 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class EncuestaNativaVC: UIViewController {
    
    var indicadorPregunta = Int()
    var tipoDeEncuesta:String!
    var encuesta:Bool!
    var arrayBotones = [UIButton]()
    var arrayLabels = [UILabel]()
    var arrayPreguntas = [String]()
    var objetosPreguntas = [PFObject]()
    var arrayOpcionesPregunta = [Array<String>]()
    
    @IBOutlet weak var labelEncabezado:UILabel!
    @IBOutlet weak var labelPregunta:UILabel!
    @IBOutlet weak var labelContadorPreguntas:UILabel!
    @IBOutlet weak var contenidoTexto:UITextView!
    @IBOutlet weak var barraDeProgreso:UIProgressView!
    @IBOutlet weak var botonAvanzar:UIButton!
    @IBOutlet weak var botonRetroceder:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          tipoDeEncuesta = "general"
        
        let queryPreguntas = PFQuery(className: "PreguntaDeEncuesta")
        queryPreguntas.fromLocalDatastore()
        queryPreguntas.limit = 1000
        queryPreguntas.whereKey("tipo", equalTo: tipoDeEncuesta)
        queryPreguntas.includeKey("encuesta")
        queryPreguntas.addAscendingOrder("posicion")
        queryPreguntas.findObjectsInBackground().continueWith { (task:BFTask<NSArray>) -> Any? in
            
            DispatchQueue.main.async() {
                self.objetosPreguntas = task.result as! [PFObject]
                
                for object in self.objetosPreguntas {
                    
                    self.arrayPreguntas.append(object["preguntaTexto"] as! String)
                    
                }
           
        
    self.indicadorPregunta = 0
     //   self.arrayOpcionesPregunta = [["Muy Satisfactorio","Satisfactorio","Normal","Insuficiente"]]
               
                for _ in 1...self.arrayPreguntas.count {
                    self.arrayOpcionesPregunta.append(["Muy Satisfactorio","Satisfactorio","Normal","Insuficiente"])
                    
                }

        self.contenidoTexto.removeFromSuperview()
        self.seleccionarOpciones()
        self.seleccionTextoIndicadorPregunta()
        self.cambiarSubTitulo()
        
        self.botonAvanzar.addTarget(self, action: #selector(self.irSiguientePregunta), for: .touchUpInside)
        self.botonRetroceder.addTarget(self, action: #selector(self.irPreguntaAnterior), for: .touchUpInside)
        self.cambiarSubTitulo()
                
            }
            return task
        }
    }
    

    func seleccionarOpciones(){
        var factorDinamicoDePosicionY = CGFloat(180.0)
        let opciones = arrayOpcionesPregunta[indicadorPregunta]
        progresoBarra()
    for object in opciones {
        
    let index = opciones.index(of: object) as! Int
    let factorDinamicoDePosicion = CGFloat(index * 60)
    let button = UIButton(type: .custom)
    let labelTextoAlternativa = UILabel(frame: CGRect(x: 40.0, y: factorDinamicoDePosicionY + 20.0, width: view.frame.size.width - 100.0, height: 0.0))
    let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)

        labelTextoAlternativa.sizeThatFits(maximumLabelSizeTitulo)
        labelTextoAlternativa.font = UIFont.systemFont(ofSize: 14.0)
        labelTextoAlternativa.text = object
        labelTextoAlternativa.textAlignment = .left
        labelTextoAlternativa.numberOfLines = 0
        labelTextoAlternativa.sizeToFit()

    button.frame = CGRect(x: 30.0, y: factorDinamicoDePosicionY + 16.0, width: labelTextoAlternativa.frame.width + 30.0, height: labelTextoAlternativa.bounds.maxY + 10.0)
   
    factorDinamicoDePosicionY = labelTextoAlternativa.frame.maxY

    button.tintColor = UIColor.white
    button.cornerRadius = 5.0
    button.borderWidth = 1.2
    button.borderColor = UIColor.lightGray
    button.tag = opciones.firstIndex(of: object) as! Int
    button.addTarget(self, action: #selector(seleccionarBotonAlternativa), for: .touchUpInside)
    arrayBotones.append(button)
    arrayLabels.append(labelTextoAlternativa)
    self.view.addSubview(button)
    self.view.addSubview(labelTextoAlternativa)
        
        }
    }
    
    @objc func seleccionarBotonAlternativa(sender:UIButton) {

        for button in arrayBotones{
              button.backgroundColor = UIColor.white
        }
        
        if(sender.backgroundColor == UIColor.cyan){
            sender.backgroundColor = UIColor.white
        }
        else{
            sender.backgroundColor = UIColor.cyan
        }
    }


    @objc func irSiguientePregunta(){

        if(indicadorPregunta < arrayPreguntas.count - 1){

        indicadorPregunta = indicadorPregunta + 1
        cambiarSubTitulo()
        //labelPregunta.text = arrayPreguntas[indicadorPregunta]
        eliminarAternativas()
            seleccionTextoIndicadorPregunta()
            seleccionarOpciones()
            progresoBarra()
        }
    }
    
    @objc func irPreguntaAnterior(){
        
        if(indicadorPregunta > 0){
        indicadorPregunta = indicadorPregunta - 1
        eliminarAternativas()
        seleccionarOpciones()
        cambiarSubTitulo()
       // labelPregunta.text = arrayPreguntas[indicadorPregunta]
            seleccionTextoIndicadorPregunta()
            progresoBarra()
        }
    }
    
    func eliminarAternativas(){
        
        for boton in arrayBotones{
            
            boton.removeFromSuperview()
            
        }
        
        for label in arrayLabels{
            
            label.removeFromSuperview()
        }

    }
    
    func seleccionTextoIndicadorPregunta(){
        
        let textoContadorPreguntas = String("Pregunta " +  String(indicadorPregunta + 1) + " de " + String(arrayPreguntas.count))
        labelContadorPreguntas.text = textoContadorPreguntas
        
    }
    
 func progresoBarra(){
        
        let progresoFloat = Float(indicadorPregunta + 1)/Float(arrayPreguntas.count)
        print(progresoFloat)
        
        self.barraDeProgreso.setProgress(progresoFloat, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func terminarEncuesta(){
        
    }
    
    func desapareceAdelante() {
        
        if(indicadorPregunta >= arrayPreguntas.count){
            botonAvanzar.isHidden = true
        }
            
        else{
            botonAvanzar.isHidden = false
        }
    }
    
    func desapareceAtras() {
        
        if(indicadorPregunta < arrayPreguntas.count){
            //cambiarSubTitulo()
        }
        
        if indicadorPregunta == 0 {
            botonRetroceder.isHidden = true
        }
        else{
            botonRetroceder.isHidden = false
           // subtitulo.isHidden = false
        }
    }
    
    func cambiarSubTitulo(){
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        
        labelPregunta.sizeThatFits(maximumLabelSizeTitulo)
        labelPregunta.font = UIFont.systemFont(ofSize: 15.0)
        if((objetosPreguntas[indicadorPregunta]["tipo"] as! String) == "general"){
            labelPregunta.text = ("Evalua tú satisfacción con respecto a :" + arrayPreguntas[indicadorPregunta])
        }
        else if((objetosPreguntas[indicadorPregunta]["tipo"] as! String) == "otro"){
            labelPregunta.text = objetosPreguntas[indicadorPregunta]["textoOpcional"] as? String
        }
        else{
            
            labelPregunta.text = ""
        }
        

        labelPregunta.textAlignment = .left
        labelPregunta.numberOfLines = 0
        labelPregunta.sizeToFit()

    }
}


extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
