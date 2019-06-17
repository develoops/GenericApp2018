//
//  SplashVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 26-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse
import Bolts
import GRDB

class SplashVC: UIViewController {
    var personas: [Person]!
    var personsController: FetchedRecordsController<Person>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imagenSplash = UIImageView(frame: self.view.frame)
        imagenSplash.image = UIImage(named: "splashSMS2017")

        // imagenSplash.image = UIImage(named: "LaunchImage")
        view.addSubview(imagenSplash)
    
        let userDefaults = UserDefaults.standard
        let contador = userDefaults.integer(forKey: "contadorInicio")
        self.primerLlamado()

        if(contador == 1){
            self.primerLlamado()
        
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarAppVC") as! TabBarAppVC
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
        

    }

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

        query.limit = 1000
        query2.limit = 1000
        query3.limit = 1000
        query4.limit = 1000
        query5.limit = 1000
        query6.limit = 1000
        query7.limit = 1000
        query8.limit = 1000
        
        let  queryCollections = [query,query2,query3,query4,query5,query6,query7,query8,query9]
        let tasks = queryCollections.map{$0.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            
            return task
        }}
        
        BFTask<AnyObject>(forCompletionOfAllTasksWithResults: tasks as [BFTask<AnyObject>]?).continueWith(block: { task -> Any? in
            PFObject.pinAll(inBackground: (task.result as! [PFObject])).continueOnSuccessWith(block: { (i:BFTask<NSNumber>) -> Any? in
                
DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarAppVC") as! TabBarAppVC
                    self.navigationController?.present(vc, animated: true, completion: nil)                    
                }
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func cargaPersonas() {
//        for _ in 0..<50 {
//            DispatchQueue.global().async {
//                try! dbQueue.inTransaction { db in
//                    if try Person.fetchCount(db) == 0 {
//                        // Insert persons
//                        for _ in 0..<8 {
//                            try Person(nombre: Person.nombreRandom(), edad: Person.edadRandom()).insert(db)
//                        }
//                    } else {
//                        // Insert a person
//                        if arc4random_uniform(2) == 0 {
//                            let person = Person(nombre: Person.nombreRandom(), edad: Person.edadRandom())
//                            try person.insert(db)
//                        }
//                        // Delete a person
//                        if arc4random_uniform(2) == 0 {
//                            if let person = try Person.order(sql: "RANDOM()").fetchOne(db) {
//                                try person.delete(db)
//                            }
//                        }
//                        // Update some persons
//                        for person in try Person.fetchAll(db) {
//                            if arc4random_uniform(2) == 0 {
//                                person.edad = Person.edadRandom()
//                                try person.update(db)
//                            }
//                        }
//                    }
//                    return .commit
//                }
//            }
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
