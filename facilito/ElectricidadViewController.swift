//
//  ElectricidadViewController.swift
//  facilito
//
//  Created by iMac Mario on 22/02/23.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreLocation
import GoogleMaps


class ElectricidadViewController: UIViewController , CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var btnBack: UIButton!
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
    
    
    @IBOutlet weak var tfDesde: UIFloatingLabeledTextField!
    @IBOutlet weak var tfHasta: UIFloatingLabeledTextField!
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField!


    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    
    @IBOutlet weak var tfNombre: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfDocumento: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfNroDocumento: UIFloatingLabeledTextField!
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfNroSuministro: UIFloatingLabeledTextField!
    
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    @IBOutlet weak var hNombre: NSLayoutConstraint!
    
    @IBOutlet weak var hDocNro: NSLayoutConstraint!
    
    @IBOutlet weak var hSiNo: NSLayoutConstraint!
    
    @IBOutlet weak var svSiNo: UIStackView!
    @IBOutlet weak var swSiNo: UISwitch!
    
    var nombreReporte: String = ""
    let dropDown = DropDown()
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos","Peligro por cables o postes caídos"]
    var isDropDownVisible = false
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var ivArchivo1: UIImageView!
    @IBOutlet weak var ivArchivo2: UIImageView!
    
    var foto1: String = ""
    var foto2: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        
        vLlamar.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnLlamar.roundButton()
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        
        tfDireccion.styleTextField(textField: tfDireccion)
        tfNombre.styleTextField(textField: tfNombre)
        tfDocumento.styleTextField(textField: tfDocumento)
        tfNroDocumento.styleTextField(textField: tfNroDocumento)
        tfDesde.styleTextField(textField: tfDesde)
        tfHasta.styleTextField(textField: tfHasta)
        //tfNroDocumento.styleTextField(textField: tfNroDocumento)
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfNroSuministro.styleTextField(textField: tfNroSuministro)

        
        tvDescripcion.layer.cornerRadius = 5
        btnEnviar.roundButton()

        
        
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
        
        // Configurar las restricciones para el botón, el UITextField y el UIImageView
        /*btnTipoPeligro.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnTipoPeligro.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         */
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
            
            if (self.nombreReporte == "Interrupción de servicio eléctrico"){
                self.performSegue(withIdentifier: "sgInterrupcionE", sender: self)
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
        

        tfDesde.setupDatePicker()
        tfHasta.setupDatePicker()
        //vMenuInferior.addTopBorderWithColor(UIColor.gray, width: 0.5)

        hSiNo.constant = 0
        svSiNo.isHidden = true
        //hcDireccion.constant = 0
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

    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func swSiNo(_ sender: UISwitch) {
        sender.preventRepeatedPresses()
        
        if (!self.swSiNo.isOn) {
            //No
            //hcDireccion.constant = 0

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
            //hcDireccion.constant = 36
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
    @IBAction func cargarImagenButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Seleccionar Imágenes", message: nil, preferredStyle: .actionSheet)
        
        let galeriaAction = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.abrirGaleria()
        }
        
        let camaraAction = UIAlertAction(title: "Cámara", style: .default) { (_) in
            self.abrirCamara()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(galeriaAction)
        alertController.addAction(camaraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func abrirGaleria() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func abrirCamara() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let base64String = imageData.base64EncodedString()
        
        if ivArchivo1.image == nil {
            ivArchivo1.image = selectedImage
            foto1 = base64String
            
        } else {
            ivArchivo2.image = UIImage(data: imageData)
            foto2 = base64String
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgInterrupcionE") {
            let vc = segue.destination as! InterrupcionServicioViewController
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
