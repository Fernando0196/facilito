//
//  IncumplimientoNormasViewController.swift
//  facilito
//
//  Created by iMac Mario on 16/02/23.
//

import UIKit
import SwiftyJSON

class IncumplimientoNormasViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var swSiNo: UISwitch!


    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tdDescripcion: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfNombre: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfDocumento: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfNroDoc: UIFloatingLabeledTextField!
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    @IBOutlet weak var hNombre: NSLayoutConstraint!
    
    @IBOutlet weak var hDocNro: NSLayoutConstraint!
    
    @IBOutlet weak var hSiNo: NSLayoutConstraint!
    
    @IBOutlet weak var svSiNo: UIStackView!
    
    @IBOutlet weak var hcDireccion: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()

        btnEnviar.roundButton()
        tfDireccion.styleTextField(textField: tfDireccion)
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tdDescripcion.styleTextField(textField: tdDescripcion)
        tfNombre.styleTextField(textField: tfNombre)
        tfDocumento.styleTextField(textField: tfDocumento)
        tfNroDoc.styleTextField(textField: tfNroDoc)
        
        hSiNo.constant = 0
        svSiNo.isHidden = true
        hcDireccion.constant = 0
        self.svSiNo.alpha = 0
    }
    
    @IBAction func btnEnviar(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        self.performSegue(withIdentifier: "sgEnviar", sender: self)
        
    }

    @IBAction func swSiNo(_ sender: UISwitch) {
        sender.preventRepeatedPresses()
        
        if (!self.swSiNo.isOn) {
            //No
            hcDireccion.constant = 0

            //Quitar altura
            hSiNo.constant = 0
            svSiNo.isHidden = true
            self.svSiNo.alpha = 0

            tfDireccion.becomeFirstResponder()

        }
        else{
            //Sí
            //Agregar altura
            hSiNo.constant = 161
            svSiNo.isHidden = false
            hcDireccion.constant = 41
            // Animación para mostrar el stackView
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                // Cambia la propiedad alpha del stackView a 1
                self.svSiNo.alpha = 1
            }, completion: { finished in
                // Establece la propiedad isHidden en false cuando la animación haya terminado
                self.svSiNo.isHidden = false
            })
            tfNombre.becomeFirstResponder()

        }
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

