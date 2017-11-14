//
//  PreguntasVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 03-11-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://smsdemo.back4app.io")

class PreguntasVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var noticias = [PFObject]()
    var tamanoCelda = CGFloat()
    var evento:PFObject!
    private var subscription: Subscription<PFObject>!
    var ids = [String]()
    let defaults = UserDefaults.standard

    func alert(message: NSString, title: NSString) -> Void {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        self.navigationItem.title = "Preguntas Al Expositor"
        if(defaults.stringArray(forKey: "likeIds") == nil){
            
            ids = []
        }
        else{
        ids = defaults.stringArray(forKey: "likeIds")!
        }
        
        let contador = defaults.integer(forKey: "contadorPreguntas")
        defaults.set(contador + 1, forKey: "contadorPreguntas")
        defaults.synchronize()
        print(defaults.integer(forKey: "contadorPreguntas"))
        if (defaults.integer(forKey: "contadorPreguntas") == 1) {
        
            let user = PFUser.current()
            user?.acl?.getPublicWriteAccess = true
            let alertController = UIAlertController(title: "Hola", message: "Ingresa tu nombre, para facilitar tu reconocimiento", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.placeholder = "Escribe tu nombre"
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                
                let anonimo = "anon" + String(arc4random())
                user?.setValue(anonimo, forKey: "nombre")
                user?.saveInBackground()
                DispatchQueue.main.async {
                    self.tabla.reloadData()
            }
        }
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                
                user?.setValue(alertController.textFields?.first?.text, forKey: "nombre")
                user?.saveInBackground()
                        DispatchQueue.main.async {
                            self.tabla.reloadData()
                        }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            let msgQuery = PFQuery(className: "Emision", predicate: NSPredicate(format: "actividad == %@", evento))
            msgQuery.includeKey("emisor")

            subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in

                self.datosAVista()
                
        }
        
        self.datosAVista()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(hacerPregunta))
    }

    func datosAVista(){
        let query = PFQuery(className: "Emision", predicate: NSPredicate(format: "actividad == %@", evento))
        query.order(byDescending: "likes")
        query.includeKey("emisor")
        
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            self.noticias = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
                self.scrollToLastRow()
            }
            return task
        })
    }
    
    func scrollToLastRow() {
        
        if(self.noticias.count != 0){
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.tabla.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let emision = noticias[indexPath.row]
        
        let user = emision["emisor"] as! PFUser
        
        var like = emision["likes"] as? Int
        if(like == nil){
            
            like = 0
        }
        
        cell.labelNombre?.frame = CGRect(x: 18.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = user["nombre"] as? String
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        

        
        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + 18.0)
        cell.labelTitulo.frame.size = CGSize(width: self.view.frame.size.width - 40, height: 0.0)
        cell.labelTitulo.text = emision["mensajeTexto"] as? String
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        cell.botonFavorito.center.x = cell.frame.size.width - 35.0
        cell.botonFavorito.tag = indexPath.row
        cell.botonFavorito.addTarget(self, action: #selector(darLike), for: .touchUpInside)
        
        cell.labelHora?.frame.origin = CGPoint(x:cell.botonFavorito.frame.origin.x, y: cell.botonFavorito.frame.height + 24.0)
        cell.labelHora.frame.size = CGSize(width: 60.0, height: 0.0)

        cell.labelHora.text = String(like!)
        cell.labelHora.font = UIFont.systemFont(ofSize: 13.0)
        cell.labelHora.textColor = UIColor.darkGray
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()

        if(ids.containss(obj: emision.objectId!)){
        cell.botonFavorito.setImage(UIImage(named: "btn_Favorito_marcado"), for: .normal)
        }
        else{
            cell.botonFavorito.setImage(UIImage(named: "Btn_favoritos_SinMarcar"), for: .normal)
        }
    
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4
        
        tamanoCelda = (cell.labelNombre.frame.size.height + cell.labelTitulo.frame.size.height) + 60.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noticias.count
    }
    
    @objc func darLike(sender: UIButton!){

    let emision = self.noticias[sender.tag]
    var likesNumber = emision["likes"] as? Int

        if(likesNumber == nil){
            
            likesNumber = 0
        }
        if !(ids.containss(obj: emision.objectId!)){
            ids.append(emision.objectId!)
            sender.setImage(UIImage(named: "btn_Favorito_marcado"), for: .normal)
            emision.setObject(likesNumber! + 1, forKey: "likes")
        }
        else{
            if let index = ids.index(of:emision.objectId!) {
                ids.remove(at: index)
            }
            emision.setObject(likesNumber! - 1, forKey: "likes")
            sender.setImage(UIImage(named: "Btn_favoritos_SinMarcar"), for: .normal)
}
        defaults.set(ids, forKey: "likeIds")
        defaults.synchronize()
        emision.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
            DispatchQueue.main.async {
                self.datosAVista()
            }
            return task
        })

    }

    
    @objc func hacerPregunta(){
        
        let alertController = UIAlertController(title: "Pregunta", message: "¿Qué deseas preguntar?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Escribe tu pregunta"
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            
            let pregunta = PFObject(className: "Emision")
            pregunta.setObject(self.evento, forKey: "actividad")
            pregunta.setObject(PFUser.current() as Any, forKey: "emisor")
            pregunta.setObject(alertController.textFields?.first?.text as Any, forKey: "mensajeTexto")
            pregunta.acl?.getPublicWriteAccess = true
            pregunta.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                let query = PFQuery(className: "Emision", predicate: NSPredicate(format: "actividad == %@", self.evento))
                query.order(byDescending: "likes")
                query.includeKey("emisor")
                
                return query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
                    self.noticias = task.result as! [PFObject]
                    DispatchQueue.main.async {
                        self.tabla.reloadData()
                    }
                    return task
                })
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
