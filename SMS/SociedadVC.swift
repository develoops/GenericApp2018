//
//  DetalleVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
class SociedadVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var tamanoCelda = CGFloat()
    var nombrePatrocinador:String!
    var direc: String!
    var fon:String!
    var we:String!
    var info:String!
    var imagen:PFFile!
    var sociedad:PFObject!
    
    var arrayInfoPatrocinadores = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        tabla.frame = view.frame

        
        let sociedadQuery =  PFQuery(className:"Org")
        sociedadQuery.getFirstObjectInBackground().continue({ (task:BFTask<PFObject>) -> Any? in
            
            DispatchQueue.main.async {
                
                let imagenContenido = ["imagen",task.result?.value(forKey: "imgPerfil")]
                let nombreContenido = ["Nombre",task.result?.value(forKey: "nombre")]
                let descripcionContenido = ["Descripción",task.result?.value(forKey: "descripcion")]
                let contactoContenido = ["Contacto",task.result?.value(forKey: "telefono")]
                let mailContenido = ["Email",task.result?.value(forKey: "email")]
                let webContenido = ["Sitio web",task.result?.value(forKey: "sitioWeb")]
                let direccionContenido = ["Dirección",task.result?.value(forKey: "direccion")]
                
                self.arrayInfoPatrocinadores.addObjects(from: [imagenContenido,nombreContenido,descripcionContenido,contactoContenido, mailContenido,webContenido,direccionContenido])

               self.tabla.reloadData()
            }
            return task
        })
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInfoPatrocinadores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        let objetoInfo = arrayInfoPatrocinadores.object(at: indexPath.row) as! [AnyObject]
        
        let encabezado = objetoInfo.first as? String
        
        if(encabezado == "imagen"){
            let imagen = objetoInfo.last as? PFFile
            cell.labelTitulo?.isHidden = true
            cell.infoDetallePatrocinador?.isHidden = true
            cell.imagenPerfil.isHidden = false
            imagen?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
                cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                
                return task
                
            })
            cell.imagenPerfil.frame = CGRect(x: (view.frame.size.width - 150.0)/2, y: 10.0, width: 150.0, height: 150.0)
        }
            
        else{
            cell.labelTitulo?.isHidden = false
            cell.infoDetallePatrocinador?.isHidden = false

            //cell.labelTitulo?.textColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
            cell.labelTitulo?.frame = CGRect(x: 25.0, y: 10.0, width: view.frame.size.width - 100.0, height:0.0)
            let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
            cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
            cell.labelTitulo.font = UIFont.boldSystemFont(ofSize: 18.0)
            cell.labelTitulo?.text = objetoInfo.first as? String
            cell.labelTitulo?.textAlignment = .left
            cell.labelTitulo.numberOfLines = 0
            cell.labelTitulo?.sizeToFit()
            
            
            cell.infoDetallePatrocinador.frame = CGRect(x: 21.0, y: cell.labelTitulo.frame.origin.y + cell.labelTitulo.frame.height, width: view.frame.size.width - 40.0, height: 0.0)
            //cell.infoDetallePatrocinador?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            let maximumLabelSizeDetalleInfo = CGSize(width: (self.view.frame.size.width - 76.0), height: 40000.0)
            cell.infoDetallePatrocinador.sizeThatFits(maximumLabelSizeDetalleInfo)
            cell.infoDetallePatrocinador.text = objetoInfo.last as? String
            cell.infoDetallePatrocinador.font = UIFont.systemFont(ofSize: 16.0)
            
            cell.infoDetallePatrocinador?.textAlignment = .left
            cell.infoDetallePatrocinador?.sizeToFit()
            
            cell.imagenPerfil.isHidden = true
            
        }
        
        
        if(encabezado == "imagen"){
            
            tamanoCelda = cell.imagenPerfil.frame.size.height + 40.0
            
            
        }
            
        else{
            tamanoCelda = cell.labelTitulo.frame.height + cell.infoDetallePatrocinador.frame.height + 15.0
        }
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
