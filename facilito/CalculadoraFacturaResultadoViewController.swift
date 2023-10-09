//
//  CalculadoraFacturaResultadoViewController.swift
//  facilito
//
//  Created by iMac Mario on 17/02/23.
//



import UIKit
import SwiftyJSON

class CalculadoraFacturaResultadoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var vMesAnterior: UIView!
    
    @IBOutlet weak var vMesActual: UIView!
    
    @IBOutlet weak var vCosto: UIView!
    
    @IBOutlet weak var vResultado: UIView!
    
    @IBOutlet weak var tvInformacion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()
        vMesAnterior.addBottomBorderItem1()
        vMesActual.addBottomBorderItem1()
        vCosto.addBottomBorderItem1()
        vResultado.addBottomBorderItem1()
        tvInformacion.text = "* En el cálculo no se incluyen los costos de la instalación domiciliaria, el derecho de conexión y acometida. \n\n** Consulte en las empresas concesionarias si le corresponde el beneficio del mecanismo de promoción. Si es así, no pagará el derecho de conexión y acometida."
        

    }
    
    

}
