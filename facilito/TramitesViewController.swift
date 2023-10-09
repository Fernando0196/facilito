//
//  TramitesViewController.swift
//  facilito
//
//  Created by iMac Mario on 28/04/23.
//

import UIKit
import SwiftyJSON

class TramitesViewController: UIViewController, UITextFieldDelegate {
    
    var vIniciarSesion: BalonGasMapaViewController!

    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!
    @IBOutlet weak var btnAbrirFiltroExpan: UIButton!
    @IBOutlet weak var btnCerarFiltroExpan: UIButton!

    @IBOutlet weak var btnTodos: UIButton!
    @IBOutlet weak var btnGrifos: UIButton!
    @IBOutlet weak var btnBalonGas: UIButton!
    @IBOutlet weak var btnElectricidad: UIButton!
    @IBOutlet weak var btnGasNatural: UIButton!
    
    @IBOutlet weak var tvMenu: UITableView!
    
    @IBOutlet weak var btnReportes: UIButton!
    @IBOutlet weak var btnContratos: UIButton!
    @IBOutlet weak var hReporteContratos: NSLayoutConstraint!
    
    
    @IBOutlet weak var tvContratos: UITableView!
    
    var contratosDetalle: [ContratosMenu] = [ContratosMenu]()
    var dfContratos : ContratosMenu!
    
    var tituloMenu: String = ""
    var tramites: [TramitesMenu] = [TramitesMenu]()
    var df : TramitesMenu!
    
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    //Datos usuario
    var logueado: Bool = false
    var nroDocumento: String = ""
    var nombreUsua: String = ""
    var apellidoUsua: String = ""
    var correoUsua: String = ""
    var telefonoUsua: String = ""
    
    var codigoSector: String = ""
    var asunto: String = ""
    var nroInconformidad: String = ""
    var estado: String = ""

    //contratos
    var idSolicitud: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hReporteContratos.constant = 0
        btnReportes.isHidden = true
        btnContratos.isHidden = true
        btnCerarFiltroExpan.isHidden = true
        btnMenuUsuario.roundButton()
        btnCerarFiltroExpan.roundButton()
        btnBack.roundButton()
        btnTodos.roundButton()
        btnGrifos.roundButton()
        btnBalonGas.roundButton()
        btnElectricidad.roundButton()
        btnGasNatural.roundButton()
        btnTodos.backgroundColor =  UIColor(hex: 0x000090)
        btnTodos.tintColor = UIColor.white
        
        configureBottomBorder(button: btnReportes, color: UIColor(red: 254.0/255.0, green: 209.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor)
        configureBottomBorder(button: btnContratos, color: UIColor.white.cgColor)
        
        //Datos USUARIO
        if self.vIniciarSesion != nil {
            self.logueado = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["logueado"].boolValue ?? false
            nroDocumento = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["nroDocumento"].stringValue ?? ""
            nombreUsua = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["nombre"].stringValue ?? ""
            apellidoUsua = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["apellidos"].stringValue ?? ""
            correoUsua = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["correo"].stringValue ?? ""
            telefonoUsua = self.vIniciarSesion?.jsonUsuario?.jsonUsuario["loginOutRO"]["telefono"].stringValue ?? ""
        }

        listarTramites()
        
        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self
        tvMenu.rowHeight = 118
        
        tvContratos.allowsSelection = false
        tvContratos.dataSource = self
        tvContratos.delegate = self
        tvContratos.rowHeight = 80
        tvContratos.isHidden = true

    }

    
    @IBAction func mostrarContratos(_ sender: Any) {
        configureBottomBorder(button: btnContratos, color: UIColor(red: 254.0/255.0, green: 209.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor)
        configureBottomBorder(button: btnReportes, color: UIColor.white.cgColor)
       // self.performSegue(withIdentifier: "sgContratos", sender: self)

        tvMenu.isHidden = true
        tvContratos.isHidden = false
        listarContratos()
        
    }
    
    @IBAction func mostrarReportes(_ sender: Any) {
        configureBottomBorder(button: btnReportes, color: UIColor(red: 254.0/255.0, green: 209.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor)
        configureBottomBorder(button: btnContratos, color: UIColor.white.cgColor)
     //   self.performSegue(withIdentifier: "sgReportes", sender: self)
        tvMenu.isHidden = false
        tvContratos.isHidden = true


    }
    
    private func listarTramites() {
        
        let correo = correoUsua
        let codSector = codigoSector
        let codCanalRegistro = "5"

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarTramites(correo, codSector, codCanalRegistro ) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if !json["inconformidades"]["inconformidades"].arrayValue.isEmpty {
                        let jRecords = json["inconformidades"]["inconformidades"].arrayValue
                        
                        self.tramites.removeAll()
                        for (_, subJson) in jRecords.enumerated() {
                            let f = TramitesMenu()
                            
                            f.nroInconformidad = subJson["nroInconformidad"].stringValue
                            f.asunto = subJson["asunto"].stringValue
                            f.motivo = subJson["motivo"].stringValue
                            f.fechaHora = subJson["fechaHora"].stringValue
                            f.estadoDescripcion = subJson["estadoDescripcion"].stringValue
                            f.estado = subJson["estado"].stringValue

                            //Para el ícono
                            f.codSector = subJson["codSector"].stringValue
                            
                            self.tramites.append(f)
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

    private func listarContratos() {
        
        let appInvoker = "appInstitucional"
        let tipoIdentificacionSolicitante = "D"
        let numeroIdentificacionSolicitante = "07994876"
        let page = 1
        let rowsPerPage = 10
        let idSolicitud: Int? = nil

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarContratos(appInvoker: appInvoker, tipoIdentificacionSolicitante: tipoIdentificacionSolicitante, numeroIdentificacionSolicitante: numeroIdentificacionSolicitante, page: page, rowsPerPage: rowsPerPage, idSolicitud: idSolicitud) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if !json["solicitudInformacionGeneral"].arrayValue.isEmpty {
                        let jRecords = json["solicitudInformacionGeneral"].arrayValue
                        
                        self.contratosDetalle.removeAll()
                        for (_, subJson) in jRecords.enumerated() {
                            let f = ContratosMenu()
                            

                            
                            f.idSolicitud = subJson["idSolicitud"].intValue
                            f.nombreUltimaEtapaConcluidaSolicitud = subJson["nombreUltimaEtapaConcluidaSolicitud"].stringValue
                            f.idEstadoSolicitud = subJson["idEstadoSolicitud"].intValue
                            
                            self.contratosDetalle.append(f)
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
            self.tvContratos.reloadData()
        }
    }
    
    @IBAction func botonPresionado(_ sender: UIButton) {
        // Verificar si el botón ya está seleccionado
        if sender.backgroundColor == UIColor(hex: 0x000090) {
            return // No hacer nada si el botón ya está seleccionado
        }

        let buttonsToReset: [UIButton] = [btnTodos, btnGrifos, btnBalonGas, btnElectricidad, btnGasNatural]

        for button in buttonsToReset {
            button.backgroundColor = UIColor.clear
            button.tintColor = UIColor(hex: 0x67738F)
        }

        // Activar el botón seleccionado
        sender.backgroundColor = UIColor(hex: 0x000090)
        sender.tintColor = UIColor.white

        // Actualizar codigoSector según el botón seleccionado
        switch sender {
        case btnTodos:
            codigoSector = "0"
            hReporteContratos.constant = 0
            btnReportes.isHidden = true
            btnContratos.isHidden = true
            tvContratos.isHidden = true
            tvMenu.isHidden = false
        case btnGrifos, btnBalonGas:
            codigoSector = "6"
            hReporteContratos.constant = 0
            btnReportes.isHidden = true
            btnContratos.isHidden = true
            tvContratos.isHidden = true
            tvMenu.isHidden = false
        case btnElectricidad:
            codigoSector = "2"
            hReporteContratos.constant = 0
            btnReportes.isHidden = true
            btnContratos.isHidden = true
            tvContratos.isHidden = true
            tvMenu.isHidden = false
        case btnGasNatural:
            hReporteContratos.constant = 50
            btnReportes.isHidden = false
            btnContratos.isHidden = false
            tvContratos.isHidden = true
            tvMenu.isHidden = false
            codigoSector = "4"
            configureBottomBorder(button: btnReportes, color: UIColor(red: 254.0/255.0, green: 209.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor)
            configureBottomBorder(button: btnContratos, color: UIColor.white.cgColor)
            // self.performSegue(withIdentifier: "sgReportes", sender: self)
        default: break
        }

        listarTramites()

    }

    func configureBottomBorder(button: UIButton, color: CGColor) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: button.frame.size.height - 1, width: button.frame.size.width, height: 2)
        bottomBorder.backgroundColor = color


        button.layer.addSublayer(bottomBorder)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgTramitesDetalle") {
            let vc = segue.destination as! TramitesDetalleViewController
            vc.vTramites = self
            //
            
        }

        if (segue.identifier == "sgContratoDetalle") {
            let vc = segue.destination as! ContratosDetalleViewController
            vc.vContratos = self
            //
            
        }
    }
    
    
    
}


extension TramitesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvMenu {
            return self.tramites.count
        } else if tableView == tvContratos {
            return self.contratosDetalle.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tvMenu {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTramites", for: indexPath) as! tramitesCell

            let f = self.tramites[indexPath.row]

            if f.codSector == "2" {
                cell.btnIcono.setImage(UIImage(named: "electricidad_"), for: .normal)
            }
            if f.codSector == "4" {
                cell.btnIcono.setImage(UIImage(named: "gas_nat_"), for: .normal)
            }
            if f.codSector == "6" {
                cell.btnIcono.setImage(UIImage(named: "grifo_"), for: .normal)
            }

            cell.lblAsunto.text = f.asunto
            cell.lblMotivo.text = f.motivo
            cell.lblFechaHora.text = f.fechaHora
            cell.lblEstado.text = f.estadoDescripcion

            cell.btnSeleccionarMenu.tag = indexPath.row
            cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)

            return cell
            
        } else if tableView == tvContratos {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellContratos", for: indexPath) as! contratosCell

            let f = self.contratosDetalle[indexPath.row]
            cell.lblContrato.text = "Contrato Nº " + String(f.idSolicitud)
            cell.lblDescripcion.text = f.nombreUltimaEtapaConcluidaSolicitud
            cell.lblEstado.text = String(f.idEstadoSolicitud)

            cell.btnSeleccionarContrato.tag = indexPath.row
            cell.btnSeleccionarContrato.addTarget(self, action: #selector(self.btnSeleccionarContratoPressed(_:)), for: .touchUpInside)

            return cell
        }

        return UITableViewCell()
    }

    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
       
        self.df = self.tramites[sender.tag]
        self.asunto = self.df.asunto
        self.nroInconformidad = self.df.nroInconformidad
        self.estado = self.df.estado

        self.performSegue(withIdentifier: "sgTramitesDetalle", sender: self)
    }
    
    @objc func btnSeleccionarContratoPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
       
        self.dfContratos = self.contratosDetalle[sender.tag]
        self.idSolicitud = self.dfContratos.idSolicitud

        self.performSegue(withIdentifier: "sgContratoDetalle", sender: self)
    }
    
}


    
