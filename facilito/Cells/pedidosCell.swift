//
//  pedidosCell.swift
//  facilito
//
//  Created by iMac Mario on 7/11/23.
//

import Foundation
import UIKit
import Cosmos

class pedidosCell : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var fechaHora: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cosmosContainerView: CosmosView!

    @IBOutlet weak var btnSeleccionarPedido: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
    
    
    
}
