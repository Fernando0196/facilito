//
//  InicioViewController.swift
//  facilito
//
//  Created by iMac Mario on 4/10/22.
//
import UIKit


class InicioViewController: UIViewController {
    
    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var btnIniciarGoogle: UIButton!
    @IBOutlet weak var btnIniciarFacebook: UIButton!

    @IBOutlet weak var lblRegistrarme: UILabel!
    @IBOutlet weak var lblInvitado: UILabel!
    
    @IBOutlet weak var btnInvitado: UIButton!
    @IBOutlet weak var btnRegistrarme: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnIniciarSesion.roundButton()
        btnIniciarGoogle.roundButton()
        btnIniciarFacebook.roundButton()

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblRegistrarme.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        let attributeString2: NSMutableAttributedString =  NSMutableAttributedString(string: lblInvitado.text ?? "")
        attributeString2.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString2.length))
        lblRegistrarme.attributedText = attributeString
        lblInvitado.attributedText = attributeString2
    }

    @IBAction func btnMostrarInvitado(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgLoadInvitado", sender: self)
        
    }
    
    @IBAction func btnRegistrarme(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgRegistrar1", sender: self)
        
    }
    
    
    
    
}
