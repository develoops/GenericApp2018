//
//  MapVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 05-07-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class MapVC: UIViewController,UIScrollViewDelegate {

    let scrollView = UIScrollView()
    var nombreMapa:String!
    var nombreSalon:String!

    var imageView = UIImageView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.bounces = true
    scrollView.zoomScale = 2.0
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 12.0
    
    
    imageView = UIImageView(image: UIImage(named: nombreMapa))
    scrollView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height - (self.navigationController?.navigationBar.frame.height)!)
        view.addSubview(self.scrollView)
    imageView.frame = scrollView.frame
    scrollView.addSubview(imageView)
    
    asignarCoordenadaPin(nombreSalon:nombreSalon)
    }
    
//    func moveImage(view: UIImageView){
//        var toPoint: CGPoint = CGPointMake(0.0, -10.0)
//        var fromPoint : CGPoint = CGPointZero
//        
//        var movement = CABasicAnimation(keyPath: "movement")
//        movement.additive = true
//        movement.fromValue =  NSValue(CGPoint: fromPoint)
//        movement.toValue =  NSValue(CGPoint: toPoint)
//        movement.duration = 0.3
//        
//        view.layer.addAnimation(movement, forKey: "move")
//    }
    
    func pinCoordenada(x:CGFloat,y:CGFloat){
    
        print(x,y)
        let imagenPin = UIImageView(frame: CGRect(x: x, y:y, width: 60.0, height: 63.0))
        imagenPin.image = UIImage(named: "pinilla.png")
        scrollView.addSubview(imagenPin)
    }
    
    func asignarCoordenadaPin(nombreSalon:String){
        
        if(nombreSalon == "Salón Piccadilly y Esmeralda"){
        
            pinCoordenada(x: 195.0, y: 245.0)
        }
       else if(nombreSalon == "Salón Estrella"){
            pinCoordenada(x: 248.0, y: 245.0)
        }
        
       else if(nombreSalon == "Salón Caracola Lobby"){
            pinCoordenada(x: 174.0, y: 245.0)
       }
        else{
            pinCoordenada(x: 100.0, y: 245.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imageView
    }
}
