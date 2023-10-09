//
//  PeligroPostesEnviadoViewController.swift
//  facilito
//
//  Created by iMac Mario on 23/03/23.
//

import UIKit
import SwiftyJSON

class PeligroPostesEnviadoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnRegresar: UIButton!

    
    
    @IBOutlet weak var btnInicio: UIButton!
    
    @IBOutlet weak var vContenedor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegresar.roundButton()
        btnInicio.roundButton()
        
        //vContenedor.roundView()
        vContenedor.layer.shadowColor = UIColor.gray.cgColor
        vContenedor.layer.shadowOffset = CGSize(width: 0, height: 3)
        vContenedor.layer.shadowRadius = 10
        vContenedor.layer.shadowOpacity = 0.5
        vContenedor.layer.cornerRadius = 8
    }
    
    

}
