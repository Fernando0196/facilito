//
//  QRInformacionViewController.swift
//  facilito
//
//  Created by iMac Mario on 25/01/23.
//


import UIKit
import SwiftyJSON

class QRInformacionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var vDatos: UITextView!
    @IBOutlet weak var btnEscanearNuevo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnAceptar.roundButton()
        btnEscanearNuevo.roundButton()
        vDatos.roundView()
    }
    
    

}

