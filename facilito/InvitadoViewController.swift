//
//  InvitadoViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/10/22.
//

import UIKit


class InvitadoViewController: UIViewController {

    @IBOutlet weak var vContenedor: UIView!
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var btnRegistrarme: UIButton!
    @IBOutlet weak var btnIniciarGoogle: UIButton!
    @IBOutlet weak var btnIniciarFacebook: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnIngresar.roundButton()
        btnRegistrarme.roundButton()
        btnIniciarGoogle.roundButton()
        btnIniciarFacebook.roundButton()
        vContenedor.roundView()

        
        
    }


    
}
