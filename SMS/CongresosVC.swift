//
//  DirectivaVC.swift
//  SMS
//
//  Created by Alvaro Moya on 9/26/17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
import SWSegmentedControl

class CongresosVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SWSegmentedControlDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    var tamanoCelda = CGFloat()
    var dateFormatter = DateFormatter()
    var eventosCongreso = [PFObject]()
    @IBOutlet weak var segmentedControl: SWSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self


        let sc = SWSegmentedControl(items: ["Pasados", "Actuales","Próximos"])
        sc.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        sc.frame = CGRect(x: 5.0, y: 64.0, width: view.frame.width - 10.0, height: 44.0)
        sc.delegate = self
        sc.selectedSegmentIndex = 1
        self.view.addSubview(sc)
    
        
        tabla.frame = CGRect(x: 0.0, y: sc.frame.maxY + 5.0, width: view.frame.width, height: view.frame.height - sc.frame.height)
        
        
        let queryEventosCongreso = PFQuery(className: "Actividad")
        queryEventosCongreso.fromLocalDatastore()
        queryEventosCongreso.whereKey("tipo", equalTo: "congreso")
        queryEventosCongreso.includeKey("lugar")
        
        queryEventosCongreso.findObjectsInBackground().continueWith { (task:BFTask<NSArray>) -> Any? in
         
            DispatchQueue.main.async() {
                self.eventosCongreso = task.result as! [PFObject]
                self.tabla.reloadData()
                self.tabla.tableFooterView = UIView()
                
            }
            
            return task.result
        }
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
        
        if (eventos["imgPerfil"] == nil) {
            
            cell.imagenPerfil.image = UIImage(named: "Ponente_ausente_Hombre.png")
        }
        else{
            print(eventos["imgPerfil"])
            
            let file = eventos["imgPerfil"] as? PFFile
            
            file?.getDataInBackground().continueWith{ (task:BFTask<NSData>) -> Any? in
                
                if(task.result != nil){
                    cell.imagenPerfil.image = UIImage(data: task.result! as Data)
                }
                
                
                return task
            }
        }
        cell.imagenPerfil.frame = CGRect(x: 7.5, y: 7.5, width: 63.5, height: 63.5)
        
        
        cell.labelNombre?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + 12.5, y: 7.5, width: view.frame.size.width - 100.0, height:0.0)
        
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.systemFont(ofSize: 15.0)
        cell.labelNombre.text = (eventos["nombre"] as! String)
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        let fechaInicio = eventos["inicio"] as! NSDate
        
        cell.labelLugarPersona?.frame =  CGRect(x: cell.imagenPerfil.frame.maxX + 12.5, y: cell.labelNombre.frame.maxY + 5.0, width: view.frame.size.width - 100.0, height: 0.0)
        
        cell.labelLugarPersona?.text = DateFormatter().formatoDiaMesAnoLargoString(fecha: fechaInicio)
        cell.labelLugarPersona.font = UIFont.systemFont(ofSize: 12.0)
        cell.labelLugarPersona.textAlignment = .left
        cell.labelLugarPersona.numberOfLines = 0
        cell.labelLugarPersona?.sizeToFit()
        
        
        let lugar = eventos["lugar"] as! PFObject
        //let maximumLabelSizeInstitucion = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        //cell.labelInstitucion.sizeThatFits(maximumLabelSizeInstitucion)
        cell.labelInstitucion?.text = lugar["nombre"] as? String
        cell.labelInstitucion?.frame = CGRect(x: cell.imagenPerfil.frame.maxX + 12.5, y: cell.labelLugarPersona.frame.maxY + 5.0, width: view.frame.size.width - 100.0, height: 0.0)
        
        cell.labelInstitucion.font = UIFont.systemFont(ofSize: 12.0)
        cell.labelInstitucion.textAlignment = .left
        cell.labelInstitucion.numberOfLines = 0
        cell.labelInstitucion?.sizeToFit()
        
        tamanoCelda =  cell.labelInstitucion.frame.maxY + 10.0
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navCongreso") as! CongresoNavViewController
        
        vc.congreso = self.eventosCongreso[indexPath.row]
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func segmentedControl(_ control: SWSegmentedControl, willSelectItemAtIndex index: Int) {
        print("will select \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, didSelectItemAtIndex index: Int) {
        print("did select \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, willDeselectItemAtIndex index: Int) {
        print("will deselect \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, didDeselectItemAtIndex index: Int) {
        print("did deselect \(index)")
    }
    
//    func segmentedControl(_ control: SWSegmentedControl, canSelectItemAtIndex index: Int) -> Bool {
//        if index == 1 {
//            return false
//        }
//
//        return true
//    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

