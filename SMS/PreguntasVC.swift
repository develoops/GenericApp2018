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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        self.navigationItem.title = "Preguntas Al Expositor"
        
        //self.navigationItem.rightBarButtonItem =
        
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(hacerPregunta))

        let refresh = RefreshData()
        refresh.primerLlamado()
        
        let query = PFQuery(className: "Info")
     //   query.fromLocalDatastore()
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
        
        let noticia = noticias[indexPath.row]
        
        
        cell.labelNombre?.frame = CGRect(x: 18.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = noticia["titulo"] as? String
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
        cell.labelTitulo.text = noticia["subtitulo"] as? String
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 13.0)
        cell.labelTitulo.textColor = UIColor.darkGray
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()
        
        cell.labelHora?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelTitulo.frame.height + 30.0)
        cell.labelHora.frame.size = CGSize(width: self.view.frame.size.width - 40, height: 0.0)
        cell.labelHora.text = noticia["cuerpotxt"] as? String
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()
        
        tamanoCelda = (cell.labelNombre.frame.size.height + cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height) + 60.0
        
        //
        //        if (persona["ImgPerfil"] == nil) {
        //
        //            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        //        }
        //        else{
        //            let im = persona["ImgPerfil"] as? PFFile
        //            im?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
        //                DispatchQueue.main.async {
        //
        //                    cell.imagenPerfil.image = UIImage(data: task.result! as Data)
        //
        //                }
        //            })
        //
        //        }
        //       return cell
        //    }
        
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

        alertController.addAction(cancelAction)
      //  alert.addAction(UIAlertAction(title: i, style: .default, handler: doSomething))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func doSomething(action: UIAlertAction) {
        
        let calificacion = action.title?.characters.count
        let rating = PFObject(className: "Rating")
        rating.setObject(calificacion!, forKey: "calificacion")
     //   rating.setObject(evento, forKey: "evento")
        rating.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
            
            return task
        })
        
        
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
