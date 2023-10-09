//
//  InterrupcionServicioViewController.swift
//  facilito
//
//  Created by iMac Mario on 23/02/23.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreLocation
import GoogleMaps

class InterrupcionServicioViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    
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
    
    @IBOutlet weak var btnReportar: UIButton!
    
    @IBOutlet weak var tfTipoReporte: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var swSiNo: UISwitch!
    
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tdDescripcion: UIFloatingLabeledTextView!
    
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var hNombre: NSLayoutConstraint!
    
    @IBOutlet weak var hDocNro: NSLayoutConstraint!
    
    @IBOutlet weak var hSiNo: NSLayoutConstraint!
    
    @IBOutlet weak var svSiNo: UIStackView!
    
    @IBOutlet weak var hcDireccion: NSLayoutConstraint!
    @IBOutlet weak var tfNombre: UIFloatingLabeledTextField!
    @IBOutlet weak var tfDocumento: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfNroDoc: UIFloatingLabeledTextField!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var nombreReporte: String = ""
    let dropDown = DropDown()
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos","Peligro por postes o cables"]
    
    var isDropDownVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        
        vLlamar.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnLlamar.roundButton()
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        
        btnReportar.layer.cornerRadius = 5


        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnReportar.translatesAutoresizingMaskIntoConstraints = false
       
        dropDown.anchorView = btnReportar
        dropDown.dataSource = tiposReporte

        // Configurar el UITextField
        tfTipoReporte.borderStyle = .roundedRect
        tfTipoReporte.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnReportar.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnReportar.centerYAnchor).isActive = true

        
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnReportar.setTitle("" + tiposReporte[index], for: .normal)
            //self.tfNombrePeligro.text = tiposPeligo[index]
            self.nombreReporte = tiposReporte[index]
            print(self.nombreReporte)
            //asigna la fuente
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombreReporte, attributes: attributes)
            btnReportar.setAttributedTitle(attributedString, for: .normal)
            
            
            if (self.nombreReporte == "Reportar recibo excesivo"){
                self.performSegue(withIdentifier: "sgReciboE", sender: self)
            }
            if (self.nombreReporte == "Reportar alumbrado público"){
                self.performSegue(withIdentifier: "sgReportarAlumbradoE", sender: self)
            }
            if (self.nombreReporte == "Daño de artefactos eléctricos"){
                self.performSegue(withIdentifier: "sgDanioE", sender: self)
            }
            if (self.nombreReporte == "Peligro por cables o postes caídos"){
                self.performSegue(withIdentifier: "sgPostesE", sender: self)
            }
        }
        
        
        btnEnviar.roundButton()
        tfDireccion.styleTextField(textField: tfDireccion)
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tdDescripcion.layer.cornerRadius = 5
        
        tfNombre.styleTextField(textField: tfNombre)
        tfDocumento.styleTextField(textField: tfDocumento)
        tfNroDoc.styleTextField(textField: tfNroDoc)
        
        hSiNo.constant = 0
        svSiNo.isHidden = true
        hcDireccion.constant = 0
        self.svSiNo.alpha = 0
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            location.getAddressFromGoogleMaps { address in
                if let address = address {
                    DispatchQueue.main.async {
                        self.tfDireccion.text = address // Asigna la dirección al texto de la caja
                    }
                } else {
                    print("No se pudo obtener la dirección.")
                }
            }
        }
    }

    
    @IBAction func btnEnviar(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        self.performSegue(withIdentifier: "sgEnviar", sender: self)
        
    }
    
    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }

    @IBAction func swSiNo(_ sender: UISwitch) {
        sender.preventRepeatedPresses()
        
        if (!self.swSiNo.isOn) {
            //No
            hcDireccion.constant = 0

            //Quitar altura
            hSiNo.constant = 0
            svSiNo.isHidden = true
            self.svSiNo.alpha = 0

            tfDireccion.becomeFirstResponder()

        }
        else{
            //Sí
            //Agregar altura
            hSiNo.constant = 161
            svSiNo.isHidden = false
            hcDireccion.constant = 36
            // Animación para mostrar el stackView
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                // Cambia la propiedad alpha del stackView a 1
                self.svSiNo.alpha = 1
            }, completion: { finished in
                // Establece la propiedad isHidden en false cuando la animación haya terminado
                self.svSiNo.isHidden = false
            })
            tfNombre.becomeFirstResponder()

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificationViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }*/
        if (segue.identifier == "sgEnviar") {
            let vc = segue.destination as! InterrupcionEnviadoViewController
           // vc.vParent = self
        }
        
        if (segue.identifier == "sgReciboE") {
            let vc = segue.destination as! ElectricidadViewController
            //vc.vBalonGasMapa = self
            //
        }
        if (segue.identifier == "sgDanioE") {
            let vc = segue.destination as! DanoArtefactoViewController
            //vc.vBalonGasMapa = self
            //
        }
        if (segue.identifier == "sgPostesE") {
            let vc = segue.destination as! PeligrosPostesViewController
            //vc.vBalonGasMapa = self
            //
        }
        if (segue.identifier == "sgReportarAlumbradoE") {
            let vc = segue.destination as! SeleccionePosteViewController
            //vc.vBalonGasMapa = self
            //
            
        }
        
    }
    
    
}
