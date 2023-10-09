//
//  GasNaturalMensajeViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/10/23.
//


import UIKit
import SwiftyJSON

class GasNaturalMensajeViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var vMensaje: UIView!
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var btnVolver: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMensaje.roundView()
        btnEmpresas.roundButton()
        btnVolver.roundButton()

    }
    
    @IBAction func volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func consultarEmpresasInstaladoras(_ sender: Any) {
        self.performSegue(withIdentifier: "sgEmpresas", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgEmpresas") {
            _ = segue.destination as! EmpresasInstaladorasViewController

        }

    }
    
//Fin clase
}
