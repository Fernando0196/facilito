//
//  TramitesDetalleViewController.swift
//  facilito
//
//  Created by iMac Mario on 21/09/23.
//

import UIKit
import SwiftyJSON

class TramitesDetalleViewController: UIViewController, UITextFieldDelegate {
    

    var vTramites: TramitesViewController!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!

    @IBOutlet weak var tvMenu: UITableView!
    @IBOutlet weak var lblAsunto: UILabel!
    
    @IBOutlet weak var svConformeInconforme: UIStackView!
    @IBOutlet weak var btnInconforme: UIButton!
    @IBOutlet weak var btnConforme: UIButton!
    
    
    @IBOutlet weak var tvContratos: UITableView!
    
    var tramitesDetalle: [TramitesDetalleMenu] = [TramitesDetalleMenu]()
    var df : TramitesDetalleMenu!
    
    var contratosDetalle: [ContratosMenu] = [ContratosMenu]()
    var dfContratos : ContratosMenu!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var nroInconformidad: String = ""
    var asunto: String = ""
    var estado: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnInconforme.roundButton()
        btnConforme.roundButton()
        svConformeInconforme.isHidden = true
        self.nroInconformidad = self.vTramites.nroInconformidad
        lblAsunto.text = self.vTramites.asunto
        
        listarTramites()
        
        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self
        tvMenu.rowHeight = 100
        self.estado = vTramites.estado
        if self.estado == "3" {
            svConformeInconforme.isHidden = false

        }
        else{
            //true
            svConformeInconforme.isHidden = true
        }

        
    }

    private func listarTramites() {
        
        let nroInconformidad = nroInconformidad

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarDetalleTramite(nroInconformidad) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if !json["acciones"].arrayValue.isEmpty {
                        let jRecords = json["acciones"].arrayValue
                        
                        self.tramitesDetalle.removeAll()
                        for index in (0..<jRecords.count).reversed() {
                            let subJson = jRecords[index]
                            let f = TramitesDetalleMenu()
                            f.descripcionAccion = subJson["descripcionAccion"].stringValue
                            f.fechaHora = subJson["fechaHora"].stringValue
                            f.estadoDescripcion = subJson["estadoDescripcion"].stringValue
                            f.estado = "\(jRecords.count - index)" // Asigna el valor en orden descendente
                            self.tramitesDetalle.append(f)
                            
                            let lastIndex = self.tramitesDetalle.count - 1
                            self.tramitesDetalle[lastIndex].estado = "\(self.tramitesDetalle.count)"
                            self.tramitesDetalle.sort { (f1, f2) -> Bool in
                                return f1.estado > f2.estado
                            }
                        }
                    } else {
                        self.displayMessage = json["Mensaje"].stringValue
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } catch {
                    self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
            //recargar
            self.tvMenu.reloadData()
        }
    }
    
    
    @IBAction func ocultarDetalle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnMostrarMenuHamburguesa(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgMenuHamburguesa", sender: self)
        
    }
    
    
    @IBAction func enviarNoConforme(_ sender: Any) {
        self.performSegue(withIdentifier: "sgNoConforme", sender: self)

    }
    
    @IBAction func enviarConforme(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgMenuHamburguesa") {
            let vc = segue.destination as! MenuPrincipalViewController
            //enviar datos del usuario
            //vc.vIniciarSesion = self.vIniciarSesion
            
        }
        if (segue.identifier == "sgNoConforme") {
            let vc = segue.destination as! NoConformeViewController
            vc.vTramitesDetalle = self
                
        }

    }
    
    
    
    
//Fin clase
}



extension TramitesDetalleViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tramitesDetalle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTramitesDetalle", for: indexPath) as! tramitesdetalleCell
        
        let f = self.tramitesDetalle[indexPath.row]

        cell.lblDetalle.text = f.descripcionAccion
        cell.lblFechaHora.text = f.fechaHora
        cell.lblProceso.text = f.estadoDescripcion
        cell.btnNumero.setTitle(f.estado, for: .normal)

        /*cell.btnSeleccionarMenu.tag = indexPath.row
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
      */
        return cell
    }
    /*
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
       
        self.df = self.tramitesDetalle[sender.tag]
        self.asunto = self.df.asunto
        self.nroInconformidad = self.df.nroInconformidad
        self.performSegue(withIdentifier: "sgTramitesDetalle", sender: self)
    }
    */
}

