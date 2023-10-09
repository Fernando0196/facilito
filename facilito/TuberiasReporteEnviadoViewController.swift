//
//  TuberiasReporteEnviadoViewController.swift
//  facilito
//
//  Created by iMac Mario on 13/02/23.
//

import UIKit
import SwiftyJSON

class TuberiasReporteEnviadoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnRegresarRedGas: UIButton!
    
    @IBOutlet weak var btnInicio: UIButton!
    
    @IBOutlet weak var vContenedor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegresarRedGas.roundButton()
        btnInicio.roundButton()
        
        //vContenedor.roundView()
        vContenedor.layer.shadowColor = UIColor.gray.cgColor
        vContenedor.layer.shadowOffset = CGSize(width: 0, height: 3)
        vContenedor.layer.shadowRadius = 10
        vContenedor.layer.shadowOpacity = 0.5
        vContenedor.layer.cornerRadius = 8
    }
    
    

}
