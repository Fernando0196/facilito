//
//  ProcesosInstalacionViewController.swift
//  facilito
//
//  Created by iMac Mario on 28/10/22.
//

import UIKit


class ProcesoInstalacionViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!

    
    @IBOutlet weak var btnVerCostos: UIButton!
    @IBOutlet weak var btnVerProceo: UIButton!
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var vReportar: UIView!
    @IBOutlet weak var vTuberia: UIView!
    @IBOutlet weak var vConsultar: UIView!
    @IBOutlet weak var vBeneficio: UIView!
    @IBOutlet weak var vCalculadora: UIView!
    
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var btnTuberia: UIButton!
    @IBOutlet weak var btnConsultar: UIButton!
    @IBOutlet weak var btnBeneficio: UIButton!
    @IBOutlet weak var btnCalculadora: UIButton!
    
    //Proceso
    @IBOutlet weak var svProceso: UIScrollView!
    @IBOutlet weak var v01P: UIView!
    @IBOutlet weak var v02P: UIView!
    @IBOutlet weak var v03P: UIView!
    @IBOutlet weak var v04P: UIView!
    @IBOutlet weak var v05P: UIView!
    
    @IBOutlet weak var b01P: UIButton!
    @IBOutlet weak var b02P: UIButton!
    @IBOutlet weak var b03P: UIButton!
    @IBOutlet weak var b04P: UIButton!
    @IBOutlet weak var b05P: UIButton!
    //Costos
    @IBOutlet weak var svCostos: UIScrollView!
    @IBOutlet weak var v01C: UIView!
    @IBOutlet weak var v02C: UIView!
    @IBOutlet weak var v03C: UIView!
    
    @IBOutlet weak var b01C: UIButton!
    @IBOutlet weak var b02C: UIButton!
    @IBOutlet weak var b03C: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b01P.roundButton()
        b02P.roundButton()
        b03P.roundButton()
        b04P.roundButton()
        b05P.roundButton()
        v01P.dropShadowWithCornerRaduis()
        v02P.dropShadowWithCornerRaduis()
        v03P.dropShadowWithCornerRaduis()
        v04P.dropShadowWithCornerRaduis()
        v05P.dropShadowWithCornerRaduis()
        
        b01C.roundButton()
        b02C.roundButton()
        b03C.roundButton()
        v01C.dropShadowWithCornerRaduis()
        v02C.dropShadowWithCornerRaduis()
        v03C.dropShadowWithCornerRaduis()

        v01P.addShadowOnBottom()
        v02P.addShadowOnBottom()
        v03P.addShadowOnBottom()
        v04P.addShadowOnBottom()
        v05P.addShadowOnBottom()
        
        v01C.addShadowOnBottom()
        v02C.addShadowOnBottom()
        v03C.addShadowOnBottom()

        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnVerCostos.roundButton()
        btnVerProceo.roundButton()
        
        vReportar.roundView()
        vTuberia.roundView()
        vConsultar.roundView()
        vBeneficio.roundView()
        vCalculadora.roundView()
        btnReportar.roundButton()
        btnTuberia.roundButton()
        btnConsultar.roundButton()
        btnBeneficio.roundButton()
        btnCalculadora.roundButton()

        svCostos.isHidden = true

  
    }
    
    @IBAction func mostrarCostos(_ sender: Any) {
        svCostos.isHidden = false
        btnVerCostos.isHidden = true
        svProceso.isHidden = true
        btnVerProceo.isHidden = false
        lblTitulo.text = "Costo de instalación"
    }
    
    @IBAction func mostrarProceso(_ sender: Any) {
        svCostos.isHidden = true
        btnVerCostos.isHidden = false
        svProceso.isHidden = false
        btnVerProceo.isHidden = true
        lblTitulo.text = "Proceso de instalación"

    }
    
    
}

