//
//  ReporteDenunciarViewController.swift
//  facilito
//
//  Created by iMac Mario on 12/05/23.
//

import UIKit
import SwiftyJSON
import DropDown


class ReporteDenunciarViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var vReporte: UIView!
    @IBOutlet weak var btnTipoPeligro: UIButton!
    @IBOutlet weak var tfNombrePeligro: UITextField!
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var ivIcon: UIImageView!

    var nombrePeligro: String = ""
    let dropDown = DropDown()
    let tiposPeligo = ["Fallas y problemas eléctricos","Recibo excesivo de electricidad","Fallas y problemas en la red de gas natural","Recibo excesivo de gas natural"]
    var isDropDownVisible = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.nombrePeligro = "Fallas y problemas eléctricos"
        btnContinuar.roundButton()
        btnTipoPeligro.layer.cornerRadius = 5

        vReporte.layer.shadowColor = UIColor.gray.cgColor
        vReporte.layer.shadowOffset = CGSize(width: 0, height: 3)
        vReporte.layer.shadowRadius = 10
        vReporte.layer.shadowOpacity = 0.5
        vReporte.layer.cornerRadius = 8

        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnTipoPeligro.translatesAutoresizingMaskIntoConstraints = false
       
        dropDown.anchorView = btnTipoPeligro
        dropDown.dataSource = tiposPeligo

        // Configurar el UITextField
        tfNombrePeligro.borderStyle = .roundedRect
        tfNombrePeligro.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar las restricciones para el botón, el UITextField y el UIImageView
        /*btnTipoPeligro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnTipoPeligro.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         */
        ivIcon.leadingAnchor.constraint(equalTo: btnTipoPeligro.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnTipoPeligro.centerYAnchor).isActive = true

        
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnTipoPeligro.setTitle("" + tiposPeligo[index], for: .normal)
            //self.tfNombrePeligro.text = tiposPeligo[index]
            self.nombrePeligro = tiposPeligo[index]
            print(self.nombrePeligro)
            //asigna la fuente
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombrePeligro, attributes: attributes)
            btnTipoPeligro.setAttributedTitle(attributedString, for: .normal)
        }
    }

    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func cambiarVista(_ sender: Any) {
                
        if (self.nombrePeligro == "Fallas y problemas eléctricos"){
            self.performSegue(withIdentifier: "sgFallasProblemasE", sender: self)
        }
        if (self.nombrePeligro == "Recibo excesivo de electricidad"){
            self.performSegue(withIdentifier: "sgReciboExcesivoE", sender: self)
        }
        if (self.nombrePeligro == "Fallas y problemas en la red de gas natural"){
            self.performSegue(withIdentifier: "sgFallasProblemasGN", sender: self)
        }
        if (self.nombrePeligro == "Recibo excesivo de gas natural"){
            self.performSegue(withIdentifier: "sgReciboExcesivoGN", sender: self)
        }

    }
    
    
}
