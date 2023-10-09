//
//  CostoInstalacionViewController.swift
//  facilito
//
//  Created by iMac Mario on 7/11/22.
//

import UIKit


class CostoInstalacionViewController: UIViewController {

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var v01: UIView!
    @IBOutlet weak var v02: UIView!
    @IBOutlet weak var v03: UIView!

    
    @IBOutlet weak var b01: UIButton!
    @IBOutlet weak var b02: UIButton!
    @IBOutlet weak var b03: UIButton!

    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var btnProcesoInsta: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b01.roundButton()
        b02.roundButton()
        b03.roundButton()

        v01.dropShadowWithCornerRaduis()
        v02.dropShadowWithCornerRaduis()
        v03.dropShadowWithCornerRaduis()
        
        btnBack.roundButton()
        btnRegresar.roundButton()
        btnProcesoInsta.roundButton()

  
    }

    
}

