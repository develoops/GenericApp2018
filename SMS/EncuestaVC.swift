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
        let greyView = UIView()
        greyView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        self.tabla.tableFooterView = greyView
        tabla.separatorStyle = UITableViewCellSeparatorStyle.none
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(guardar))
        

    }
    
    @objc func guardar(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let noticia = noticias[indexPath.row]
        
        cell.labelNombre?.frame = CGRect(x: 18.0, y: 15.0, width: view.frame.size.width - 36.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 36.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = noticia["preguntaTexto"] as? String
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        cell.imagenPerfil.superview?.sendSubview(toBack: cell.imagenPerfil)
        cell.imagenPerfil.image = getImageWithColor(color: UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0), size: cell.imagenPerfil.frame.size)

        cell.imagenPerfil.frame = CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.labelNombre.frame.origin.y + cell.labelNombre.frame.height + 20.0)
       
        cell.floatRatingView.frame = CGRect(x: 20.0, y: cell.imagenPerfil.frame.origin.y + cell.imagenPerfil.frame.height + 10.0, width: cell.frame.width - 40.0, height: 60.0)
      
        tamanoCelda = (cell.labelNombre.frame.size.height + cell.floatRatingView.frame.height) + 55.0
                
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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
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
    
}
