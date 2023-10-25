//
//  LlamarEmpresaViewController.swift
//  facilito
//
//  Created by iMac Mario on 16/02/23.
//



import UIKit
import SwiftyJSON
import DropDown

class LlamarEmpresaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfEmpresaGas: UIFloatingLabeledTextField!
    @IBOutlet weak var btnOsinergmin: UIButton!
    @IBOutlet weak var btnElectro: UIButton!
    
    @IBOutlet weak var btnMenuUsuario: UIButton!
    
    @IBOutlet weak var vReportes: UIView!
    @IBOutlet weak var vDenunciasReporte: UIView!
    @IBOutlet weak var vCuidados: UIView!
    
    @IBOutlet weak var btnReportes: UIButton!
    @IBOutlet weak var btnDenuncias: UIButton!
    @IBOutlet weak var btnCuidados: UIButton!
    
    
    @IBOutlet weak var btnReportesE: UIButton!
    @IBOutlet weak var btnDenunciasReportes: UIButton!
    @IBOutlet weak var btnCuidadoConsejos: UIButton!
    
    //COMBO
    @IBOutlet weak var btnEmpresa: UIButton!
    @IBOutlet weak var tfEmpresa: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var nombreEmpresa: String = ""
    var numeroEmpesaLLamada: String = ""


    let dropDown = DropDown()
    var empresasElec: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnOsinergmin.roundButton()
        btnElectro.roundButton()
        tfEmpresa.styleTextField(textField: tfEmpresa)
        
        btnMenuUsuario.roundButton()
        vReportes.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        
        btnEmpresa.layer.cornerRadius = 5

        
        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnEmpresa.translatesAutoresizingMaskIntoConstraints = false

        // Configurar el UITextField
        tfEmpresa.borderStyle = .roundedRect
        tfEmpresa.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnEmpresa.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnEmpresa.centerYAnchor).isActive = true
        listarEmpresasElec()
    }
        
    @IBAction func mostrarEmpresas(_ sender: Any) {
        dropDown.show()
    }
    
    var numEmp = [String: String]()

    private func listarEmpresasElec() {

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarEmpresasElec() { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if !json["empresas"].arrayValue.isEmpty {
                            let jRecords = json["empresas"].arrayValue
                            for subJson in jRecords {
                                let nombre = subJson["razonSocial"].stringValue.trimmingCharacters(in: .whitespaces)
                                let numero = subJson["numeroTelefonico"].stringValue
                                
                                // Agrega el nombre de la empresa a empresasElec si aún no está en la lista
                                if !self.empresasElec.contains(nombre) {
                                    self.empresasElec.append(nombre)
                                }
                                
                                // Agrega el nombre de la empresa como clave y el número de teléfono como valor al diccionario numEmp
                                self.numEmp[nombre] = numero
                            }
                            
                            self.dropDown.anchorView = self.btnEmpresa
                            self.dropDown.dataSource = self.empresasElec
                            self.dropDown.bottomOffset = CGPoint(x: 0, y: (self.dropDown.anchorView?.plainView.bounds.height)!)
                            self.dropDown.topOffset = CGPoint(x: 0, y: -(self.dropDown.anchorView?.plainView.bounds.height)!)
                            self.dropDown.direction = .bottom
                            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                self.btnEmpresa.setTitle(self.empresasElec[index] + " ", for: .normal)
                                let selectedNombre = self.empresasElec[index] // Obtiene el nombre de la empresa seleccionada

                                let selectedNumero = self.empresasElec[index]
                                if let selectedNumero = numEmp[selectedNumero] {
                                    self.numeroEmpesaLLamada = selectedNumero
                                    print("Código del distrito seleccionado: \(self.numeroEmpesaLLamada)")
                                }

                                self.btnElectro.setTitle("Llamar al " + self.numeroEmpesaLLamada, for: .normal)
                                
                                let buttonFont = UIFont(name: "Poppins-Regular", size: 12);
                                let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
                                let attributedString = NSAttributedString(string: "Llamar al " + self.numeroEmpesaLLamada, attributes: attributes)
                                let attributedString2 = NSAttributedString(string: selectedNombre, attributes: attributes)
                                btnElectro.setAttributedTitle(attributedString, for: .normal)
                                btnEmpresa.setAttributedTitle(attributedString2, for: .normal)

                                
                            }
                        } else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obtener, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obtener, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obtener, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
        }
    }
    
    @IBAction func mostrarDistritos(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func llamarEmpesaElectrica(_ sender: Any) {
        
        if numeroEmpesaLLamada == "" {
            self.displayMessage = "No se puede realizar la llamada"
            self.performSegue(withIdentifier: "sgDM", sender: self)
            
        }
        
        let numero = self.numeroEmpesaLLamada
        let numero2 = self.numeroEmpesaLLamada

    }
    
    @IBAction func llamarOsinergmin(_ sender: Any) {
    }
    
    
}
