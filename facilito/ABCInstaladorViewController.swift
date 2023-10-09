//
//  ABCInstalador.swift
//  facilito
//
//  Created by iMac Mario on 29/12/22.
//

import UIKit
import SwiftyJSON

class ABCInstaladorViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ivImagen: UIImageView!
    @IBOutlet weak var btnRegresar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()
        btnRegresar.roundButton()

    }
    
    


}
