//
//  PreguntasVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 03-11-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse


class PreguntasVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var noticias = [PFObject]()
    var tamanoCelda = CGFloat()
    var evento:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        self.navigationItem.title = "Preguntas Al Expositor"
        
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(hacerPregunta))

        let query = PFQuery(className: "Emision", predicate: NSPredicate(format: "actividad == %@", evento))
        
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            self.noticias = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return task
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let emision = noticias[indexPath.row]
        
        let user = emision["emisor"] as! PFUser
        
        cell.labelNombre?.frame = CGRect(x: 18.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = user.username
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
//        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
//        cell.labelTitulo.text = emision["subtitulo"] as? String
//        cell.labelTitulo.font = UIFont.systemFont(ofSize: 13.0)
//        cell.labelTitulo.textColor = UIColor.darkGray
//        cell.labelTitulo?.textAlignment = .left
//        cell.labelTitulo.numberOfLines = 0
//        cell.labelTitulo?.sizeToFit()
        
        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + 18.0)
        cell.labelTitulo.frame.size = CGSize(width: self.view.frame.size.width - 40, height: 0.0)
        cell.labelTitulo.text = emision["mensajeTexto"] as? String
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        cell.labelHora.isHidden = true
        
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
    
    func hacerPregunta(){
        
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
            pregunta.setObject("Titulo", forKey: "titulo")
            pregunta.setObject("usuario", forKey: "subtitulo")
            pregunta.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                
                let query = PFQuery(className: "Emision", predicate: NSPredicate(format: "actividad == %@", self.evento))
                
                
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
