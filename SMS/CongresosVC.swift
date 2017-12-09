//
//  DirectivaVC.swift
//  SMS
//
//  Created by Alvaro Moya on 9/26/17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class CongresosVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var tamanoCelda = CGFloat()
    var dateFormatter = DateFormatter()
    var eventosCongreso = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame

        let queryEventosCongreso = PFQuery(className: "Actividad")
        queryEventosCongreso.fromLocalDatastore()
        queryEventosCongreso.whereKey("tipo", equalTo: "congreso")
        queryEventosCongreso.includeKey("lugar")
        
        queryEventosCongreso.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            DispatchQueue.main.async() {
            self.eventosCongreso = task.result as! [PFObject]
            self.tabla.reloadData()
                self.tabla.tableFooterView = UIView()

            }
            
            return task.result
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Eventos"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventosCongreso.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let eventos = eventosCongreso[indexPath.row]
        
        
        cell.labelNombre?.frame = CGRect(x: 98.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 17.0)
        cell.labelNombre.text = (eventos["nombre"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        let fechaInicio = eventos["inicio"] as! NSDate
        
        cell.labelLugarPersona?.frame =  CGRect(x: 98.0, y: cell.labelNombre.frame.size.height + 20.0, width: view.frame.size.width - 100.0, height: 0.0)
        
        
        
        cell.labelLugarPersona?.text = DateFormatter().formatoDiaMesAnoLargoString(fecha: fechaInicio)
        cell.labelLugarPersona.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugarPersona.textAlignment = .left
        cell.labelLugarPersona.numberOfLines = 0
        cell.labelLugarPersona?.sizeToFit()
        
        print(cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + cell.labelInstitucion.frame.height)
        
        let lugar = eventos["lugar"] as! PFObject
        //let maximumLabelSizeInstitucion = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        //cell.labelInstitucion.sizeThatFits(maximumLabelSizeInstitucion)
        cell.labelInstitucion?.text = lugar["nombre"] as? String
        cell.labelInstitucion?.frame = CGRect(x: 98.0, y: cell.labelNombre.frame.size.height + cell.labelLugarPersona.frame.size.height + 20.0, width: view.frame.size.width - 100.0, height: 0.0)
        cell.labelInstitucion.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelInstitucion.textAlignment = .left
        cell.labelInstitucion.numberOfLines = 0
        cell.labelInstitucion?.sizeToFit()
        
        tamanoCelda = cell.labelNombre.frame.height + cell.labelLugarPersona.frame.height + cell.labelInstitucion.frame.height + 40.0
        
        if (eventos["imgPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(eventos["imgPerfil"])
            
            let file = eventos["imgPerfil"] as? PFFile
            
            file?.getDataInBackground().continue({ (task:BFTask<NSData>) -> Any? in
                
                if(task.result != nil){
                    cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                }
                
                
                return task
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navCongreso") as! CongresoNavViewController
        
        vc.congreso = self.eventosCongreso[indexPath.row]
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

