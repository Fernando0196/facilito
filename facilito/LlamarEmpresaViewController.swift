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
    @IBOutlet weak var btnEmpresa: UIButton!
    @IBOutlet weak var tfEmpresa: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var nombreEmpresa: String = ""


    let dropDown = DropDown()
    
    let empresas = ["Empresa","Empresa","Empresa","Empresa"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnOsinergmin.roundButton()
        btnElectro.roundButton()
        tfEmpresa.styleTextField(textField: tfEmpresa)
        
        btnMenuUsuario.roundButton()
        vLlamar.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnLlamar.roundButton()
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        
        btnEmpresa.layer.cornerRadius = 5

        
        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnEmpresa.translatesAutoresizingMaskIntoConstraints = false

        dropDown.anchorView = btnEmpresa
        dropDown.dataSource = empresas
        
        //Reportes combo
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnEmpresa.setTitle("" + empresas[index], for: .normal)
            self.nombreEmpresa = empresas[index]
            print(self.nombreEmpresa)
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombreEmpresa, attributes: attributes)
            btnEmpresa.setAttributedTitle(attributedString, for: .normal)
        }
        // Configurar el UITextField
        tfEmpresa.borderStyle = .roundedRect
        tfEmpresa.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnEmpresa.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnEmpresa.centerYAnchor).isActive = true
        
    }
    
    @IBAction func mostrarEmpresas(_ sender: Any) {
        dropDown.show()
    }
    
    
    
}
