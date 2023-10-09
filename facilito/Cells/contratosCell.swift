//
//  contratosCell.swift
//  facilito
//
//  Created by iMac Mario on 23/09/23.
//


import Foundation
import UIKit

class contratosCell : UITableViewCell {
    
    @IBOutlet weak var contratosView: UIView!
    
    
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var btnSeleccionarContrato: UIButton!

    @IBOutlet weak var btnIcono: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnIcono.roundButton()

        if (lblEstado.text == "26" ) {
            lblEstado.borderColor = UIColor(hex: 0x9E0900)
            lblEstado.textColor = UIColor(hex: 0x9E0900)
            lblEstado.roundLabelT()
            lblEstado.text = "Cerrado" 
        }

    }
    
    
    
}
