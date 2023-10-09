//
//  GrifoViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/05/23.
//
//GRIFO SELECCIONADO

import UIKit
import SwiftyJSON
import Cosmos


class GrifoViewController: UIViewController, UITextFieldDelegate {
    
    var vGrifos: GrifosViewController!

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vFondo: UIView!
    @IBOutlet weak var ivFondo: UIImageView!
    
    @IBOutlet weak var ivLogoGrifo: UIImageView!
    
    @IBOutlet weak var btnPrecio: UIButton!
    @IBOutlet weak var brnCalificaciones: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    
    
    @IBOutlet weak var svPrecio: UIStackView!
    @IBOutlet weak var svCalificaciones: UIStackView!
    @IBOutlet weak var svInfoHorarios: UIStackView!

    @IBOutlet weak var btnIrGrifo: UIButton!
    @IBOutlet weak var btnCalificar: UIButton!
    
    @IBOutlet weak var tvTitulo: UITextView!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    @IBOutlet weak var lbDireccion: UILabel!
    
    @IBOutlet weak var btnFavorito: UIButton!
    
    @IBOutlet weak var tituloH: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnInformacion: UIButton!
    @IBOutlet weak var vInformacion: UIView!
    
    @IBOutlet weak var vPrecioPublicado: UIView!
    @IBOutlet weak var vSombra: UIView!
    @IBOutlet weak var btnPrecioPublicado: UIButton!
    
    @IBOutlet weak var svPrecioPublicado: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnBack.roundButton()
        btnIrGrifo.roundButton()
        btnCalificar.roundButton()
        vFondo.roundView()
        ivFondo.roundImagenFondoGrifo()
        ivLogoGrifo.roundImagenLogo()
        btnPrecio.roundButton()
        brnCalificaciones.roundButton()
        btnInfo.roundButton()
        svPrecio.showBottomBorder(width: 1.0)
        svCalificaciones.showBottomBorder(width: 1.0)
        svInfoHorarios.showBottomBorder(width: 1.0)
        btnFavorito.roundButton()
        
        tvTitulo.textContainer.lineFragmentPadding = 0
        tvTitulo.textContainerInset = .zero
        tvTitulo.layoutIfNeeded()
        tituloH.constant = self.tvTitulo.contentSize.height

        tvTitulo.text = "PERUANA DE ESTACIONES DE SERVICIOS S.A.C."

        vInformacion.isHidden = true
        vSombra.isHidden = true
        vPrecioPublicado.isHidden = true
        svPrecioPublicado.isHidden = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        vPrecioPublicado.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            vPrecioPublicado.frame.origin.y = max(vPrecioPublicado.frame.origin.y + translation.y, 20)
            gesture.setTranslation(.zero, in: view)
        case .ended:
            let threshold = view.frame.height * 0.5
            
            UIView.animate(withDuration: 0.3) {
                if self.vPrecioPublicado.frame.origin.y > threshold {
                    self.vPrecioPublicado.isHidden = true
                    self.vSombra.isHidden = true
                    self.svPrecioPublicado.isHidden = true
                } else {
                    self.vPrecioPublicado.isHidden = false
                    self.vSombra.isHidden = false
                    self.svPrecioPublicado.isHidden = false
                }
            }
        default:
            break
        }
    }
    
    //Mostrar view informacion - horarios
    @IBAction func mostrarInformacion(_ sender: Any) {
        if vInformacion.isHidden {
            vInformacion.isHidden = false
        } else {
            vInformacion.isHidden = true
        }
    }
    
    //Mostrar view precio publicado
    @IBAction func mostrarPrecioPublicado(_ sender: Any) {
        if vPrecioPublicado.isHidden {
            vSombra.isHidden = false
            vPrecioPublicado.isHidden = false
            svPrecioPublicado.isHidden = false


        } else {
            vSombra.isHidden = true
            vPrecioPublicado.isHidden = true
            svPrecioPublicado.isHidden = true


        }
        
        
    }
    
    
}
