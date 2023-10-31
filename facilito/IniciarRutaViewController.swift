//
//  IniciarRutaViewController.swift
//  facilito
//
//  Created by iMac Mario on 31/10/23.
//



import UIKit
import SwiftyJSON

class IniciarRutaViewController: UIViewController, UITextFieldDelegate {
    var vMapa: GrifosMapaViewController!


    @IBOutlet weak var btnCerrar: UIButton!
    @IBOutlet weak var btnContinuarApp: UIButton!
    @IBOutlet weak var btnGoogleMaps: UIButton!
    @IBOutlet weak var btnWaze: UIButton!
    @IBOutlet weak var vRuta: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinuarApp.roundButton()
        btnGoogleMaps.roundButton()
        btnWaze.roundButton()
        vRuta.roundView()

    }
    
    
    @IBAction func cerrarAlert(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
//Fin clase
}
