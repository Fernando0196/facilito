//
//  RegistrarUsuario.swift
//  facilito
//
//  Created by iMac Mario on 7/10/22.
//

import Foundation
import UIKit
import SwiftyJSON
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class RegistrarUsuarioViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tvTitulo: UITextView!
    @IBOutlet weak var btnBackInicio: UIButton!
    
    @IBOutlet weak var btnContinuar: UIButton!
       
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
    @IBOutlet weak var tfRepetirContraseña: UITextField!
    
    var contraVisible: Bool = true

    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tvTitulo.text = "¡Estamos \n muy felices!"
        btnBackInicio.roundButton()
        btnContinuar.roundButton()

        tfCorreo.styleTextField(textField: tfCorreo)
        tfContraseña.styleTextField(textField: tfContraseña)
        //tfRepetirContraseña.styleTextField(textField: tfRepetirContraseña)
        self.tfContraseña.isSecureTextEntry = true
        //self.tfRepetirContraseña.isSecureTextEntry = true

        
    }
    
    
    @IBAction func RegistrarUsuario(_ sender: UIButton) {
         sender.preventRepeatedPresses()
        
        if (!self.isValidEmail(testStr: self.tfCorreo.text!)) {
            self.displayMessage = "Necesitas especificar un correo válido."
            self.performSegue(withIdentifier: "sgDM", sender: self)

        } else if (self.tfContraseña.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar una contraseña."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
        }else if (self.tfContraseña.text!.count < 5) {
            self.displayMessage = "Necesitas especificar una contraseña con más de 5 caracteres.."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
       /* } else if (self.tfRepetirContraseña.text!.isEmpty) {
            self.displayMessage = "Necesitas repetir y especificar la contraseña."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
        }else if (self.tfRepetirContraseña.text! != self.tfContraseña.text! ) {
           self.displayMessage = "Las contraseñas no coinciden."
           self.performSegue(withIdentifier: "sgDM", sender: self)*/
       }
        else {
            self.performSegue(withIdentifier: "sgRegistro2", sender: self)
       }
    }
    
    @IBAction func mostraContra(_ sender: Any) {
        if contraVisible {
            tfContraseña.isSecureTextEntry = false
            contraVisible = false
        }
        else  {
            tfContraseña.isSecureTextEntry = true
            contraVisible = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgRegistro2") {
            let vc = segue.destination as! RegistrarUsuario2ViewController
            vc.vParent = self
        }
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
}
