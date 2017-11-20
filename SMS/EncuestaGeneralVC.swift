//
//  EncuestaVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 09-11-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
import BoltsSwift

class EncuestaGeneralVC: UIViewController {
    
    var noticias = [PFObject]()
    var tamanoCelda = CGFloat()
    var tipoEncuesta:String!
    var evento:PFObject!
    var valor:Double!
    var valores = [Double]()
    
    var indexPathInterno:IndexPath!
    var respuestas = [PFObject]()
    var index = 0
    var botonAtras = UIButton()
    var botonAdelante = UIButton()
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var encabezado:UITextView!
    @IBOutlet weak var textViewPregunta:UITextView!
    @IBOutlet weak var subtitulo:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Encuesta"
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
        
        let refresh = RefreshData()
        refresh.primerLlamado()
        
        let query = PFQuery(className: "PreguntaDeEncuesta", predicate:NSPredicate(format: "tipo == %@","general"))
        
        query.order(byAscending: "posicion")
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            self.noticias = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.textViewPregunta.text = self.noticias[self.index]["preguntaTexto"] as! String
                self.view.addSubview(self.botonAtras)
                self.desapareceAtras()
                
            }
            return task
        })
        
        encabezado.frame.size.width = view.frame.width - 30.0
        encabezado.frame.origin.x = 15.0
        
        subtitulo.frame.size.width = view.frame.width - 30.0
        subtitulo.frame.origin.x = 15.0
        
        textViewPregunta.frame.size.width = view.frame.width - 30.0
        textViewPregunta.frame.origin.x = 15.0
        textViewPregunta.frame.origin.y = subtitulo.frame.origin.y + subtitulo.frame.height
        textViewPregunta.isEditable = false
        
        
        floatRatingView.frame.origin = CGPoint(x: 15.0, y: view.center.y + 40.0)
        floatRatingView.frame.size.width = view.frame.width - 30.0

        
        botonAtras.frame = CGRect(x: 20, y: view.frame.height/1.25, width: 100, height: 50)
        botonAtras.backgroundColor = .black
        botonAtras.setTitle("Anterior", for: .normal)
        botonAtras.addTarget(self, action:#selector(self.irAtras), for: .touchUpInside)
        
        botonAdelante.frame = CGRect(x: view.frame.width - 120, y: view.frame.height/1.25, width: 100, height: 50)
        botonAdelante.backgroundColor = .black
        botonAdelante.setTitle("Siguiente", for: .normal)
        botonAdelante.addTarget(self, action:#selector(self.irAdelante), for: .touchUpInside)
        
        
        

        
        self.view.addSubview(botonAdelante)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func enviar(){
        for object in valores{
            let respuesta = PFObject(className: "RespuestaEncuesta")
            respuesta.setObject(PFUser.current()!, forKey: "user")
            respuesta.setObject(object, forKey: "valoracion")
            print(noticias[Int(object)])
            respuesta.setObject(noticias[Int(object)], forKey: "pregunta")
            respuesta.setObject(noticias[Int(object)]["encuesta"], forKey: "encuesta")
            respuesta.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                return task
            })
        }
        
        self.navigationController?.popViewController(animated: true)
        botonAdelante.isHidden = true
        botonAtras.isHidden = true
        self.textViewPregunta.text = "Muchas gracias, tu encuesta ha sido enviada exitosamente"


        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    func desapareceAdelante() {
        
        if(index >= noticias.count){
            botonAdelante.isHidden = true
        }
            
        else{
            botonAdelante.isHidden = false
            
        }
    }
    
    func desapareceAtras() {
        
        if(index < noticias.count){
            cambiarSubTitulo()
        }
        
        if index == 0 {
            botonAtras.isHidden = true
        }
        else{
            botonAtras.isHidden = false
            subtitulo.isHidden = false
            
        }
    }
    
    func cambiarSubTitulo(){
        if((noticias[index]["tipo"] as! String) == "actividad"){
            subtitulo.text = "1. En relación al contenido tratado:"
        }
        else if((noticias[index]["tipo"] as! String) == "expositor"){
            subtitulo.text = "2. En relación al expositor, mi satisfacción en relación con:"
            
        }
    }
    
    @objc func irAtras(){
        if index > 0{
            
            index = index - 1
        }
        self.textViewPregunta.text = noticias[index]["preguntaTexto"] as? String
        
        if(index < noticias.count){
            
            self.floatRatingView.isHidden = false
            self.subtitulo.isHidden = false
            self.encabezado.isHidden = false
            
        }
        self.floatRatingView.rating = valores[safe:index]!
        
        desapareceAtras()
        desapareceAdelante()
        cambiarSubTitulo()
        self.botonAdelante.setTitle("Siguiente", for: .normal)
    }
    
    @objc  func irAdelante(){
        
        index = index + 1
        self.desapareceAtras()
        self.desapareceAdelante()
        if(index < noticias.count){
            self.textViewPregunta.text = noticias[index]["preguntaTexto"] as! String
            self.cambiarSubTitulo()
            self.botonAdelante.setTitle("Siguiente", for: .normal)
        }
        else {
            self.textViewPregunta.text = "Muchas Gracias, tu evaluación a sido completa exitosamente, presiona Enviar para que podamos recibirla."
            self.botonAdelante.isHidden = false
            self.botonAdelante.setTitle("Enviar", for: .normal)
            self.floatRatingView.isHidden = true
            self.subtitulo.isHidden = true
            self.encabezado.isHidden = true
            
            if(noticias.count < index){
                
                enviar()
            }
            
        }
        
        
        if(valores.count > index){
            
            self.floatRatingView.rating = valores[index]
            
        }
        else{
            valores.insert(self.floatRatingView.rating, at: index - 1)
            self.floatRatingView.rating = 0.0
            
        }
    }
    
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    override func viewWillDisappear(_ animated: Bool) {
    }

}
extension EncuestaGeneralVC:FloatRatingViewDelegate{
    
    public func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    }
    public func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
}


