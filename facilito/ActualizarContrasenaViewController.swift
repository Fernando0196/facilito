//
//  ActualizarContrasenaViewController.swift
//  facilito
//
//  Created by iMac Mario on 22/05/23.
//

import UIKit
import SwiftyJSON

class ActualizarContrasenaViewController: UIViewController, UITextFieldDelegate {
    
    var vIniciarSesion: IniciarSesionViewController!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnActualizar: UIButton!
    @IBOutlet weak var tfclave: UIFloatingLabeledTextField!
    @IBOutlet weak var tfnuevaClave: UIFloatingLabeledTextField!
    @IBOutlet weak var tfrepetirClave: UIFloatingLabeledTextField!
    
    
    var contraVisible: Bool = true

    var token: String = ""
    var correo: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnActualizar.roundButton()
        tfclave.styleTextField(textField: tfclave)
        tfnuevaClave.styleTextField(textField: tfnuevaClave)
        tfrepetirClave.styleTextField(textField: tfrepetirClave)
        self.tfnuevaClave.isSecureTextEntry = true
        self.tfrepetirClave.isSecureTextEntry = true

        token = self.vIniciarSesion.jsonUsuario["token"].stringValue
        correo = self.vIniciarSesion.jsonUsuario["correo"].stringValue

    }
    
    @IBAction func mostrarNuevaClave(_ sender: Any) {
        if contraVisible {
            tfnuevaClave.isSecureTextEntry = false
            contraVisible = false
        }
        else  {
            tfnuevaClave.isSecureTextEntry = true
            contraVisible = true
        }
    }
    @IBAction func mostrarRepe(_ sender: Any) {
        if contraVisible {
            tfrepetirClave.isSecureTextEntry = false
            contraVisible = false
        }
        else  {
            tfrepetirClave.isSecureTextEntry = true
            contraVisible = true
        }
    }
    
    
    
    @IBAction func actualizarContrasena(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        if (self.tfclave.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar una contraseña."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else if (self.tfnuevaClave.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar una nueva clave."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else if (self.tfrepetirClave.text!.isEmpty || self.tfrepetirClave.text != self.tfnuevaClave.text ) {
            self.displayMessage = "Repita la nueva contraseña"
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        
        else{
        
        self.showActivityIndicatorWithText(msg: "Actualizando...", true, 200)
        let ac = APICaller()
        ac.PostActualizarContraseña(correo,token,self.tfclave.text!,self.tfnuevaClave.text!,self.tfrepetirClave.text!, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                        if (json["resultCode"].intValue == 1) {
                            self.displayMessage = "La nueva contraseña se ha guardado con éxito."
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                            //self.performSegue(withIdentifier: "sgPrincipal", sender: self)
                            

                        } else {
                            self.displayMessage = json["message"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo validar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo validar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo validar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
     
        })
        }
    }
    
    @IBAction func mostrarPrincipal(_ sender: Any) {
        self.performSegue(withIdentifier: "sgPrincipal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgPrincipal") {
            let vc = segue.destination as! PrincipalViewController
            //enviar datos del usuario
            vc.vIniciarSesion = vIniciarSesion
            //
            
        }

        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.vIniciarSesion = vIniciarSesion

            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    

}
