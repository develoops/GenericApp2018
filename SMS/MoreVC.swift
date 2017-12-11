//
//  MoreVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 11-12-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class MoreVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var titulos:[String]!
    var imagenes:[UIImage]!
    var vistas:[UIViewController]!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.labelNombre.text = titulos[indexPath.row]
        cell.imagenPerfil.image = imagenes[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        navigationController?.pushViewController(vistas[indexPath.row],
                                                 animated: true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
    }
}
