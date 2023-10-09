//
//  ReportarEtiquetaBalonViewController.swift
//  facilito
//
//  Created by iMac Mario on 8/09/23.
//

import UIKit
import SwiftyJSON

class ReportarEtiquetaBalonViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var vBalonDetalle: ReportarBalonGasViewController!

    @IBOutlet weak var vReporte: UIView!
    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    @IBOutlet weak var btnReportar: UIButton!
    
    
    
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var ivArchivo1: UIImageView!
    @IBOutlet weak var ivArchivo2: UIImageView!
    
    var initialY: CGFloat = 0.0 // Guarda la posición inicial de la vista
    var isViewVisible = true // Controla si la vista está visible o no
    var foto1: String = ""
    var foto2: String = ""
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    var sector : String = ""
    var motivo : String = ""
    var asunto : String = ""
    var dni : String = ""
    var descripcionInconformidad : String = ""
    var coordenada_x : String = ""
    var coordenada_y: String = ""
    var codigoUnidadOperativa : String = ""
    var telefono : String = ""
    var correo : String = ""
    var nombre : String = ""
    var apellidoPaterno : String = ""
    var apellidoMaterno : String = ""
    var direccion : String = ""
    var archivo1: String = ""
    var archivo2 : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        tvDescripcion.layer.cornerRadius = 5
        btnReportar.roundButton()
        
        vReporte.bordeSuperior(radius: 24.0)
        // Configurar un gesto de deslizamiento (pan gesture)
             let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
             vReporte.addGestureRecognizer(panGesture)
             
             // Agregar un gesto de toque en el fondo para cerrar la vista
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
             view.addGestureRecognizer(tapGesture)

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
            foto1 = base64String
            
        } else {
            ivArchivo2.image = UIImage(data: imageData)
            foto2 = base64String
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportarEtiqueta(_ sender: Any) {
        reportarPrecio()
    }
    
    private func reportarPrecio() {
        
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostReportarPrecioBalon(sector: sector, motivo: motivo, asunto: asunto, dni: dni, descripcionInconformidad: descripcionInconformidad, coordenada_x: coordenada_x, coordenada_y: coordenada_y, codigoUnidadOperativa: codigoUnidadOperativa, telefono: telefono, correo: correo, nombre: nombre, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno, direccion: direccion, archivo1: archivo1, archivo2: archivo2, completion: { (success, result, code) in
            
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if !json["ubigeo"].stringValue.isEmpty {
                             
                             //self.ubigeo = json["ubigeo"].stringValue
                             //self.listarBalonGas()
                             
                         }
                          else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }

        })
    }
    
    
}
