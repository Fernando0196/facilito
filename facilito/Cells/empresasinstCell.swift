//
//  empresasinstCell.swift
//  facilito
//
//  Created by iMac Mario on 6/10/23.
//

import Foundation
import UIKit

class empresasinstCell : UITableViewCell {
    
    
    @IBOutlet weak var lblnombreEmpresaInstaladora: UILabel!
    @IBOutlet weak var lblNroRegistro: UILabel!
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnSeleccionarMenu: UIButton!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnIcon.roundButton()
        
        
    }
    
    
    
    
}
