//
//  TuberiasExpuestasViewController.swift
//  facilito
//
//  Created by iMac Mario on 9/02/23.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreLocation
import GoogleMaps

class TuberiasExpuestasViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var vObtenerDireccion: ObtenerDireccionViewController!

    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var btnBack: UIButton!    
    @IBOutlet weak var tfDireccion: UIFloatingLabeledTextField?
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    @IBOutlet weak var btnEnviar: UIButton!        
    
    @IBOutlet weak var btnMenuUsuario: UIButton!

    @IBOutlet weak var btnTuberia: UIButton!
    @IBOutlet weak var btnConsultar: UIButton!
    @IBOutlet weak var btnBeneficio: UIButton!
    @IBOutlet weak var btnProceso: UIButton!
    @IBOutlet weak var btnCalculadora: UIButton!

    @IBOutlet weak var vTuberia: UIView!
    @IBOutlet weak var vConsultar: UIView!
    @IBOutlet weak var vBeneficio: UIView!
    @IBOutlet weak var vProceso: UIView!
    @IBOutlet weak var vCalculadora: UIView!
    
    @IBOutlet weak var lblReportarTuberia: UILabel!
    @IBOutlet weak var lblIncumplimiento: UILabel!
    
    
    @IBOutlet weak var btnReportar: UIButton!
    
    @IBOutlet weak var tfTipoReporte: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    var nombreReporte: String = ""
    let dropDown = DropDown()
    let tiposReporte = ["Tuberías expuestas en la vía pública", "Incumplimiento de normas técnicas"]
    var isDropDownVisible = false
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var ivArchivo1: UIImageView!
    @IBOutlet weak var ivArchivo2: UIImageView!
    @IBOutlet weak var vImagen1: UIView!
    @IBOutlet weak var vImagen2: UIView!
    
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
    
    var foto1: String = ""
    var foto2: String = ""
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var codeAsunto: Int = 0
    var direccion = ""

    var sector = ""
    var motivo = ""
    var asunto = ""
    var asuntoDescripcion = ""
    var dni = ""
    var descripcionInconformidad = ""
    var coordenada_x = ""
    var coordenada_y = ""
    var nroSuministro = ""
    var telefono = ""
    var correo = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var mesesAfectados = ""
    var codigoCanalRegistro = ""
    var listaUAP = ""
    //var listaFotos: [String] = []
    var nombreEmpresa = ""
    var listaFotos: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel1.isHidden = true
        btnCancel2.isHidden = true
        vImagen2.isHidden = true
        
        lblIncumplimiento.isHidden = true
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnEnviar.roundButton()
        tfDireccion!.styleTextField(textField: tfDireccion!)
        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tvDescripcion.layer.cornerRadius = 5
        
        btnTuberia.roundButton()
        btnConsultar.roundButton()
        btnBeneficio.roundButton()
        btnProceso.roundButton()
        btnCalculadora.roundButton()
        
        vTuberia.roundView()
        vConsultar.roundView()
        vBeneficio.roundView()
        vProceso.roundView()
        vCalculadora.roundView()
        
        btnReportar.layer.cornerRadius = 5
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
            
            if (self.nombreReporte == "Incumplimiento de normas técnicas"){
                lblReportarTuberia.isHidden = true
                lblIncumplimiento.isHidden = false
                codeAsunto = 88
            }
            if (self.nombreReporte == "Tuberías expuestas en la vía pública"){
                lblReportarTuberia.isHidden = false
                lblIncumplimiento.isHidden = true
                codeAsunto = 32

                
            }

        }

        
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
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            print("Latitud: \(latitude)")
            print("Longitud: \(longitude)")

            location.getAddressFromGoogleMaps { address in
                if let address = address {
                    DispatchQueue.main.async {
                        self.tfDireccion!.text = address // Asigna la dirección al texto de la caja
                    }
                } else {
                    print("No se pudo obtener la dirección.")
                }
            }
        }
    }
    
    @IBAction func mostrarReportes(_ sender: Any) {
            dropDown.show()

    }
    
    @IBAction func btnEnviar(_ sender: UIButton) {
        sender.preventRepeatedPresses()

        self.performSegue(withIdentifier: "sgEnviar", sender: self)
        
    }
    

    @IBAction func abrirMapa(_ sender: Any) {
        self.performSegue(withIdentifier: "sgMapa", sender: self)

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
        ivArchivo1.image = nil // Borra la imagen de ivArchivo1
        ivArchivo1.isHidden = true // Oculta ivArchivo1
        btnCancel1.isHidden = true // Oculta btnCancel1
        foto1 = "" // También puedes eliminar la referencia a la foto si es necesario
        ivArchivo1.isUserInteractionEnabled = false
        // Verificar si ivArchivo2 también está oculto
        if ivArchivo1.image == nil && ivArchivo2.image == nil {
            vImagen1.isHidden = false
            vImagen2.isHidden = true

        }
    }
    
    @IBAction func ocultarImagen2(_ sender: Any) {
        ivArchivo2.image = nil // Borra la imagen de ivArchivo2
        ivArchivo2.isHidden = true // Oculta ivArchivo2
        btnCancel2.isHidden = true // Oculta btnCancel2
        foto2 = "" // También puedes eliminar la referencia a la foto si es necesario
        ivArchivo2.isUserInteractionEnabled = false

        // Verificar si ivArchivo1 también está oculto
        if ivArchivo1.image == nil && ivArchivo2.image == nil {
            vImagen1.isHidden = false
            vImagen2.isHidden = true
        }
    }
    
    
    
    @IBAction func enviarReporte(_ sender: Any) {
        /*
        let sector = "4"
        let motivo = "7"
        let asunto = String(codeAsunto)
        let dni = "45678415" //usuario
        let descripcionInconformidad = tvDescripcion.text ?? ""
        let coordenada_x = "-77.019273"
        let coordenada_y = "-12.061642"
        let nroSuministro = tfSuministro.text ?? ""
        let telefono = "999999999" //usuario
        let correo = "framos@gmail.com" //usuario
        let nombre = "Fabiola" //usuario
        let apellidoPaterno = "Sandoval" //usuario
        let apellidoMaterno = "-" //usuario
        let mesesAfectados = ""
        let codigoCanalRegistro = "5"
        let listaUAP = ""
        let listaFotos = [String]()
        let nombreEmpresa = "Calidad S.A"
        */
        
        sector = "4"
        motivo = "7"
        asunto = "32"
        dni = "45678415"
        coordenada_x = "-77.019273"
        coordenada_y = "-12.061642"
        // let codigoEmpresaEnergia = "482"
        nroSuministro = ""
        telefono = "999999999"
        correo = "framos@gmail.com"
        nombre = "Fabiola"
        apellidoPaterno = "Sandoval"
        apellidoMaterno = "-"
        mesesAfectados = ""
        codigoCanalRegistro = "5"
        listaUAP = ""
        if asunto == "32"{
            asuntoDescripcion = "Reportar tuberías expuestas"
        }
        if asunto == "88"{
            asuntoDescripcion = "Incumplimiento de normas técnicas"
        }
        direccion = (tfDireccion?.text)!
        nombreEmpresa = "Cálidda S.A"
        descripcionInconformidad = "TUBERÍA MAL"
        if !foto1.isEmpty {
            listaFotos.append(foto1)
        } else if !foto2.isEmpty {
            listaFotos.append(foto2)
        }
        
        // Check your condition here
        if descripcionInconformidad == "" {
            self.displayMessage = "Por favor, ingrese una descripción."
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        else {

            self.performSegue(withIdentifier: "sgPrevioReporte", sender: self)

        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
        if (segue.identifier == "sgEnviar") {
            let vc = segue.destination as! TuberiasReporteEnviadoViewController
           // vc.vParent = self
        }
        if (segue.identifier == "sgMapa") {
            let vc = segue.destination as! ObtenerDireccionViewController
           // vc.vParent = self
        }
        if (segue.identifier == "sgPrevioReporte") {
            let vc = segue.destination as! PrevioReporteViewController
            vc.vParent = self
        }
    }
    
    
}
