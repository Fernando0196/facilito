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
    @IBOutlet weak var tvCorreo: UITableView!

    var telefonos: [String] = []
    var correos: [String] = []
    var telLlamada: String = ""

    @IBOutlet weak var btnInformacion: UIButton!
    @IBOutlet weak var svInformacion: UIStackView!
    @IBOutlet weak var btnVerInformacion: UIButton!
    
    @IBOutlet weak var svCalificaciones: UIStackView!
    
    @IBOutlet weak var btnCalifcaciones: UIButton!
    
    @IBOutlet weak var btnLlamar: UIButton!
    
    @IBOutlet weak var vInformacion: UIView!
    
    @IBOutlet weak var hViewInformacion: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnInformacion.roundButton()
        svInformacion.showBottomBorder(width: 1.0)
        svCalificaciones.showBottomBorder(width: 1.0)
        btnCalifcaciones.roundButton()
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnFavorito.roundButton()
        btnLlamar.roundButton()
        vFondo.roundView()
        ivFondo.roundImagenFondoGrifo()
        
        self.idEmpresa = vEmpresaInst.idEmpresa
        listarEmpresasInstaladoras() 
        
        tvTelefonos.delegate = self
        tvTelefonos.dataSource = self
        tvTelefonos.rowHeight = UITableView.automaticDimension
        tvTelefonos.estimatedRowHeight = 40
        tvCorreo.delegate = self
        tvCorreo.dataSource = self
        tvCorreo.rowHeight = UITableView.automaticDimension
        tvCorreo.estimatedRowHeight = 40
        hViewInformacion.constant = 0
        vInformacion.isHidden = true
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
                            
                            if let telefono = json["telefonoEmpresaInstaladora"].string {
                                if !telefono.isEmpty {
                                    let telefonosSeparados = telefono.components(separatedBy: "/")
                                    
                                    if let ultimoTelefono = telefonosSeparados.last {
                                        self.telLlamada = ultimoTelefono.trimmingCharacters(in: .whitespaces)
                                    } else {
                                        self.telLlamada = ""
                                    }
                                    
                                    for telefonoSeparado in telefonosSeparados {
                                        let telefonoLimpio = String(telefonoSeparado.trimmingCharacters(in: .whitespaces))
                                        self.telefonos.append(telefonoLimpio)
                                    }
                                } else {
                                    self.telLlamada = ""
                                    self.telefonos.append("")
                                }
                            } else {
                                self.telLlamada = ""
                                self.telefonos.append("")
                            }
                            
                            if let correo = json["emailEmpresaInstaladora"].string {
                                if !correo.isEmpty {
                                    let correoLimpio = String(correo.dropLast())
                                    self.correos.append(correoLimpio)
                                } else {
                                    self.correos.append("")
                                }
                            } else {
                                self.correos.append("")
                            }
                            
                            self.tvTelefonos.reloadData()
                            self.tvCorreo.reloadData()
                                



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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // Altura deseada para las celdas (ajusta este valor según tus necesidades)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvTelefonos {
            return telefonos.count
        }
        else if tableView == tvCorreo {
            return correos.count
        }
        return 0
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       if tableView == tvTelefonos {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellTelefonoEmpresa", for: indexPath) as! telefonosempresaCell

           let telefono = telefonos[indexPath.row]
           cell.tvTelefono.text = telefono
           cell.btnLlamar.isHidden = telefono.isEmpty

           return cell
       } else if tableView == tvCorreo {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellCorreoEmpresa", for: indexPath) as! correoempresaCell

           let correo = correos[indexPath.row]
           cell.tvEmail.text = correo

           return cell
       }
       return UITableViewCell()
   }
    
    @IBAction func verInformacion(_ sender: Any) {
        if vInformacion.isHidden {
            vInformacion.isHidden = false
            hViewInformacion.constant = 411
        } else {
            vInformacion.isHidden = true
            hViewInformacion.constant = 0
        }
    }
    
    
    @IBAction func llamar(_ sender: Any) {
        let telLlamada = self.telLlamada // Tu número de teléfono
        let telURL = URL(string: "tel://\(telLlamada)")!
        if UIApplication.shared.canOpenURL(telURL) {
            // Tu aplicación tiene permiso para realizar llamadas
            UIApplication.shared.open(telURL)
        } else {
            // Tu aplicación no tiene permiso, debes solicitarlo al usuario
            // Aquí puedes mostrar un mensaje o una alerta pidiendo permiso
        }
    }
    

    
//Fin clase
}
