//
//  PeligrosPostesViewController.swift
//  facilito
//
//  Created by iMac Mario on 23/03/23.
//

import Foundation
import UIKit
import DropDown
import SwiftyJSON

class PeligrosPostesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnMenuUsuario: UIButton!
    
    @IBOutlet weak var vLlamar: UIView!
    @IBOutlet weak var vDenunciasReporte: UIView!
    @IBOutlet weak var vCuidados: UIView!
    
    @IBOutlet weak var btnLlamar: UIButton!
    @IBOutlet weak var btnDenuncias: UIButton!
    @IBOutlet weak var btnCuidados: UIButton!
    
    
    @IBOutlet weak var btnLlamarEmpresaE: UIButton!
    @IBOutlet weak var btnDenunciasReportes: UIButton!
    @IBOutlet weak var btnCuidadoConsejos: UIButton!
    
    //COMBO
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var tfTipoReporte: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var btnPeligro: UIButton!
    @IBOutlet weak var tfTipoPeligro: UITextField!
    @IBOutlet weak var ivIconPeligro: UIImageView!
    
    @IBOutlet weak var btnEnviar: UIButton!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    @IBOutlet weak var tdDescripcion: UIFloatingLabeledTextView!
    
    var nombreTipoPeligro: String = ""
    var nombreReporte: String = ""


    let dropDown = DropDown()
    let dropDownPeligros = DropDown()

    let tipoPeligro = ["Cable eléctrico caído o accesibles a las personas","Poste caído o en peligro de caer","Caja portamedidor abierta o sin tapa"]
    
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos","Peligro por postes o cables"]
    
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnEnviar.roundButton()
        
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)

        btnReportar.layer.cornerRadius = 5


        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnReportar.translatesAutoresizingMaskIntoConstraints = false
        btnPeligro.layer.cornerRadius = 5


        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnPeligro.translatesAutoresizingMaskIntoConstraints = false
        
        dropDown.anchorView = btnReportar
        dropDown.dataSource = tiposReporte
        
        dropDownPeligros.anchorView = btnPeligro
        dropDownPeligros.dataSource = tipoPeligro
        
        //Reportes combo
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnReportar.setTitle("" + tiposReporte[index], for: .normal)
            self.nombreReporte = tiposReporte[index]
            print(self.nombreReporte)
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombreReporte, attributes: attributes)
            btnReportar.setAttributedTitle(attributedString, for: .normal)
        }
        
        //Peligro combo
        dropDownPeligros.bottomOffset = CGPoint(x: 0, y: (dropDownPeligros.anchorView?.plainView.bounds.height)!)
        dropDownPeligros.topOffset = CGPoint(x: 0, y: -(dropDownPeligros.anchorView?.plainView.bounds.height)!)
        dropDownPeligros.direction = .bottom
        
        dropDownPeligros.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnPeligro.setTitle("" + tipoPeligro[index], for: .normal)
            //self.tfNombrePeligro.text = tiposPeligo[index]
            self.nombreTipoPeligro = tipoPeligro[index]
            print(self.nombreTipoPeligro)
            //asigna la fuente
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombreTipoPeligro, attributes: attributes)
            btnPeligro.setAttributedTitle(attributedString, for: .normal)
        }
        
        // Configurar el UITextField
        tfTipoReporte.borderStyle = .roundedRect
        tfTipoReporte.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnReportar.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnReportar.centerYAnchor).isActive = true

         
    }

    
    @IBAction func btnEnviar(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        self.performSegue(withIdentifier: "sgEnviar", sender: self)
        
    }
    
    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func mostrarPeligros(_ sender: Any) {
        dropDownPeligros.show()
    }

}

