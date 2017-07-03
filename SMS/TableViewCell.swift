//
//  TableViewCell.swift
//  SMS
//
//  Created by Arturo Sanhueza on 29-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelSpeaker1: UILabel!
    @IBOutlet weak var labelSpeaker2: UILabel!
    @IBOutlet weak var labelSpeaker3: UILabel!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var botonFavorito: UIButton!

    /// ponentes
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelLugarPersona: UILabel!
    @IBOutlet weak var labelInstitucion: UILabel!
    @IBOutlet weak var labelRol: UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
