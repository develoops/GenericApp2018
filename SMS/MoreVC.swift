//
//  MoreVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 11-12-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class MoreVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var titulos:[String]!
    var imagenes:[UIImage]!
    var vistas:[UIViewController]!
    var congreso:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let directorioVC = storyboard.instantiateViewController(withIdentifier: "DirectorioVC") as! DirectorioVC
        let patrocinadoresVC = storyboard.instantiateViewController(withIdentifier: "PatrocinadoresVC") as! PatrocinadoresVC
        let materialesVC = storyboard.instantiateViewController(withIdentifier: "MaterialesVC") as! MaterialesVC
        let noticiasVC = storyboard.instantiateViewController(withIdentifier: "NovedadesVC") as! NovedadesVC
        let encuestaVC = storyboard.instantiateViewController(withIdentifier: "EncuestaNativaVC") as! EncuestaNativaVC
        
        titulos = ["Auspiciadores","Comité Organizador","Materiales","Novedades","Encuesta"]
     
        imagenes = [UIImage(named:"Patrocinador_azul.png")!,UIImage(named:"Comite_academico.png")!,UIImage(named:"Materiales_Icon.png")!,UIImage(named:"LogoNews.png")!,UIImage(named:"EncuestaIcono.png")!]
        vistas = [patrocinadoresVC,directorioVC,materialesVC,noticiasVC,encuestaVC]

        let visible = congreso["visible"] as! String
        
        if (visible == "sponsor"){
            titulos.removeFirst()
            imagenes.removeFirst()
            vistas.removeFirst()
        }
        else{
            titulos = ["Auspiciadores","Comité Organizador","Materiales","Novedades","Encuesta"]
            
            imagenes = [UIImage(named:"Patrocinador_azul.png")!,UIImage(named:"Comite_academico.png")!,UIImage(named:"Materiales_Icon.png")!,UIImage(named:"LogoNews.png")!,UIImage(named:"EncuestaIcono.png")!]
            vistas = [patrocinadoresVC,directorioVC,materialesVC,noticiasVC,encuestaVC]

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.imagenPerfil.frame.origin.y = 11.0
        cell.imagenPerfil.frame.origin.x = 17.5
        cell.imagenPerfil.frame.size = CGSize(width: 22.5, height: 22.5)
        
        cell.labelNombre.frame.origin = CGPoint(x:cell.imagenPerfil.frame.maxX + 15.0 , y: cell.imagenPerfil.frame.origin.y)
        
        cell.labelNombre.text = titulos[indexPath.row]
        cell.imagenPerfil.image = imagenes[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        navigationController?.pushViewController(vistas[indexPath.row],
                                                 animated: true)
        
        
    }
    
}
