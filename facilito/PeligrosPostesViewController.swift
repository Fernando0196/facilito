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
import CoreLocation

class PeligrosPostesViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var vObtenerDireccion: ObtenerDireccionViewController!

    var locationManager = CLLocationManager()

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
    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField!

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
    var asuntoValor: String = ""

    

    let dropDown = DropDown()
    let dropDownPeligros = DropDown()

    let tipoPeligro = ["Cable eléctrico caído o accesibles a las personas","Poste caído o en peligro de caer","Caja portamedidor abierta o sin tapa"]
    
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos"]
    
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var ivArchivo1: UIImageView!
    @IBOutlet weak var ivArchivo2: UIImageView!
    @IBOutlet weak var vImagen1: UIView!
    @IBOutlet weak var vImagen2: UIView!
    
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
    var foto1: String = ""
    var foto2: String = ""
    var buscarUbi: Int = 0
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel1.isHidden = true
        btnCancel2.isHidden = true
        vImagen2.isHidden = true
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnEnviar.roundButton()
        vLlamar.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnLlamar.roundButton()
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        
        btnReportar.layer.cornerRadius = 5
        
        
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tfDireccion.styleTextField(textField: tfDireccion)
        btnReportar.layer.cornerRadius = 5
        tdDescripcion.layer.cornerRadius = 5

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
            
            
            if (self.nombreReporte == "Reportar recibo excesivo"){
                self.performSegue(withIdentifier: "sgReciboE", sender: self)
            }

            if (self.nombreReporte == "Daño de artefactos eléctricos"){
                self.performSegue(withIdentifier: "sgDanioE", sender: self)
            }
            if (self.nombreReporte == "Interrupción de servicio eléctrico"){
                self.performSegue(withIdentifier: "sgInterrupcionE", sender: self)
            }
            if (self.nombreReporte == "Reportar alumbrado público"){
                self.performSegue(withIdentifier: "sgReportarAlumbradoE", sender: self)
            }
 
        }
        
        //Peligro combo
        dropDownPeligros.bottomOffset = CGPoint(x: 0, y: (dropDownPeligros.anchorView?.plainView.bounds.height)!)
        dropDownPeligros.topOffset = CGPoint(x: 0, y: -(dropDownPeligros.anchorView?.plainView.bounds.height)!)
        dropDownPeligros.direction = .bottom
        
        
        
        dropDownPeligros.selectionAction = { [unowned self] (index: Int, item: String) in
            let tipoPeligroSeleccionado = tipoPeligro[index]

            if tipoPeligroSeleccionado.contains("Cable eléctrico caído o accesibles a las personas") {
                self.asuntoValor = "52"
            } else if tipoPeligroSeleccionado.contains("Poste caído o en peligro de caer") {
                self.asuntoValor = "53"
            } else if tipoPeligroSeleccionado.contains("Caja portamedidor abierta o sin tapa") {
                self.asuntoValor = "54"
            }
            self.btnPeligro.setTitle("" + tipoPeligro[index], for: .normal)
            //self.tfNombrePeligro.text = tiposPeligo[index]
            self.nombreTipoPeligro = tipoPeligro[index]
            if let customFont = UIFont(name: "Poppins-Regular", size: 12) {
                // Establece la fuente personalizada para tfTipoPeligro
                self.tfTipoPeligro.font = customFont
                // Asigna el texto al campo de texto tfTipoPeligro
                self.tfTipoPeligro.text = item
            }
            
        }
        
        tfTipoReporte.borderStyle = .roundedRect
        tfTipoReporte.translatesAutoresizingMaskIntoConstraints = false
        tfTipoPeligro.borderStyle = .roundedRect
        tfTipoPeligro.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.image = UIImage(named: "down")
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnReportar.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnReportar.centerYAnchor).isActive = true

        ivIconPeligro.image = UIImage(named: "down")
        ivIconPeligro.contentMode = .scaleAspectFit
        ivIconPeligro.translatesAutoresizingMaskIntoConstraints = false
        ivIconPeligro.leadingAnchor.constraint(equalTo: btnPeligro.trailingAnchor, constant: 8).isActive = true
        ivIconPeligro.centerYAnchor.constraint(equalTo: btnPeligro.centerYAnchor).isActive = true

        if let direccionText = self.vObtenerDireccion?.direccion {
            tfDireccion?.text = direccionText
        } else {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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
    
    @IBAction func mostrarPeligros(_ sender: Any) {
        dropDownPeligros.show()
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
            ivArchivo1.contentMode = .scaleAspectFill
            ivArchivo1.clipsToBounds = true
            foto1 = base64String
            
            // Configurar vImagen1 para mostrar la imagen
            vImagen1.isHidden = false
            vImagen2.isHidden = false
            ivArchivo1.isHidden = false
            btnCancel1.isHidden = false
            ivArchivo1.isUserInteractionEnabled = true
            
        } else {
            ivArchivo2.image = UIImage(data: imageData)
            ivArchivo2.contentMode = .scaleAspectFill
            ivArchivo2.clipsToBounds = true
            foto2 = base64String
            
            // Configurar vImagen2 para mostrar la imagen
            vImagen2.isHidden = false
            vImagen1.isHidden = false
            ivArchivo2.isHidden = false
            btnCancel2.isHidden = false
            ivArchivo2.isUserInteractionEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ocultarImagen1(_ sender: Any) {
        ivArchivo1.image = nil
        ivArchivo1.isHidden = true
        btnCancel1.isHidden = true
        foto1 = ""
        ivArchivo1.isUserInteractionEnabled = false
        
        if ivArchivo1.image == nil && ivArchivo2.image == nil {
            vImagen1.isHidden = false
            vImagen2.isHidden = true

        }
    }
    
    @IBAction func ocultarImagen2(_ sender: Any) {
        ivArchivo2.image = nil
        ivArchivo2.isHidden = true
        btnCancel2.isHidden = true
        foto2 = ""
        ivArchivo2.isUserInteractionEnabled = false

        if ivArchivo1.image == nil && ivArchivo2.image == nil {
            vImagen1.isHidden = false
            vImagen2.isHidden = true
        }
    }
    @IBAction func abrirMapa(_ sender: Any) {
        self.buscarUbi = 1
        self.performSegue(withIdentifier: "sgMapa", sender: self)

    }
    
    @IBAction func reportarPostesCables(_ sender: Any) {
        
        let idSector = "2"
        let motivo = "1"
        let asunto = self.asuntoValor
        
        
        
        
        let dni = "724038844" //usuario dni
        
        var afectacion: String? = "1"
        var txtAfectacion = ""
        /*
        if swCazaZona.isOn {
            if let afectacion = afectacion, !afectacion.isEmpty, afectacion != "null" {
                if afectacion == "1" {
                    txtAfectacion = "Solo en mi casa || "
                } else if afectacion == "2" {
                    txtAfectacion = "En toda mi zona ||"
                }
            }
        }
        */
        
        let txtDireccion = tfDireccion.text
        let txtDescripcion = tdDescripcion.text
        let myLongitude = "-76.932584"
        let myLatitude = "-12.220706"
        let codigoEmpConcesionaria = "0"
        guard let txtSuministro = tfSuministro.text, !txtSuministro.isEmpty else {
            displayMessage = "Necesitas ingresar el número de suministro"
            performSegue(withIdentifier: "sgDM", sender: self)
            return
        }
        let telefono = "988752221" //usuario
        let correo = "Geanz.101910@hotmail.com" //usuario
        let txtNombre = "JEAN" //usuario
        let apellidoPaterno = "MATOS" //usuario
        let apellidoMaterno = "PALOMINO" //usuario
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let rangoMeses = ""
                
        let codigoCanalRegistro = "5"
        let listaUAP = ""
        let listaFotos = [foto1, foto2]
        
        guard !idSector.isEmpty else {
            displayMessage = "Necesitas sector"
            performSegue(withIdentifier: "sgDM", sender: self)
            return
        }

        showActivityIndicatorWithText(msg: "Validando...", true, 200)
        
        let ac = APICaller()
        ac.PostReportarInconformidad(idSector: idSector, motivo: motivo, asunto: asunto, dni: dni, descripcionInconformidad: "\(txtAfectacion)\(String(describing: txtDireccion)) || \(String(describing: txtDescripcion))", coordenada_x: myLongitude, coordenada_y: myLatitude, codigoEmpresaEnergia: codigoEmpConcesionaria, nroSuministro: txtSuministro, telefono: telefono, correo: correo, nombre: txtNombre, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno, mesesAfectados: rangoMeses, codigoCanalRegistro: codigoCanalRegistro, listaUAP: listaUAP, listaFotos: listaFotos) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if json["registroInconformidadOutRO"]["resulCode"].int == 1 {
                        self.displayMessage = "Se reportó correctamente."
                    } else {
                        self.displayMessage = "No se pudo reportar"
                    }
                } catch {
                    self.displayMessage = "No se pudo reportar"
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo registrar"
            }
            
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
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
        if (segue.identifier == "sgReciboE") {
            let vc = segue.destination as! ElectricidadViewController
            //vc.vBalonGasMapa = self
            //
        }
        if (segue.identifier == "sgReportarAlumbradoE") {
            let vc = segue.destination as! SeleccionePosteViewController
            //vc.vBalonGasMapa = self
            //
            
        }
        if (segue.identifier == "sgMapa") {
            let vc = segue.destination as! ObtenerDireccionViewController
            vc.vPeligro = self
        }

    }
    

}

