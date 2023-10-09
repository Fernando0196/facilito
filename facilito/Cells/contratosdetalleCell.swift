//
//  contratosdetalleCell.swift
//  facilito
//
//  Created by iMac Mario on 24/09/23.
//

import Foundation
import UIKit

class contratosdetalleCell : UITableViewCell {
    
    
    @IBOutlet weak var btnEstado: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var lblFechaInicio: UILabel!
    @IBOutlet weak var lblFechaTermino: UILabel!
    @IBOutlet weak var lblDias: UILabel!
    @IBOutlet weak var lblEmpresaInstaladora: UILabel!
    @IBOutlet weak var lblInstalador: UILabel!
    
    @IBOutlet weak var svEmpresaInstaladora: UIStackView!
    @IBOutlet weak var svInstalador: UIStackView!
    @IBOutlet weak var menuView: UIView!
    
    var idEstado: Int = 0

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        btnEstado.roundButton()
        btnCheck.roundButton()

        
        if idEstado == 1 {
            lblEstado.borderColor = UIColor(hex: 0x009E65)
            lblEstado.textColor = UIColor(hex: 0x009E65)
            lblEstado.roundLabelT()
        }
        if idEstado == 2 {
            lblEstado.borderColor = UIColor(hex: 0xF79400)
            lblEstado.textColor = UIColor(hex: 0xF79400)
            lblEstado.roundLabelT()
        }
        if idEstado == 3 {
            lblEstado.borderColor = UIColor(hex: 0x9E0900)
            lblEstado.textColor = UIColor(hex: 0x9E0900)
            lblEstado.roundLabelT()
        }
        if idEstado == 4 {
            lblEstado.borderColor = UIColor(hex: 0x00789E)
            lblEstado.textColor = UIColor(hex: 0x00789E)
            lblEstado.roundLabelT()
        }
    }
    
    
    
}
