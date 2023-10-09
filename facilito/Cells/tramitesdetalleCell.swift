//
//  tramitesdetalleCell.swift
//  facilito
//
//  Created by iMac Mario on 21/09/23.
//


import Foundation
import UIKit

class tramitesdetalleCell : UITableViewCell {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnNumero: UIButton!
    @IBOutlet weak var btnChek: UIButton!
    @IBOutlet weak var lblProceso: UILabel!
    @IBOutlet weak var lblFechaHora: UILabel!
    @IBOutlet weak var lblDetalle: UILabel!
    
    @IBOutlet weak var btnSeleccionarMenu: UIButton!

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        btnNumero.roundButton()
        btnChek.roundButton()


        if (lblProceso.text == "Registrado" ) {
            lblProceso.borderColor = UIColor(hex: 0xF79400)
            lblProceso.textColor = UIColor(hex: 0xF79400)
            lblProceso.roundLabelT()
        }
        if (lblProceso.text == "Cerrado" || lblProceso.text == "Desestimado" || lblProceso.text == "Desestimada" ) {
            lblProceso.borderColor = UIColor(hex: 0x9E0900)
            lblProceso.textColor = UIColor(hex: 0x9E0900)
            lblProceso.roundLabelT()
        }
        if (self.lblProceso.text == "Conforme" || lblProceso.text == "No Conforme"  ) {
            lblProceso.borderColor = UIColor(hex: 0x020090)
            lblProceso.textColor = UIColor(hex: 0x020090)
            lblProceso.roundLabelT()
        }
        if (lblProceso.text == "En proceso") {
            lblProceso.borderColor = UIColor(hex: 0x009E65)
            lblProceso.textColor = UIColor(hex: 0x009E65)
            lblProceso.roundLabelT()
        }
        
        /*if btnNumero.titleLabel?.text == "1" {
            
            
            
        }*/
        
    }
    
    
    
}
