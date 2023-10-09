//
//  tramitesCell.swift
//  facilito
//
//  Created by iMac Mario on 28/04/23.
//

import Foundation
import UIKit

class tramitesCell : UITableViewCell {
    
    
    @IBOutlet weak var btnIcono: UIButton!
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var lblMotivo: UILabel!
    @IBOutlet weak var lblFechaHora: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    
    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    @IBOutlet weak var menuView: UIView!

        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnIcono.roundButton()
        
        
        if (lblEstado.text == "Registrado" ) {
            lblEstado.borderColor = UIColor(hex: 0xF79400)
            lblEstado.textColor = UIColor(hex: 0xF79400)
            lblEstado.roundLabelT()
            lblEstado.text = "Registrado"
        }
        if (lblEstado.text == "Cerrado" || lblEstado.text == "Desestimado") {
            lblEstado.borderColor = UIColor(hex: 0x9E0900)
            lblEstado.textColor = UIColor(hex: 0x9E0900)
            lblEstado.roundLabelT()
            lblEstado.text = "Cerrado"

        }
        if (lblEstado.text == "Conforme" || lblEstado.text == "No conforme"  ) {
            lblEstado.borderColor = UIColor(hex: 0x020090)
            lblEstado.textColor = UIColor(hex: 0x020090)
            lblEstado.roundLabelT()
        }
        if (lblEstado.text == "En proceso") {
            lblEstado.borderColor = UIColor(hex: 0x009E65)
            lblEstado.textColor = UIColor(hex: 0x009E65)
            lblEstado.roundLabelT()
        }
    }
    
    
    
    
    
}


