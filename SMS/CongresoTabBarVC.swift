//
//  CongresoTabBarVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 12-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
class CongresoTabBarVC: UITabBarController,UITabBarControllerDelegate {

    var congreso:PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
    
let storyboard = UIStoryboard(name: "Main", bundle: nil)

    let programaVC = storyboard.instantiateViewController(withIdentifier: "ProgramaVC") as! ProgramaVC
    let speakerVC = storyboard.instantiateViewController(withIdentifier: "SpeakersVC") as! SpeakersVC
    let favsVC = storyboard.instantiateViewController(withIdentifier: "FavoritosVC") as! FavoritosVC
    let moreVC = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        


//        self.viewControllers = [programaVC,speakerVC,favsVC,moreVC]

        if let rootViewController = viewControllers?.first as? ProgramaVC {
            rootViewController.congreso = congreso
            
        }
        if let second = viewControllers?[1] as? SpeakersVC {
            second.congreso = congreso
        }
        
        if let third = viewControllers?[2] as? FavoritosVC {
            third.congreso = congreso
        }
        
        if let cuarto = viewControllers?.last as? MoreVC {
            
            let directorioVC = storyboard.instantiateViewController(withIdentifier: "DirectorioVC") as! DirectorioVC
            let patrocinadoresVC = storyboard.instantiateViewController(withIdentifier: "PatrocinadoresVC") as! PatrocinadoresVC
            let materialesVC = storyboard.instantiateViewController(withIdentifier: "MaterialesVC") as! MaterialesVC
            let noticiasVC = storyboard.instantiateViewController(withIdentifier: "NovedadesVC") as! NovedadesVC
            let encuestaVC = storyboard.instantiateViewController(withIdentifier: "EncuestaGeneralVC") as! EncuestaGeneralVC

            

            
            cuarto.titulos = ["Directorio","Patrocinadores","Materiales","Novedades","Encuesta"]
            cuarto.imagenes = [UIImage(named:"directiva.png")!,UIImage(named:" btn_Patrocinador_.png")!,UIImage(named:"materiales.png")!,UIImage(named:"materiales.png")!,UIImage(named:"EditIcon.png")!]
            cuarto.vistas = [directorioVC,patrocinadoresVC,materialesVC,noticiasVC,encuestaVC]

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
