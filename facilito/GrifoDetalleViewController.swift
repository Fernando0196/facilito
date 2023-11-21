//
//  GrifoDetalleViewController.swift
//  facilito
//
//  Created by iMac Mario on 14/11/23.
//



import UIKit
import SwiftyJSON
import Cosmos

class GrifoDetalleViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    var vGrifos: GrifosViewController!
    var vGrifosMapa: GrifosMapaViewController!


    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!
    @IBOutlet weak var vFondo: UIView!
    @IBOutlet weak var ivFondo: UIImageView!
    @IBOutlet weak var ivLogoGrifo: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var cosmosContainerView: CosmosView!
    @IBOutlet weak var btnFavorito: UIButton!
    @IBOutlet weak var lblDIreccion: UILabel!
    
    @IBOutlet weak var hDireccion: NSLayoutConstraint!
    @IBOutlet weak var hInformacion: NSLayoutConstraint!
    @IBOutlet weak var vInformacion: UIView!
    @IBOutlet weak var vCalificacion: UIView!
    @IBOutlet weak var hInfo: NSLayoutConstraint!
    
    @IBOutlet weak var lblDetalleDireccion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var calificacion: CosmosView!
    
    @IBOutlet weak var tvHorarios: UITableView!
    @IBOutlet weak var tvTelefonos: UITableView!
    @IBOutlet weak var tvFormasPago: UITableView!

    @IBOutlet weak var btnInformacion: UIButton!
    @IBOutlet weak var btnInCalificacion: UIButton!
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var svInformacionHorario: UIStackView!
    @IBOutlet weak var svReportar: UIStackView!
    @IBOutlet weak var svCalificaciones: UIStackView!
    
    @IBOutlet weak var btnIrGrifo: UIButton!
    @IBOutlet weak var btnCalificar: UIButton!
    
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var latitud: String = ""
    var longitud: String = ""
    var precio: String = ""

    //tablas
    var horarios: [String] = []
    var telefonos: [String] = []
    var formasPago: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hInformacion.constant = 0
        hInfo.constant = 0
        vCalificacion.isHidden = true
        vInformacion.isHidden = true
        //112.5
        //832
        btnInformacion.roundButton()
        btnInCalificacion.roundButton()
        btnReportar.roundButton()
        svInformacionHorario.showBottomBorder(width: 1.0)
        svReportar.showBottomBorder(width: 1.0)
        svCalificaciones.showBottomBorder(width: 1.0)
        
        btnBack.roundButton()
        btnIrGrifo.roundButton()
        btnCalificar.roundButton()
        btnMenuUsuario.roundButton()
        btnFavorito.roundButton()
        vFondo.roundView()
        ivFondo.roundImagenFondoGrifo()

        if let grifos = self.vGrifos {
            // Si vGrifos no es nulo
            self.codigoOsinergmin = grifos.codigoOsinergmin
            self.lblNombre.text = grifos.nombreEstablecimiento
            self.precio = grifos.precioGrifo
            self.lblDIreccion.text = grifos.direccionEstablecimiento
            let doubleValue = Double(grifos.valoracionEstablecimiento)
            self.cosmosContainerView.rating = doubleValue ?? 0.0
            self.calificacion.rating = doubleValue ?? 0.0
            lblDetalleDireccion.text = grifos.direccionEstablecimiento
            lblDescripcion.text = grifos.nombreEstablecimiento
        } else if let grifosMapa = self.vGrifosMapa {
            // Si vGrifosMapa no es nulo
            self.codigoOsinergmin = grifosMapa.codigoOsinergmin
            self.lblNombre.text = grifosMapa.nombreEstablecimiento
            self.precio = grifosMapa.precioGrifo
            self.lblDIreccion.text = grifosMapa.direccionEstablecimiento
            let doubleValues = Double(grifosMapa.valoracionEstablecimiento)
            self.cosmosContainerView.rating = doubleValues ?? 0.0
            self.calificacion.rating = doubleValues ?? 0.0
            lblDetalleDireccion.text = grifosMapa.direccionEstablecimiento
            lblDescripcion.text = grifosMapa.nombreEstablecimiento
        }
        
        detalleEstablecimiento()
        //tablas
        tvHorarios.delegate = self
        tvHorarios.dataSource = self
        tvHorarios.rowHeight = UITableView.automaticDimension
        tvHorarios.estimatedRowHeight = 44
        tvTelefonos.delegate = self
        tvTelefonos.dataSource = self
        tvTelefonos.rowHeight = UITableView.automaticDimension
        tvTelefonos.estimatedRowHeight = 44
        tvFormasPago.delegate = self
        tvFormasPago.dataSource = self
        tvFormasPago.rowHeight = UITableView.automaticDimension
        tvFormasPago.estimatedRowHeight = 44
    }
    
    //APIS
    private func detalleEstablecimiento() {
          let ac = APICaller()
          self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
          ac.GettDetalleGrifo(codigoOsinergmin, completion: { (success, result, code) in
              self.hideActivityIndicatorWithText()
              debugPrint(result!)
              if (success && code == 200) {
                  if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                      do {
                          let json = try JSON(data: dataFromString)

                          if !json["localOutRO"]["idUnidadOperativa"].stringValue.isEmpty {
                              self.lblDescripcion.text = " " + json["localOutRO"]["nombreUnidad"].stringValue
                              self.lblDetalleDireccion.text = " " +  json["localOutRO"]["direccion"].stringValue
                              self.latitud = json["localOutRO"]["latitud"].stringValue
                              self.longitud = json["localOutRO"]["longitud"].stringValue

                              if let provPais = json["localOutRO"]["provPais"].stringValue.components(separatedBy: " - ").first {
                                  //self.lblDIreccion.text = provPais
                              }
                              if let telefono = json["localOutRO"]["telefono"].string, !telefono.isEmpty {
                                  let telefonosSeparados = telefono.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                  self.telefonos.append(contentsOf: telefonosSeparados.prefix(2))
                              } else {
                                  self.telefonos.append("Sin especificar")
                              }
                              if let horarios = json["localOutRO"]["horario"].string, !horarios.isEmpty {
                                  let horariosSeparados = horarios.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                  self.horarios.append(contentsOf: horariosSeparados.prefix(2))
                              } else {
                                  self.horarios.append("Sin especificar")
                              }
                              if let formaPago = json["localOutRO"]["formasPago"].string, !formaPago.isEmpty {
                                  let formasPagoSeparadas = formaPago.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                  
                                  if formaPago == "E" {
                                      self.formasPago.append("Efectivo")
                                  } else {
                                      self.formasPago.append(contentsOf: formasPagoSeparadas.prefix(2))
                                  }
                              } else {
                                  self.formasPago.append("Sin especificar")
                              }
     
                              print("Cantidad de elementos en telefonos: \(self.telefonos.count)")
                              print("Cantidad de elementos en formas pago: \(self.formasPago.count)")

                              self.tvTelefonos.reloadData()
                              self.tvHorarios.reloadData()
                              self.tvFormasPago.reloadData()

                          } else {
                              self.displayMessage = "No se pudo obtener detalle, vuelve a intentar"
                              self.performSegue(withIdentifier: "sgDM", sender: self)
                          }
                      } catch {
                          self.displayMessage = "No se pudo obtener detalle, vuelve a intentar"
                          self.performSegue(withIdentifier: "sgDM", sender: self)
                      }
                  } else {
                      self.displayMessage = "No se pudo obtener detalle, vuelve a intentar"
                      self.performSegue(withIdentifier: "sgDM", sender: self)
                  }
              } else {
                  debugPrint("error")
                  self.displayMessage = "No se pudo obtener detalle, vuelve a intentar"
                  self.performSegue(withIdentifier: "sgDM", sender: self)
              }
          })
      }
    
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if tableView == tvHorarios {
         return horarios.count
     } else if tableView == tvTelefonos {
         return telefonos.count
     } else if tableView == tvFormasPago {
         return formasPago.count
     }
     return 0
 }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tableView == tvHorarios {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHorarios", for: indexPath) as! horariosCell

        let horario = horarios[indexPath.row]
        cell.tvHorarios.text = horario

        return cell
    }
    else if tableView == tvTelefonos {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTelefonos", for: indexPath) as! telefonosCell

        let telefono = telefonos[indexPath.row]
        cell.telefono.text = telefono
        cell.btnLlamar.isHidden = telefono.lowercased() == "sin especificar"

        return cell
    }
    else if tableView == tvFormasPago {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFormasPago", for: indexPath) as! formaspagoCell

        if formasPago.count == 1 && formasPago.first == "Efectivo" {
            cell.tvFormaPago.text = "Efectivo"
        } else {
            // Muestra todas las formas de pago
            let formaPago = formasPago[indexPath.row]
            cell.tvFormaPago.text = formaPago
        }

        return cell
    }

    return UITableViewCell()
}
    
    
    @IBAction func reportar(_ sender: Any) {
        
        self.performSegue(withIdentifier: "sgReportar", sender: self)
        
    }
    
    @IBAction func mostrarCalificaciones(_ sender: Any) {
        
        if vCalificacion.isHidden {
            hInfo.constant = 115
            vCalificacion.isHidden = false
        } else {
            hInfo.constant = 0
            vCalificacion.isHidden = true
        }
    }
    
    
    @IBAction func mostrarInformacion(_ sender: Any) {
        if vInformacion.isHidden {
            hInformacion.constant = 832
            vInformacion.isHidden = false
        } else {
            hInfo.constant = 0
            hInformacion.constant = 0
            vInformacion.isHidden = true
        }
    }
    
    
    @IBAction func irGrifo(_ sender: Any) {
    }
    
    
    @IBAction func calificarGrifo(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
        if (segue.identifier == "sgReportar") {
            let vc = segue.destination as! ReportarPrecioGrifoViewController
            vc.vGrifosDetalle = self
            
        }

    }
    
    
    @IBAction func cerrarDetalle(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    
    
    
    
    //Fin clase
}
