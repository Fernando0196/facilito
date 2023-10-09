//
//  BeneficiosViewController.swift
//  facilito
//
//  Created by iMac Mario on 28/10/22.
//

import UIKit


class BeneficiosViewController: UIViewController {

    
    
    @IBOutlet weak var btnMenuUsuario: UIButton!
    
    @IBOutlet weak var vReportar: UIView!
    @IBOutlet weak var vTuberia: UIView!
    @IBOutlet weak var vConsultar: UIView!
    @IBOutlet weak var vProceso: UIView!
    @IBOutlet weak var vCalculadora: UIView!
    
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var btnTuberia: UIButton!
    @IBOutlet weak var btnConsultar: UIButton!
    @IBOutlet weak var btnProceso: UIButton!
    @IBOutlet weak var btnCalculadora: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var v01: UIView!
    @IBOutlet weak var v02: UIView!
    @IBOutlet weak var v03: UIView!
    @IBOutlet weak var v04: UIView!
    @IBOutlet weak var v05: UIView!
    
    @IBOutlet weak var b01: UIButton!
    @IBOutlet weak var b02: UIButton!
    @IBOutlet weak var b03: UIButton!
    @IBOutlet weak var b04: UIButton!
    @IBOutlet weak var b05: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b01.roundButton()
        b02.roundButton()
        b03.roundButton()
        b04.roundButton()
        b05.roundButton()

        v01.dropShadowWithCornerRaduis()
        v02.dropShadowWithCornerRaduis()
        v03.dropShadowWithCornerRaduis()
        v04.dropShadowWithCornerRaduis()
        v05.dropShadowWithCornerRaduis()
        
        v01.addShadowOnBottom()
        v02.addShadowOnBottom()
        v03.addShadowOnBottom()
        v04.addShadowOnBottom()
        v05.addShadowOnBottom()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        
        btnTuberia.roundButton()
        btnConsultar.roundButton()
        btnReportar.roundButton()
        btnProceso.roundButton()
        btnCalculadora.roundButton()
        
        vTuberia.roundView()
        vConsultar.roundView()
        vReportar.roundView()
        vProceso.roundView()
        vCalculadora.roundView()

  
    }

    
}

   
    
 
