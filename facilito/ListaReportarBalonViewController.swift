//
//  ListaReportarBalonViewController.swift
//  facilito
//
//  Created by iMac Mario on 19/09/23.
//

import UIKit
import SwiftyJSON

class ListaReportarBalonViewController: UIViewController, UITextFieldDelegate {
    
    var vBalonDetalle: ListaBalonDetalleViewController!

    @IBOutlet weak var vReporte: UIView!
    
    @IBOutlet weak var btnReportarPrecio: UIButton!
    @IBOutlet weak var btnReportarEtiqueta: UIButton!
    
    
    
    var initialY: CGFloat = 0.0 // Guarda la posición inicial de la vista
    var isViewVisible = true // Controla si la vista está visible o no
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("El valor de vBalonDetalle es: \(self.vBalonDetalle)")

        vReporte.bordeSuperior(radius: 24.0)
        btnReportarPrecio.titleLabel?.textAlignment = .center
        btnReportarEtiqueta.titleLabel?.textAlignment = .center
        btnReportarPrecio.roundButton()
        btnReportarEtiqueta.roundButton()

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
    
    @IBAction func reportarPrecio(_ sender: Any) {

            self.performSegue(withIdentifier: "sgReportePrecioBalon", sender: self)

    }
    
    @IBAction func reportarEtiqueta(_ sender: Any) {
        self.performSegue(withIdentifier: "sgReportarEtiquetaBalon", sender: self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       /* if (segue.identifier == "sgReportePrecioBalon") {
            let vc = segue.destination as! ReportarPrecioBalonViewController
            vc.vBalonDetalle = self
        }
        if (segue.identifier == "sgReportarEtiquetaBalon") {
            let vc = segue.destination as! ReportarEtiquetaBalonViewController
            vc.vBalonDetalle = self
        }*/
    }
    
}



