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
    
    var vObtenerDireccion: ObtenerDireccionViewController!

    
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
    @IBOutlet weak var swCazaZona: UISwitch!

    var nombreReporte: String = ""
    let dropDown = DropDown()
    let tiposReporte = ["Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos","Peligro por cables o postes caídos"]
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
    var buscarUbi: Int = 0
    var deberiaActualizarDireccion = true // Estado para controlar si la dirección debe actualizarse
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCancel1.isHidden = true
        btnCancel2.isHidden = true
        vImagen2.isHidden = true
        
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
        
        /*
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        */
        
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

    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func swSiNo(_ sender: UISwitch) {
        sender.preventRepeatedPresses()
        
        if (self.swSiNo.isOn) {
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
        else{
            //No
            //hcDireccion.constant = 0
            //Quitar altura
            hSiNo.constant = 0
            svSiNo.isHidden = true
            self.svSiNo.alpha = 0

            tfDireccion.becomeFirstResponder()
            
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
    
    @IBAction func reportarReciboExcesivo(_ sender: Any) {
        
        let idSector = "2"
        let motivo = "1"
        let asunto = "21"
        let dni = "724038844" //usuario dni
        
        var afectacion: String? = "1"
        var txtAfectacion = ""

        if swCazaZona.isOn {
            if let afectacion = afectacion, !afectacion.isEmpty, afectacion != "null" {
                if afectacion == "1" {
                    txtAfectacion = "Solo en mi casa || "
                } else if afectacion == "2" {
                    txtAfectacion = "En toda mi zona ||"
                }
            }
        }
        
        let txtDireccion = tfDireccion.text
        let txtDescripcion = tvDescripcion.text
        let myLongitude = "-76.932584"
        let myLatitude = "-12.220706"
        let codigoEmpConcesionaria = "0"
        guard let txtSuministro = tfNroSuministro.text, !txtSuministro.isEmpty else {
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

        var rangoMeses = ""
        
        if let fechaInicio = dateFormatter.date(from: tfDesde.text ?? ""),
            let fechaFin = dateFormatter.date(from: tfHasta.text ?? "") {

            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: fechaInicio, to: fechaFin)

            if let mesesAfectados = components.month {
                rangoMeses = "\(mesesAfectados)"
                print("Número de meses afectados: \(rangoMeses)")
            } else {
                print("No se pudo calcular el número de meses.")
            }

        } else {
            print("Formato de fecha incorrecto.")
        }
        
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
        if (segue.identifier == "sgMapa") {
            let vc = segue.destination as! ObtenerDireccionViewController
            vc.vRecibo = self
        }
        
    }

}
