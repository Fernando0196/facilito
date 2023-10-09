//
//  grifosCell.swift
//  facilito
//
//  Created by iMac Mario on 26/04/23.
//


import Foundation
import UIKit
import Cosmos

class grifosCell : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var tituloH: NSLayoutConstraint!

    @IBOutlet weak var km: UILabel!
    @IBOutlet weak var octanos: UILabel!
    @IBOutlet weak var galones: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var btnFavorito: UIButton!
    
    @IBOutlet weak var btnLocalizador: UIButton!
    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    var precioGalon: Double = 0.0

    var precioMay: Double = 0.0
    var precioMen: Double = 0.0

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        titulo.textContainer.lineFragmentPadding = 0
        titulo.textContainerInset = .zero
        titulo.layoutIfNeeded()
        tituloH.constant = self.titulo.contentSize.height

        
        galones.numberOfLines = 0
        galones.lineBreakMode = .byWordWrapping
        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.filledColor = .yellow
        cosmosView.settings.emptyBorderColor = .yellow
        cosmosView.settings.updateOnTouch = true
        

        btnFavorito.roundButton()
        btnLocalizador.roundButton()
        img.roundImagen()

        if (precioGalon == precioMay) {
            galones.backgroundColor = UIColor(hex: 0xFDE0E0)
            galones.roundLabel()
        }
        else if (precioGalon == precioMen) {
            galones.backgroundColor = UIColor(hex: 0xE0FDEA)
            galones.roundLabel()

        }
        else{
            galones.backgroundColor = UIColor(hex: 0xFFEDE0)
            galones.roundLabel()

        }
    }
}
