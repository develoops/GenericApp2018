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

class EncuestaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var noticias = [PFObject]()
    var tamanoCelda = CGFloat()
    var tipoEncuesta:String!
    var evento:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        self.navigationController?.navigationBar.topItem?.title = "Encuesta"
        
        let refresh = RefreshData()
        refresh.primerLlamado()
        
        let query = PFQuery(className: "PreguntaDeEncuesta", predicate:NSPredicate(format: "tipo == %@", tipoEncuesta))
        query.order(byDescending: "posicion")
//        query.fromLocalDatastore()
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
        cell.labelNombre.text = noticia["preguntaTexto"] as? String
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
//        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
//        cell.labelTitulo.text = noticia["objectId"] as? String
//        cell.labelTitulo.font = UIFont.systemFont(ofSize: 13.0)
//        cell.labelTitulo.textColor = UIColor.darkGray
//        cell.labelTitulo?.textAlignment = .left
//        cell.labelTitulo.numberOfLines = 0
//        cell.labelTitulo?.sizeToFit()
//
//        cell.labelHora?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelTitulo.frame.height + 30.0)
//        cell.labelHora.frame.size = CGSize(width: self.view.frame.size.width - 40, height: 0.0)
//        cell.labelHora.text = noticia["preguntaTexto"] as? String
//        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
//        cell.labelHora?.textAlignment = .left
//        cell.labelHora.numberOfLines = 0
//        cell.labelHora?.sizeToFit()
        
        tamanoCelda = (cell.labelNombre.frame.size.height) + 80.0
                
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
}
