//
//  EscanearQRViewController.swift
//  facilito
//
//  Created by iMac Mario on 25/01/23.
//



import UIKit
import SwiftyJSON

class EscanearQRViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var ivQR: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vMensajeQR: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()
        btnAceptar.roundButton()

        vMensajeQR.layer.shadowColor = UIColor.gray.cgColor
        vMensajeQR.layer.shadowOffset = CGSize(width: 0, height: 3)
        vMensajeQR.layer.shadowRadius = 10
        vMensajeQR.layer.shadowOpacity = 0.5
        vMensajeQR.layer.cornerRadius = 8

        ivQR.alpha = 0.6
    }

}

