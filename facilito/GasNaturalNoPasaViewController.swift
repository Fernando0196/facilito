//
//  GasNaturalNoPasaViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/10/23.
//


import UIKit
import SwiftyJSON

class GasNaturalNoPasaViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var vMensaje: UIView!
    @IBOutlet weak var btnVolver: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMensaje.roundView()
        btnVolver.roundButton()


    }
    
    @IBAction func volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
//Fin clase
}
