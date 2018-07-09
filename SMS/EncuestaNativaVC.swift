//
//  ViewController.swift
//  encuestaNativa
//
//  Created by Arturo Sanhueza on 21-06-18.
//  Copyright © 2018 Arturo Sanhueza. All rights reserved.
//

import UIKit

class EncuestaNativaVC: UIViewController {
    
    var indicadorPregunta = Int()
    var arrayBotones = [UIButton]()
    var arrayLabels = [UILabel]()
    var arrayPreguntas = [String]()
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
        

    indicadorPregunta = 0
    arrayPreguntas = ["¿Vamos a hacer la pregunta número uno?","¿Vamos a hacer la pregunta número dos?","¿Vamos a hacer la pregunta número tres?","¿Vamos a hacer la pregunta número cuatro?","¿Vamos a hacer la pregunta número cinco?"]
        arrayOpcionesPregunta = [["Primera alternativa con un texto más largo para hacer una prueba Primera alternativa con un texto más largo para hacer una prueba,","Segunda alternativa","Tercera alternativa", "Cuarta alternativa"],["Primera alternativa","Segunda alternativa","Tercera alternativa","Cuarta alternativa"],["Primera alternativa","Segunda alternativa","Tercera alternativa", "Cuarta alternativa"], ["Primera alternativa","Segunda alternativa","Tercera alternativa", "Cuarta alternativa"],["Primera alternativa","Segunda alternativa","Tercera alternativa", "Cuarta alternativa"]]

        contenidoTexto.removeFromSuperview()
        seleccionarOpciones()
        
        botonAvanzar.addTarget(self, action: #selector(irSiguientePregunta), for: .touchUpInside)
        botonRetroceder.addTarget(self, action: #selector(irPreguntaAnterior), for: .touchUpInside)
    }

    func seleccionarOpciones(){
        var factorDinamicoDePosicionY = CGFloat(180.0)
        let opciones = arrayOpcionesPregunta[indicadorPregunta]
        progresoBarra()
    for object in opciones {
    let index = opciones.index(of: object) as! Int
    let factorDinamicoDePosicion = CGFloat(index * 60)
    let button = UIButton(type: .system)
    let labelTextoAlternativa = UILabel(frame: CGRect(x: 40.0, y: factorDinamicoDePosicionY + 20.0, width: view.frame.size.width - 100.0, height: 0.0))
        print(labelTextoAlternativa.frame)
    
    let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)

        labelTextoAlternativa.sizeThatFits(maximumLabelSizeTitulo)
        labelTextoAlternativa.font = UIFont.systemFont(ofSize: 15.0)
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
    button.addTarget(self, action: #selector(seleccionarBotonAlternativa), for: .touchUpInside)
    arrayBotones.append(button)
    arrayLabels.append(labelTextoAlternativa)
    self.view.addSubview(button)
    self.view.addSubview(labelTextoAlternativa)
        
        }
    }
    
    @objc func seleccionarBotonAlternativa() {
        
        /// acá se desencadenan los eventos visuales de seleccionar una alternativa
    }


    @objc func irSiguientePregunta(){

        if(indicadorPregunta < arrayPreguntas.count - 1){

        indicadorPregunta = indicadorPregunta + 1
        labelPregunta.text = arrayPreguntas[indicadorPregunta]
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
        labelPregunta.text = arrayPreguntas[indicadorPregunta]
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
        
        
        let textoContadorPreguntas = String("número pregunta" +  String(indicadorPregunta + 1) + "/" + String(arrayPreguntas.count))
        labelContadorPreguntas.text = textoContadorPreguntas
        
    }
    
    func progresoBarra(){
        
        let progresoFloat = Float(indicadorPregunta + 1)/Float(arrayPreguntas.count)
        
        print(progresoFloat)
        
        self.barraDeProgreso.setProgress(progresoFloat, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
