       //
//  MapVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 05-07-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class MapVC: UIViewController,UIScrollViewDelegate {

    let scrollView = UIScrollView()
    var nombreMapa:String!
    var nombreSalon:String!
    var mapa:PFFile!


    var imageView = UIImageView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.bounces = true
    scrollView.zoomScale = 2.0
    scrollView.minimumZoomScale = -2.0
    scrollView.maximumZoomScale = 12.0
    
    
        mapa.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
            
            DispatchQueue.main.async {
                
            
            self.imageView = UIImageView(image: UIImage(data:task.result! as Data))
            self.scrollView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + (self.navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)!)
            self.view.addSubview(self.scrollView)
            self.imageView.frame = self.scrollView.frame
            self.scrollView.addSubview(self.imageView)
            }
            return task
        }
    
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
