//
//  ReciboExcesivoViewController.swift
//  facilito
//
//  Created by iMac Mario on 17/02/23.
//



import UIKit
import SwiftyJSON

class ReciboExcesivoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var swSiNo: UISwitch!

    @IBOutlet weak var swCasaZona: UISwitch!
    
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tdDescripcion: UIFloatingLabeledTextField!
    
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()

        btnEnviar.roundButton()
        tfDireccion.styleTextField(textField: tfDireccion)
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tdDescripcion.styleTextField(textField: tdDescripcion)
    }
    
    @IBAction func btnEnviar(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        self.performSegue(withIdentifier: "sgEnviar", sender: self)
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificationViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }*/
        if (segue.identifier == "sgEnviar") {
            let vc = segue.destination as! IncumplimientoReporteEnviadoViewController
           // vc.vParent = self
        }

        
    }

}
