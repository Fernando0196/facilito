//
//  CalculadoraResultado.swift
//  facilito
//
//  Created by iMac Mario on 10/01/23.
//



import UIKit
import SwiftyJSON

class CalculadoraResultadoViewController: UIViewController {
    
    var vCalculadora: CalculadoraViewController!

    
    @IBOutlet weak var vCocina: UIView!
    @IBOutlet weak var vTerma: UIView!
    @IBOutlet weak var vSecadora: UIView!
    @IBOutlet weak var tvLeyenda: UITextView!

    @IBOutlet weak var svCocina: UIStackView!
    @IBOutlet weak var svTerma: UIStackView!
    @IBOutlet weak var svSecadora: UIStackView!
    
    @IBOutlet weak var lblPrecioCocina: UILabel!
    @IBOutlet weak var lblTerma: UILabel!
    @IBOutlet weak var lblSecadora: UILabel!
    
    

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!

    @IBOutlet weak var btnCocina: UIButton!
    @IBOutlet weak var btnTerma: UIButton!
    @IBOutlet weak var btnSecadora: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnCocina.roundButton()
        btnTerma.roundButton()
        btnSecadora.roundButton()
        tvLeyenda.text = "* En el cálculo no se incluyen los costos de la instalación domiciliaria, el derecho de conexión y acometida. \n\n** Consulte en las empresas concesionarias si le corresponde el beneficio del mecanismo de promoción. Si es así, no pagará el derecho de conexión y acometida. \n\n*** Con Bonogas también podrá acceder a financiamiento sin intereses y descuentos para realizar la instalación domiciliaria."


        lblPrecioCocina.text = "S/ " + vCalculadora.precioCocina + " /mes"
        lblTerma.text = "S/ " + String(vCalculadora.precioTerma) + " /mes"
        lblSecadora.text = "S/ " + String(vCalculadora.precioSecadora) + " /mes" 
        
        if self.vCalculadora.mostraView2 == 2  {
            svTerma.isHidden = false
        }
        else {
            svTerma.isHidden = true
        }
        if self.vCalculadora.mostraView3 == 3 {
            svSecadora.isHidden = false
        }
        else {
            svSecadora.isHidden = true
        }
    }
    
    
    @IBAction func volverCalculadora(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
