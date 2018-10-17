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
        let query4 = PFQuery(className: "PersonaRolAct")
        let query5 = PFQuery(className: "Lugar")
        let query6 = PFQuery(className: "Org")
        let query7 = PFQuery(className: "PersonaRolOrg")
        let query8 = PFQuery(className: "Media")
        let query9 = PFQuery(className: "Info")
        let query10 = PFQuery(className: "Encuesta")
        let query11 = PFQuery(className: "PreguntaDeEncuesta")
        let query12 = PFQuery(className: "MediaPos")


        query.limit = 1000
        query2.limit = 1000
        query3.limit = 1000
        query4.limit = 1000
        query5.limit = 1000
        query6.limit = 1000
        query7.limit = 1000
        query8.limit = 1000
        query9.limit = 1000
        query10.limit = 1000
        query11.limit = 1000
        query12.limit = 1000


        let  queryCollections = [query,query2,query3,query4,query5,query6,query7,query8,query9,query10,query11,query12]
        
        let tasks = queryCollections.map{$0.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            
            return task
        }}
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continueWith{ task -> Any? in
            
            PFObject.pinAll(inBackground: (task.result as! [PFObject])).continueOnSuccessWith(block: { (i:BFTask<NSNumber>) -> Any? in
                
           

//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarAppVC") as! TabBarAppVC
//                    //   if (i.isCompleted){
//                    self.navigationController?.present(vc, animated: true, completion: nil)
//                    // }
//
//                }
                return i
            }
       ) }
    }
}
