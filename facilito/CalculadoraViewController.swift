//
//  CalculadoraViewController.swift
//  facilito
//  
//  Created by iMac Mario on 10/01/23.
//

import UIKit
import SwiftyJSON

class CalculadoraViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!

    @IBOutlet weak var tfDias: UIFloatingLabeledTextField!
    @IBOutlet weak var tfCosto: UIFloatingLabeledTextField!
    @IBOutlet weak var btnTerma: UIButton!
    @IBOutlet weak var btnSecadora: UIButton!
    @IBOutlet weak var btnCalcular: UIButton!

    @IBOutlet weak var vReportar: UIView!
    @IBOutlet weak var vTuberia: UIView!
    @IBOutlet weak var vConsultar: UIView!
    @IBOutlet weak var vBeneficio: UIView!
    @IBOutlet weak var vProceso: UIView!
    
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var btnTuberia: UIButton!
    @IBOutlet weak var btnConsultar: UIButton!
    @IBOutlet weak var btnBeneficio: UIButton!
    @IBOutlet weak var btnProceso: UIButton!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    var artefactos: [[String: Int]] = []
    var mostraView1: Int = 0
    var mostraView2: Int = 0
    var mostraView3: Int = 0
    var precioCocina: String = ""
    var precioTerma: Double = 0
    var precioSecadora: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnTerma.roundButton()
        btnSecadora.roundButton()
        btnCalcular.roundButton()
        btnTerma.backgroundColor = UIColor(hex: 0xFED13A)
        btnSecadora.backgroundColor = UIColor(hex: 0xFED13A)

        tfDias.styleTextField(textField: tfDias)
        tfCosto.styleTextField(textField: tfCosto)
        
        vReportar.roundView()
        vTuberia.roundView()
        vConsultar.roundView()
        vBeneficio.roundView()
        vProceso.roundView()
        btnReportar.roundButton()
        btnTuberia.roundButton()
        btnConsultar.roundButton()
        btnBeneficio.roundButton()
        btnProceso.roundButton()
        artefactos.append(["tipoArtefacto": 1])
        tfCosto.delegate = self

        // Implementa el delegado UITextFieldDelegate
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == tfCosto {
                // Limita la longitud a 3 caracteres utilizando una función de cierre
                return (textField.text?.count ?? 0) + string.count <= 3
            }
            return true // Deja que otros campos de texto se comporten normalmente
        }
        
        tfDias.setupIntegerInput()
        tfCosto.setupDecimalInput()

    }
    
    var isButtonTapped = false
    var previousButtonColor: UIColor?

    @IBAction func seleccionarTerma(_ sender: Any) {
        
        if  btnTerma.backgroundColor == UIColor(hex: 0xFED13A) {
            btnTerma.backgroundColor = UIColor(hex: 0x000090)
            artefactos.append(["tipoArtefacto": 2])

        }
        else{
            btnTerma.backgroundColor = UIColor(hex: 0xFED13A)
            if let index = artefactos.firstIndex(where: { $0["tipoArtefacto"] == 2 }) {
                artefactos.remove(at: index)
            }
        }

    }
    
    @IBAction func seleccionarSecadora(_ sender: Any) {
        if  btnSecadora.backgroundColor == UIColor(hex: 0xFED13A) {
            btnSecadora.backgroundColor = UIColor(hex: 0x000090)
            artefactos.append(["tipoArtefacto": 3])

        }
        else{
            btnSecadora.backgroundColor = UIColor(hex: 0xFED13A)
            if let index = artefactos.firstIndex(where: { $0["tipoArtefacto"] == 3 }) {
                artefactos.remove(at: index)
            }
        }
    }
    
    
    @IBAction func calcularAhorro(_ sender: Any) {
        
        if self.tfDias.text == "" || self.tfCosto.text == "" {
            self.displayMessage = "Por favor, ingrese valores válidos para días y precio."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else {
            mostraView1 = 0; mostraView2 = 0; mostraView3 = 0
            let appInvoker = "appInstitucional"
            
            if let dias = self.tfDias.text, let precio = self.tfCosto.text {
                let arrayArtefactos = artefactos
                
                let ac = APICaller()
                self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
                ac.PostCalcularAhorro(appInvoker: appInvoker, dias: dias, precio: precio, arrayArtefactos: arrayArtefactos) { (success, result, code) in
                    self.hideActivityIndicatorWithText()
                    if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON(data: dataFromString)
                            if !json["artefactos"]["artefactos"].arrayValue.isEmpty {
                                let jRecords = json["artefactos"]["artefactos"].arrayValue
                                for artefactoJSON in jRecords {
                                    if let tipoArtefacto = artefactoJSON["tipoArtefacto"].int {
                                        switch tipoArtefacto {
                                        case 1:
                                            self.mostraView1 = 1
                                            if let primerObjetoJSON = jRecords[0].dictionary,
                                               let consumoMensual = primerObjetoJSON["consumoMensual"]?.doubleValue {
                                                let formattedString = String(format: "%.2f", consumoMensual)
                                                self.precioCocina = formattedString
                                                
                                            } else {
                                                print("No se puede acceder al valor 'consumoMensual'.")
                                            }
                                            
                                        case 2:
                                            self.mostraView2 = 2
                                            if let primerObjetoJSON = jRecords[1].dictionary,
                                               let consumoMensual = primerObjetoJSON["consumoMensual"]?.doubleValue {
                                                if primerObjetoJSON["tipoArtefacto"]?.int == 2 {
                                                    
                                                    print(consumoMensual)
                                                    self.precioTerma = consumoMensual
                                                }
                                            } else {
                                                print("No se puede acceder al valor 'consumoMensual'.")
                                            }
                                            
                                        case 3:
                                            self.mostraView3 = 3
                                            if self.mostraView2 == 2 {
                                                if let primerObjetoJSON = jRecords[2].dictionary,
                                                   let consumoMensual = primerObjetoJSON["consumoMensual"]?.doubleValue {
                                                    if primerObjetoJSON["tipoArtefacto"]?.int == 3 {
                                                        print(consumoMensual)
                                                        self.precioSecadora = consumoMensual
                                                    }
                                                    
                                                } else {
                                                    print("No se puede acceder al valor 'consumoMensual'.")
                                                }
                                            }
                                            if self.mostraView2 == 0 {
                                                if let primerObjetoJSON = jRecords[1].dictionary,
                                                   let consumoMensual = primerObjetoJSON["consumoMensual"]?.doubleValue {
                                                    if primerObjetoJSON["tipoArtefacto"]?.int == 3 {
                                                        print(consumoMensual)
                                                        self.precioSecadora = consumoMensual
                                                    }
                                                    
                                                } else {
                                                    print("No se puede acceder al valor 'consumoMensual'.")
                                                }
                                            }
                                        default:
                                            break
                                        }
                                    }
                                }
                                self.performSegue(withIdentifier: "sgCalcular", sender: self)
                                
                            } else {
                                self.displayMessage = json["Mensaje"].stringValue
                                self.performSegue(withIdentifier: "sgDM", sender: self)
                            }
                        } catch {
                            self.displayMessage = "No se pudo calcular, vuelve a intentar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } else {
                        debugPrint("error")
                        self.displayMessage = "No se pudo calcular, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                }
            }
            
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgCalcular") {
            let vc = segue.destination as! CalculadoraResultadoViewController
            //enviar datos del usuario
            vc.vCalculadora = self
        }
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    
    
}

