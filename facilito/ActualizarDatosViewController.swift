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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnBack.roundButton()
        btnActualizar.roundButton()
        tfNroDocumento.styleTextField(textField: tfNroDocumento)
        tfNombre.styleTextField(textField: tfNombre)
        tfApellidos.styleTextField(textField: tfApellidos)
        tfCorreo.styleTextField(textField: tfCorreo)
        tfTelefono.styleTextField(textField: tfTelefono)
        
        
        token = self.vIniciarSesion.jsonUsuario["token"].stringValue
        tfNroDocumento.text = self.vIniciarSesion.jsonUsuario["nroDocumento"].stringValue
        tfNombre.text = self.vIniciarSesion.jsonUsuario["nombre"].stringValue
        tfApellidos.text = self.vIniciarSesion.jsonUsuario["apellidos"].stringValue
        tfCorreo.text = self.vIniciarSesion.jsonUsuario["correo"].stringValue
        tfTelefono.text = self.vIniciarSesion.jsonUsuario["telefono"].stringValue

        

    }
    
    
    @IBAction func mostrarPrincipal(_ sender: Any) {
        self.performSegue(withIdentifier: "sgPrincipal", sender: self)
    }
    
    @IBAction func actualizarDatos(_ sender: Any) {
        
        
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
