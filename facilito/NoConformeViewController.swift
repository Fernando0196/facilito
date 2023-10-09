//
//  NoConformeViewController.swift
//  facilito
//
//  Created by iMac Mario on 22/09/23.
//

import UIKit
import SwiftyJSON

class NoConformeViewController: UIViewController, UITextFieldDelegate {
    
    var vTramitesDetalle: TramitesDetalleViewController!


    @IBOutlet weak var vReporte: UIView!
    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    @IBOutlet weak var btnEnviar: UIButton!
    
    
    var initialY: CGFloat = 0.0 // Guarda la posición inicial de la vista
    var isViewVisible = true // Controla si la vista está visible o no

    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var nroInconformidad: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        tvDescripcion.layer.cornerRadius = 5
        btnEnviar.roundButton()
        
        vReporte.bordeSuperior(radius: 24.0)
        // Configurar un gesto de deslizamiento (pan gesture)
             let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
             vReporte.addGestureRecognizer(panGesture)
             
             // Agregar un gesto de toque en el fondo para cerrar la vista
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
             view.addGestureRecognizer(tapGesture)

        self.nroInconformidad = vTramitesDetalle.nroInconformidad
        
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
           
    
  /*  private func reportarPrecio() {
        
        let numeroInconformidad = nroInconformidad
        let conforme = "5"
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostReportarPrecioBalon(nroInconformidad, conforme, completion: { (success, result, code) in
            
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
    */
    
}
