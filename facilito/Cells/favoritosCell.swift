//
//  favoritosCell.swift
//  facilito
//
//  Created by iMac Mario on 20/07/23.
//

import Foundation
import UIKit
import Cosmos

class favoritosCell : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var km: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    
    @IBOutlet weak var btnFavorito: UIButton!
    @IBOutlet weak var btnLlamar: UIButton!
    @IBOutlet weak var btnSeleccionarFavorito: UIButton!


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnFavorito.roundButton()
        btnLlamar.roundButton()
        //img.roundImagen()
        
        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.filledColor = .yellow
        cosmosView.settings.emptyBorderColor = .yellow
        cosmosView.settings.updateOnTouch = true

        // Agrega CosmosView al contenedor cosmosContainerView


    }
}
