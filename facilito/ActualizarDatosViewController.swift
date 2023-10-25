//
//  ActualizarDatosViewController.swift
//  facilito
//
//  Created by iMac Mario on 22/05/23.
//

import Foundation
import UIKit
import SwiftyJSON

class ActualizarDatosViewController: UIViewController, UITextFieldDelegate {
    
    
    var vIniciarSesion: IniciarSesionViewController!

    
    

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tfNroDocumento: UITextField!
    @IBOutlet weak var tfNombre: UIFloatingLabeledTextField!
    @IBOutlet weak var tfApellidos: UIFloatingLabeledTextField!
    @IBOutlet weak var tfCorreo: UIFloatingLabeledTextField!
    @IBOutlet weak var tfTelefono: UIFloatingLabeledTextField!
    @IBOutlet weak var btnActualizar: UIButton!
    
    var token: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnBack.roundButton()
        btnActualizar.roundButton()
        tfNroDocumento.styleTextField(textField: tfNroDocumento)
        tfNombre.styleTextField(textField: tfNombre)
        tfApellidos.styleTextField(textField: tfApellidos)
        tfCorreo.styleTextField(textField: tfCorreo)
        tfTelefono.styleTextField(textField: tfTelefono)
        
        
       /* token = self.vIniciarSesion.jsonUsuario["token"].stringValue
        tfNroDocumento.text = self.vIniciarSesion.jsonUsuario["nroDocumento"].stringValue
        tfNombre.text = self.vIniciarSesion.jsonUsuario["nombre"].stringValue
        tfApellidos.text = self.vIniciarSesion.jsonUsuario["apellidos"].stringValue
        tfCorreo.text = self.vIniciarSesion.jsonUsuario["correo"].stringValue
        tfTelefono.text = self.vIniciarSesion.jsonUsuario["telefono"].stringValue
*/
        

    }
    
    
    @IBAction func mostrarPrincipal(_ sender: Any) {
        self.performSegue(withIdentifier: "sgPrincipal", sender: self)
    }
    
    @IBAction func actualizarDatos(_ sender: Any) {
        let token = "5559993471c59cca4d4a7fd48d297f5fcf81b59b"
        let correo = "rubefer1901@gmail.com"
        let nombre = "Fernando"
        let apellidos = "Rodas"
        let nroDocumento = "75504709"
        let telefono = "992082427"
        let tipoEdicion = "0"
        
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostEditarPerfil(token: token, correo: correo, nombre: nombre, apellidos: apellidos, nroDocumento: nroDocumento, telefono: telefono, tipoEdicion: tipoEdicion) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if !json["editarUsuarioOutRO"]["message"].stringValue.isEmpty {
                        if json["editarUsuarioOutRO"]["resultCode"].intValue == 1 {
                            self.displayMessage = "Se actualizó correctamente"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                                
                    } else {
                        self.displayMessage = json["Mensaje"].stringValue
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } catch {
                    self.displayMessage = "No se pudo editar, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo editar, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgPrincipal") {
            let vc = segue.destination as! PrincipalViewController
            //enviar datos del usuario
            vc.vIniciarSesion = vIniciarSesion
            //
            
        }

    }
    

}
