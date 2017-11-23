//
//  RefreshData.swift
//  SMS
//
//  Created by Arturo Sanhueza on 31-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
import Bolts

class RefreshData {

    func primerLlamado(){
        
        let query = PFQuery(className: "Actividad")
        let query2 = PFQuery(className: "ActContAct")
        let query3 = PFQuery(className: "Persona")
        query3.includeKey("ImgPerfil")
        let query4 = PFQuery(className: "PersonaRolAct")
        let query5 = PFQuery(className: "Lugar")
        let query6 = PFQuery(className: "Org")
        let query7 = PFQuery(className: "PersonaRolOrg")
        let query8 = PFQuery(className: "Media")
        
        
        query.limit = 1000
        query2.limit = 1000
        query3.limit = 1000
        query4.limit = 1000
        query5.limit = 1000
        query6.limit = 1000
        query7.limit = 1000
        query8.limit = 1000
        
        let  queryCollections = [query,query2,query3,query4,query5,query6,query7,query8]
        
        let tasks = queryCollections.map{$0.findObjectsInBackground().continue({ (task:BFTask<NSArray>) -> Any? in
            
            
            return task
        })}
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continue({ task -> Any? in
            
            PFObject.pinAll(inBackground: (task.result as! [PFObject])).continue(successBlock: { (i:BFTask<NSNumber>) -> Any? in
                
                
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarAppVC") as! TabBarAppVC
//                    //   if (i.isCompleted){
//                    self.navigationController?.present(vc, animated: true, completion: nil)
//                    // }
//
//                }
                return i
            })
        })
    }
}
