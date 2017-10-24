//
//  MaterialesVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 14-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class MaterialesVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabla: UITableView!
    var congreso:PFObject!
    var lista = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame

        
        let query = PFQuery(className:"Media", predicate: NSPredicate(format: "congreso == %@", congreso))
        query.fromLocalDatastore()
        query.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            self.lista = task.result as! [PFObject]
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
        
        let media = lista[indexPath.row]
        cell.labelNombre.text = media["nombre"] as? String
        
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
