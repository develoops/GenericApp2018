//
//  MaterialesVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 14-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class MaterialesSociedad: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabla: UITableView!
    var congreso:PFObject!
    var lista = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        tabla.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Saludo Sociedad"
        self.navigationController?.tabBarItem.title = "Saludo Sociedad"

        
        let query = PFQuery(className:"Media")
        query.whereKey("info", equalTo: "sociedad")
        query.order(byAscending: "orden")
        query.fromLocalDatastore()
        query.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            self.lista = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return task
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 62.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let media = lista[indexPath.row]
        
        cell.imagenPerfil.frame.origin.y = 10.08
        cell.imagenPerfil.frame.origin.x = 15.0
        cell.imagenPerfil.frame.size = CGSize(width: 33.0, height: 42.42)
        
        cell.labelNombre.frame.origin.x = cell.imagenPerfil.frame.maxX + 15.0
        cell.labelNombre.frame.origin.y = 22.75
        
        cell.labelNombre.text = media["nombre"] as? String
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let media = lista[indexPath.row]

        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleMaterialesVC") as! DetalleMaterialesVC
        
        vc.media = media

        navigationController?.pushViewController(vc,
                                                 animated: true)

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
}
