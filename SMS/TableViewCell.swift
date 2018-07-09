//
//  TableViewCell.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import ReadMoreTextView

class TableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelSpeaker1: UILabel!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var botonFavorito: UIButton!
    @IBOutlet weak var imagenMargen: UIImageView!

    /// ponentes
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelLugarPersona: UILabel!
    @IBOutlet weak var labelInstitucion: UILabel!
    @IBOutlet weak var labelRol: UILabel!
    
    var imagenes = [UIImage]()
    var indicador = Int()
    var posicion = CGPoint()

    @IBOutlet weak var infoDetallePatrocinador:ReadMoreTextView!

    override func awakeFromNib() {
        imagenes = [UIImage(named: "1.jpg"),UIImage(named: "2.jpg"),UIImage(named: "3.jpg"),UIImage(named: "4.jpg")] as! [UIImage]
        super.awakeFromNib()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        collectionCell.imagen.image = imagenes[indexPath.row]
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110.0, height: 110.0)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        self.indicador = indexPath.row
        self.posicion = (collectionView.superview?.superview?.frame.origin)!
        
        let story = UIStoryboard(name: "Main", bundle: nil)
                
        let visor = story.instantiateViewController(withIdentifier: "VisorDeImagenesVC") as! VisorDeImagenesVC
        visor.indicador = indexPath.row
        visor.imagenes = imagenes

        let userDefaults = UserDefaults()
        userDefaults.set(indexPath.row, forKey: "indicadorZoom")
        userDefaults.synchronize()
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let story = UIStoryboard(name: "Main", bundle: nil)

        let visor = story.instantiateViewController(withIdentifier: "VisorDeImagenesVC") as! VisorDeImagenesVC
        visor.imagenes = imagenes
        
      //  (visor ).performSegue(withIdentifier: "Segue", sender: self)

        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
}
    
}


