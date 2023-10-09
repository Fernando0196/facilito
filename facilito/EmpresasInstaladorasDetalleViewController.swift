//
//  EmpresasInstaladorasDetalleViewController.swift
//  facilito
//
//  Created by iMac Mario on 6/10/23.
//

import UIKit
import SwiftyJSON
import Cosmos

class EmpresasInstaladorasDetalleViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var vEmpresaInst: EmpresasInstaladorasViewController!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!
    
    @IBOutlet weak var vFondo: UIView!
    @IBOutlet weak var ivFondo: UIImageView!
    @IBOutlet weak var ivLogo: UIImageView!
    
    @IBOutlet weak var cosmosContainerView: CosmosView!
    @IBOutlet weak var btnFavorito: UIButton!
    @IBOutlet weak var lblDIreccion: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var idEmpresa: Int = 0

    @IBOutlet weak var tvRUC: UITextView!
    @IBOutlet weak var tvDireccion: UITextView!
    
    @IBOutlet weak var tvTelefonos: UITableView!
    @IBOutlet weak var tvCorreos: UITableView!
    
    var telefonos: [String] = []
    var correos: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnFavorito.roundButton()

        vFondo.roundView()
        ivFondo.roundImagenFondoGrifo()
        
        self.idEmpresa = vEmpresaInst.idEmpresa
        listarEmpresasInstaladoras() 
        
        tvTelefonos.delegate = self
        tvTelefonos.dataSource = self
        tvTelefonos.rowHeight = UITableView.automaticDimension
        tvTelefonos.estimatedRowHeight = 80
        
    }
    
    private func listarEmpresasInstaladoras() {
        let token = ""
        let appInvoker = "appInstitucional"
        let idEmpresaInstaladora = self.idEmpresa

        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        
        ac.PostListarDetalleEmpresas(token: token, appInvoker: appInvoker, idEmpresaInstaladora: idEmpresaInstaladora) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if json["idEmpresaInstaladora"].intValue > 0 {

                            let f = EmpresasInstDetaMenu()
                            
                            self.lblNombre.text = json["nombreEmpresaInstaladora"].stringValue
                            self.lblDIreccion.text = json["domicilioFiscalUbigeoEmpresaInstaladora"].stringValue
                            self.tvRUC.text = json["numeroIdentificacionEmpresaInstaladora"].stringValue
                            self.tvDireccion.text = json["domicilioFiscalUbigeoEmpresaInstaladora"].stringValue
                            
                            if let telefono = json["telefono"].string {
                                if !telefono.isEmpty {
                                    let telefonoLimpio = String(telefono.dropLast())
                                    self.telefonos.append(telefonoLimpio)
                                } else {
                                    self.telefonos.append("")
                                }
                            } else {
                                self.telefonos.append("")
                            }
                            
                            //self.empresasDetalle.append(f)
                            // Luego de cargar los datos, recarga la tabla para que se actualicen
                            DispatchQueue.main.async {
                                //self.tvTabla.reloadData()
                                self.tvTelefonos.reloadData()

                            }
                        } else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obtener, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obtener, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obtener, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
            
             //self.tvEmpresasInstaladoras.reloadData()

        }
    }
    
    @IBAction func volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvTelefonos {
            return telefonos.count
        }else if tableView == tvCorreos {
            return correos.count
        }
        return 0
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == tvTelefonos {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellTelefonos", for: indexPath) as! telefonosCell

           let telefono = telefonos[indexPath.row]
           cell.telefono.text = telefono
           cell.telefono.text = !telefono.isEmpty ? telefono : "Sin especificar"
           cell.btnLlamar.isHidden = telefono.isEmpty

           return cell
       } else if tableView == tvCorreos {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellCorreoEmpresa", for: indexPath) as! correoempresaCell

           let correo = correos[indexPath.row]
           cell.tvCorreo.text = correo

           return cell
       }
       return UITableViewCell()
   }
    
    
    
//Fin clase
}
