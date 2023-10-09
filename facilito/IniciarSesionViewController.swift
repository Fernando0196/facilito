//
//  IniciarSesion2ViewController.swift
//  facilito
//
//  Created by iMac Mario on 7/10/22.
//


import UIKit
import SwiftyJSON
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Network


class IniciarSesionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tvTitulo: UITextView!
    @IBOutlet weak var btnBackInicio: UIButton!
    
    @IBOutlet weak var btnContinuar: UIButton!
       
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
  //  @IBOutlet weak var tfRepetirContraseña: UITextField!
    
    var contraVisible: Bool = true
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
   
    var direccionIp: String = ""
    var dispositivo: String = ""

    var jsonUsuario: JSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvTitulo.text = "¡Estamos \n muy felices!"
        
        btnBackInicio.roundButton()
        btnContinuar.roundButton()

        tfCorreo.styleTextField(textField: tfCorreo)
        tfContraseña.styleTextField(textField: tfContraseña)
        self.tfContraseña.isSecureTextEntry = true
      //self.tfContraseña.clearsOnBeginEditing = false
        
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
    

    @IBAction func InciarSesion(_ sender: UIButton) {
         sender.preventRepeatedPresses()

        let device = UIDevice.current
        if let ipAddress = device.getLocalIPv4Address() {
            print("Dirección IP local: \(ipAddress)")
            direccionIp = ipAddress
        } else {
            print("No se pudo obtener la dirección IP local.")
        }
        let deviceInfo = device.getDeviceInfo()
        if !deviceInfo.isEmpty {
            print("Dispositivo: \(deviceInfo)")
            dispositivo = deviceInfo
        } else {
            print("No se pudo obtener la dirección IP local.")
        }
        
        
        if (!self.isValidEmail(testStr: self.tfCorreo.text!)) {
            self.displayMessage = "Necesitas especificar un correo válido."
            self.performSegue(withIdentifier: "sgDM", sender: self)

        } else if (self.tfContraseña.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar una contraseña."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
       /* } else if (self.tfRepetirContraseña.text!.isEmpty) {
            self.displayMessage = "Necesitas repetir y especificar la contraseña."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
        }else if (self.tfRepetirContraseña.text! != self.tfContraseña.text! ) {
           self.displayMessage = "Las contraseñas no coinciden."
           self.performSegue(withIdentifier: "sgDM", sender: self)*/
       }
        else {
        
        
        self.showActivityIndicatorWithText(msg: "Validando...", true, 200)
        let ac = APICaller()
        ac.PostLogin(self.tfCorreo.text!,self.tfContraseña.text!, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if json["loginOutRO"]["logueado"].boolValue == true {
                             self.jsonUsuario = json
                             
                             
                             
                             self.performSegue(withIdentifier: "sgBalonGas", sender: self)
                             
                        } else {
                            self.displayMessage = "No se pudo validar"
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgBalonGas") {
            let vc = segue.destination as! BalonGasMapaViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self
            //
            
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
