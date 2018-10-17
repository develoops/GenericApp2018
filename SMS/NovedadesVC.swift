//
//  NovedadesVC.swift
//  SMS
//
//  Created by Arturo Sanhueza on 14-10-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class NovedadesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    var noticias = [PFObject]()
    var archivosNoticia = [PFObject]()

    var tamanoCelda = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.frame = view.frame
        self.navigationController?.navigationBar.topItem?.title = "Noticias"
    }
    
override func viewDidAppear(_ animated: Bool) {
        
    
        let refresh = RefreshData()
        refresh.primerLlamado()

        let query = PFQuery(className: "Info")
        query.fromLocalDatastore()
        query.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
            self.noticias = task.result as! [PFObject]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return task
        }
     
//        let queryImagenes = PFQuery(className: "MediaPos")
//        queryImagenes.fromLocalDatastore()
//        queryImagenes.findObjectsInBackground().continueWith{ (task:BFTask<NSArray>) -> Any? in
//            self.archivosNoticia = task.result as! [PFObject]
//            DispatchQueue.main.async {
//                self.tabla.reloadData()
//            }
//            return task
//        }
    
}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //arreglar toda la lógica
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let noticia = noticias[indexPath.row]
        
        
//        var imagenes = [PFObject]()
//
//        for imagen in self.archivosNoticia{
//            if((imagen["noticia"] as! PFObject) == noticia){
//
//                imagenes.append(imagen)
//           }
//        }
        
        cell.labelNombre?.frame = CGRect(x: 18.0, y: 15.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelNombre.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelNombre.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.labelNombre.text = noticia["titulo"] as? String
        cell.labelNombre?.textAlignment = .left
        cell.labelNombre.numberOfLines = 0
        cell.labelNombre?.sizeToFit()
        
        cell.labelTitulo?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y: cell.labelNombre.frame.height + 18.0)
        cell.labelTitulo.text = noticia["subtitulo"] as? String
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 13.0)
        cell.labelTitulo.textColor = UIColor.darkGray
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()

        //// usar elemento de la celda correspondiente
        cell.labelHora?.frame.origin = CGPoint(x:cell.labelNombre.frame.origin.x, y:  cell.labelNombre.frame.height + cell.labelTitulo.frame.height + 30.0)
        cell.labelHora.frame.size = CGSize(width: self.view.frame.size.width - 40, height: 0.0)
        cell.labelHora.text = noticia["cuerpotxt"] as? String
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()

        cell.collectionView.frame = CGRect(x: cell.labelNombre.frame.origin.x, y: cell.labelHora.frame.maxY + 8.0, width: view.frame.size.width - 36.0, height: 110.0)

//        let imagenesReales = uniq(source: imagenes)
//        for objeto in imagenesReales{
//           let archivo = objeto["archivo"] as? PFFile
//            archivo?.getDataInBackground().continueOnSuccessWith(block: { (data:BFTask<NSData>) -> Any? in
//
//                //print(data.result!)
//                let imagen = UIImage(data: data.result! as Data)
//
//                DispatchQueue.main.async {
//
//                    if(cell.imagenes.count < imagenesReales.count){
//                    cell.imagenes.append(imagen!)
//                }
//            }
//
//                return data
//            })
//
//            cell.collectionView.reloadData()
//
//        }
//
//        if imagenes.count == 0{
            self.tamanoCelda = (cell.labelNombre.frame.size.height + cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height ) + 60.0
//        }
//
//        else{
//            self.tamanoCelda = (cell.labelNombre.frame.size.height + cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height + cell.collectionView.frame.size.height) + 60.0
//            }

//        tamanoCelda = (cell.labelNombre.frame.size.height + cell.labelTitulo.frame.size.height + cell.labelHora.frame.size.height + cell.collectionView.frame.size.height) + 60.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tamanoCelda
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noticias.count
        
    }

    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
