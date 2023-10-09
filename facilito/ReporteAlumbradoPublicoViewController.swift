//
//  ReporteAlumbradoPublicoViewController.swift
//  facilito
//
//  Created by iMac Mario on 12/05/23.
//

import UIKit
import SwiftyJSON

class ReporteAlumbradoPublicoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvAsunto: UITextView!
    @IBOutlet weak var tvPostes: UITextView!
    @IBOutlet weak var tfEmpresa: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tfSuministro: UIFloatingLabeledTextField!
    
    @IBOutlet weak var tvDescripcion: UITextView!
    
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnEnviar.roundButton()
        

        tfEmpresa.styleTextField(textField: tfEmpresa)
        tfSuministro.styleTextField(textField: tfSuministro)
        tvAsunto.layer.cornerRadius = 5
        tvPostes.layer.cornerRadius = 5
        tvDescripcion.layer.cornerRadius = 5


        
    }
    

}
