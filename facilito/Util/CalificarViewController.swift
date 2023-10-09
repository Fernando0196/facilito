//
//  CalificarViewController.swift
//  facilito
//
//  Created by iMac Mario on 15/09/23.
//

import UIKit
import SwiftyJSON

class CalificarViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var vCalificar: UIView!
    @IBOutlet weak var btnCalificar: UIButton!
    @IBOutlet weak var btnReportar: UIButton!
    
    @IBOutlet weak var btnMuyMalo: UIButton!
    @IBOutlet weak var btnMalo: UIButton!
    @IBOutlet weak var btnNeutro: UIButton!
    @IBOutlet weak var btnBueno: UIButton!
    @IBOutlet weak var btnMuyBueno: UIButton!
    
    
    var initialY: CGFloat = 0.0 // Guarda la posición inicial de la vista
    var isViewVisible = true // Controla si la vista está visible o no
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCalificar.roundButton()
        btnReportar.roundButton()

        vCalificar.bordeSuperior(radius: 24.0)
        // Configurar un gesto de deslizamiento (pan gesture)
             let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        vCalificar.addGestureRecognizer(panGesture)
             
             // Agregar un gesto de toque en el fondo para cerrar la vista
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
             view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialY = vCalificar.frame.origin.y
    }
    
        
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: vCalificar)
        
        switch gesture.state {
        case .began, .changed:
            if translation.y >= 0 { // Solo permitir desplazamiento hacia abajo
                let newY = initialY + translation.y
                if newY >= initialY {
                    vCalificar.frame.origin.y = newY
                }
            }
        case .ended:
            let fourthOfHeight = vCalificar.frame.size.height / 4.0
            if vCalificar.frame.origin.y >= initialY + fourthOfHeight {
                // Ocultar la vista deslizándola hacia abajo
                UIView.animate(withDuration: 0.3) {
                    self.vCalificar.frame.origin.y = self.view.frame.size.height
                }
                isViewVisible = false
                self.dismiss(animated: true, completion: nil)
            } else if vCalificar.frame.origin.y >= initialY {
                // Mantener la vista en su posición original
                UIView.animate(withDuration: 0.3) {
                    self.vCalificar.frame.origin.y = self.initialY
                }
                isViewVisible = true
            }
        default:
            break
        }
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Si se toca fuera de vReporte, ocultar la vista
        if !vCalificar.frame.contains(gesture.location(in: view)) {
            UIView.animate(withDuration: 0.3) {
                self.vCalificar.frame.origin.y = self.view.frame.size.height
            }
            isViewVisible = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func botonPresionado(_ sender: UIButton) {
        // Desactivar todos los botones
        btnMuyMalo.backgroundColor = UIColor.clear
        btnMalo.backgroundColor = UIColor.clear
        btnNeutro.backgroundColor = UIColor.clear
        btnBueno.backgroundColor = UIColor.clear
        btnMuyBueno.backgroundColor = UIColor.clear

        // Activar el botón seleccionado
        sender.backgroundColor = UIColor.red
    }
    
}
