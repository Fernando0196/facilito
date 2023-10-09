//
//  RegistrarUsuario2ViewController.swift
//  facilito
//
//  Created by iMac Mario on 7/10/22.
//

import Foundation
import UIKit
import DropDown
import SwiftyJSON

//SEGUNDO PASO DEL REGISTRO
class RegistrarUsuario2ViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var swTerminos: UISwitch!
    @IBOutlet weak var btnRegistrarme: UIButton!
    
    @IBOutlet weak var tfNroDocumento: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellidos: UITextField!
    
    @IBOutlet weak var vwDropDown: UIButton!
    @IBOutlet weak var lblTitle: UITextField!

    var nombreDocumento: String = ""
    var correoExiste: Int = 0

    let dropDown = DropDown()
    let documentos = ["DNI","CARNET"]
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var vParent: RegistrarUsuarioViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegistrarme.roundButton()
        btnBack.roundButton()
        tfNroDocumento.styleTextField(textField: tfNroDocumento)
        tfNombre.styleTextField(textField: tfNombre)
        tfApellidos.styleTextField(textField: tfApellidos)
        
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = documentos
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.vwDropDown.setTitle("   " + documentos[index], for: .normal)
            self.nombreDocumento = documentos[index]
            print(self.nombreDocumento)
            vwDropDown.titleLabel?.font =  UIFont(name: "Poppins-Regular", size: 14)


            
        }
        
    }
    
    @IBAction func mostrarDocumentos(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func RegistrarUsuario(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        if (self.tfNroDocumento.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar un número de documento."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else if (self.tfNombre.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar un nombre."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else if (self.tfApellidos.text!.isEmpty) {
            self.displayMessage = "Necesitas especificar sus apellidos."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else if (!self.swTerminos.isOn) {
            self.displayMessage = "Debes aceptar los términos y condiciones."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else {
        
        self.showActivityIndicatorWithText(msg: "Registrando...", true, 200)
        let ac = APICaller()
        ac.PostRegistrarUsuario(self.tfNombre.text!,self.tfApellidos.text!,self.vParent.tfCorreo.text!,self.vParent.tfContraseña.text!,completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                        if (json["crearUsuarioOutRO"]["resultCode"].intValue == 1) {
                            self.performSegue(withIdentifier: "sgPrincipal", sender: self)

                        } else {
                            self.displayMessage = json["crearUsuarioOutRO"]["message"].stringValue
                            self.correoExiste = 1
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
        if (segue.identifier == "sgPrincipal") {
            let vc = segue.destination as! PrincipalViewController
            vc.vParentRegistro = self
        }
        /*if (segue.identifier == "sgInicio") {
            let vc = segue.destination as! InicioViewController
            //vc.correoExiste = self.correoExiste
        }*/
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
            vc.correoExiste = self.correoExiste
            vc.vParentRegistro1 = self

        }
    }


    
}
