//
//  ReportarPrecioGrifoViewController.swift
//  facilito
//
//  Created by iMac Mario on 31/10/23.
//



import UIKit
import SwiftyJSON
import DropDown

class ReportarPrecioGrifoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var vReporte: UIView!
    @IBOutlet weak var tfPrecio: UIFloatingLabeledTextField!
    
    @IBOutlet weak var btnCombustible: UIButton!
    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    @IBOutlet weak var btnReportar: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var ivArchivo1: UIImageView!
    @IBOutlet weak var ivArchivo2: UIImageView!
    
    var foto1: String = ""
    var foto2: String = ""

    @IBOutlet weak var vImagen1: UIView!
    @IBOutlet weak var vImagen2: UIView!
    
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
 
   
    
    var initialY: CGFloat = 0.0 // Guarda la posición inicial de la vista
    var isViewVisible = true // Controla si la vista está visible o no
    
    
    let dropDown = DropDown()
    let combustible = ["G84","GLP Granel","GNV","Diesel","G REGULAR","G PREMIUM"]
    var nombreCombustible: String = ""
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var archivo1: String = ""
    var archivo2 : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel1.isHidden = true
        btnCancel2.isHidden = true
        vImagen2.isHidden = true
        tfPrecio.styleTextField(textField: tfPrecio)
        tvDescripcion.layer.cornerRadius = 5
        btnReportar.roundButton()
        
        vReporte.bordeSuperior(radius: 24.0)
        // Configurar un gesto de deslizamiento (pan gesture)
             let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
             vReporte.addGestureRecognizer(panGesture)
             
             // Agregar un gesto de toque en el fondo para cerrar la vista
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
             view.addGestureRecognizer(tapGesture)
        
        // Configurar el menú desplegable
        dropDown.anchorView = btnCombustible
        dropDown.dataSource = combustible
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // Establecer el texto del botón con la fuente y tamaño de fuente deseados
            let fontSize: CGFloat = 14
            let font = UIFont(name: "Poppins-Regular", size: fontSize)
            let attributes = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: item, attributes: attributes)
            self.btnCombustible.setAttributedTitle(attributedText, for: .normal)
            
            self.nombreCombustible = combustible[index]
            print(self.nombreCombustible)

        }
    }
    
    @IBAction func mostrarPesos(_ sender: Any) {
        dropDown.show()
    }
        
        
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialY = vReporte.frame.origin.y
    }
    
        
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: vReporte)
        
        switch gesture.state {
        case .began, .changed:
            if translation.y >= 0 { // Solo permitir desplazamiento hacia abajo
                let newY = initialY + translation.y
                if newY >= initialY {
                    vReporte.frame.origin.y = newY
                }
            }
        case .ended:
            let fourthOfHeight = vReporte.frame.size.height / 4.0
            if vReporte.frame.origin.y >= initialY + fourthOfHeight {
                // Ocultar la vista deslizándola hacia abajo
                UIView.animate(withDuration: 0.3) {
                    self.vReporte.frame.origin.y = self.view.frame.size.height
                }
                isViewVisible = false
                self.dismiss(animated: true, completion: nil)
            } else if vReporte.frame.origin.y >= initialY {
                // Mantener la vista en su posición original
                UIView.animate(withDuration: 0.3) {
                    self.vReporte.frame.origin.y = self.initialY
                }
                isViewVisible = true
            }
        default:
            break
        }
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Si se toca fuera de vReporte, ocultar la vista
        if !vReporte.frame.contains(gesture.location(in: view)) {
            UIView.animate(withDuration: 0.3) {
                self.vReporte.frame.origin.y = self.view.frame.size.height
            }
            isViewVisible = false
            self.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func reportarGrifo(_ sender: Any) {
        
        let sector = "6"
        let motivo = "8"
        let asunto = "125"
        let dni = "724038844"
        let descripcionInconformidad = tvDescripcion.text ?? ""
        let coordenada_x = "-76.932584"
        let coordenada_y = "-12.220706"
        let codigoUnidadOperativa = "21024"
        let telefono = "988752221"
        let correo = "Geanz.101910@hotmail.com"
        let nombre = "JEAN"
        let apellidoPaterno = "MATOS"
        let apellidoMaterno = "PALOMINO"

        self.showActivityIndicatorWithText(msg: "Reportando...", true, 200)
        let ac = APICaller()
        ac.PostReportarGrifo(sector: sector, motivo: motivo, asunto: asunto, dni: dni, descripcionInconformidad: descripcionInconformidad, coordenada_x: coordenada_x, coordenada_y: coordenada_y, codigoUnidadOperativa: codigoUnidadOperativa, telefono: telefono, correo: correo, nombre: nombre, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)

                        if (json["registroInconformidadOutRO"]["resultCode"].intValue == 1) {
                            self.performSegue(withIdentifier: "sgPrincipal", sender: self)
                        } else {
                            self.displayMessage = "No se pudo reportar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo reportar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo reportar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo reportar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
        }
    }
    
    
    
    
//Fin clase
}
