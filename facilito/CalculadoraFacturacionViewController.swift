//
//  CalculadoraFacturacionViewController.swift
//  facilito
//
//  Created by iMac Mario on 17/02/23.
//



import UIKit
import SwiftyJSON

class CalculadoraFacturacionViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnCalcular: UIButton!
    
    
    @IBOutlet weak var tfConsumoPasado: UIFloatingLabeledTextField!

    @IBOutlet weak var tfConsumoActual: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfCosto: UIFloatingLabeledTextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.roundButton()
        btnCalcular.roundButton()

        tfConsumoPasado.styleTextField(textField: tfConsumoPasado)
        tfConsumoActual.styleTextField(textField: tfConsumoActual)
        tfCosto.styleTextField(textField: tfCosto)
    }
    
    

}
