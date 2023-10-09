//
//  NotificacionViewController.swift
//  facilito
//
//  Created by iMac Mario on 13/10/22.
//

import Foundation
import UIKit


class NotificacionViewController: UIViewController {
    
    var vIniciarSesion: IniciarSesionViewController!

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var header: String = ""
    var message: String!
    var handleAccept: (()->())? = nil
    
    var correoExiste: Int = 0
    var vParentRegistro1: RegistrarUsuario2ViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!self.header.isEmpty) {
            self.lblHeader.text = self.header
        }
        self.lblMessage.text = self.message
        if (self.correoExiste == 1){
            self.correoExiste = self.vParentRegistro1.correoExiste
        }

    }

    @IBAction func btnAcceptPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        if (self.correoExiste == 1){
            self.performSegue(withIdentifier: "sgInicio", sender: self)
        }
        
        //
        if (self.lblMessage.text == "La nueva contraseña se ha guardado con éxito."){
            self.performSegue(withIdentifier: "sgPrincipal", sender: self)
        }
        
        else{
            self.dismiss(animated: false, completion: self.handleAccept)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sgInicio") {
            let vc = segue.destination as! InicioViewController
            self.vParentRegistro1.correoExiste = 0
        }
        if (segue.identifier == "sgPrincipal") {
            let vc = segue.destination as! PrincipalViewController
            vc.vIniciarSesion = vIniciarSesion

        }
        
        
    }
    
    
}
