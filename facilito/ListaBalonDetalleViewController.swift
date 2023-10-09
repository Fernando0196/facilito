//
//  ListaBalonDetalloViewController.swift
//  facilito
//
//  Created by iMac Mario on 19/09/23.
//

import UIKit
import SwiftyJSON
import Cosmos

class ListaBalonDetalleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var vBalonGasMapa: ListaBalonGasViewController!

    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!
    @IBOutlet weak var vFondo: UIView!
    @IBOutlet weak var ivFondo: UIImageView!
    @IBOutlet weak var ivLogoGrifo: UIImageView!
    @IBOutlet weak var nombreBalonGas: UITextView!
    @IBOutlet weak var hNombreBalonGas: NSLayoutConstraint!
    
    @IBOutlet weak var cosmosContainerView: CosmosView!
    @IBOutlet weak var btnFavorito: UIButton!
    @IBOutlet weak var lblDIreccion: UILabel!
    @IBOutlet weak var hDireccion: NSLayoutConstraint!
    
    @IBOutlet weak var btnInformacionHorarios: UIButton!
    
    @IBOutlet weak var tvDescripcion: UITextView!
    @IBOutlet weak var tvDistrito: UITextView!
    @IBOutlet weak var tvDireccion: UITextView!
    
    @IBOutlet weak var btnInformacion: UIButton!
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var btnReportarEstablecimiento: UIButton!
    
    @IBOutlet weak var btnCalificaciones: UIButton!
    @IBOutlet weak var btnCali: UIButton!
    
    @IBOutlet weak var btnCalificar: UIButton!
    
    @IBOutlet weak var svInformacionHorario: UIStackView!
    @IBOutlet weak var ivInfoHorario: UIImageView!
    
    @IBOutlet weak var svReportar: UIStackView!
    
    @IBOutlet weak var svCalificaciones: UIStackView!
    
    
    @IBOutlet weak var tvTabla: UITableView!
    @IBOutlet weak var tvTelefonos: UITableView!
    @IBOutlet weak var tvHorarios: UITableView!
    @IBOutlet weak var tvFormasPago: UITableView!
    
    @IBOutlet weak var svTelefonos: UIStackView!
    @IBOutlet weak var svHorarios: UIStackView!
    
    @IBOutlet weak var hInformacionHorario: NSLayoutConstraint!
    @IBOutlet weak var vInformacionHorario: UIView!
    
    
    //etiquetas
    @IBOutlet weak var descripcionTitulo: UITextView!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var marcaTipoBalon: UITextView!
    @IBOutlet weak var telefonoTitulo: UITextView!
    @IBOutlet weak var precio: UITextView!
    @IBOutlet weak var horario: UITextView!
    @IBOutlet weak var distrito: UITextView!
    @IBOutlet weak var nombreDistrito: UITextView!
    @IBOutlet weak var direccionTitulo: UITextView!
    @IBOutlet weak var direccion: UITextView!
    @IBOutlet weak var hdireccion: NSLayoutConstraint!
    
    @IBOutlet weak var formasPagoTitulo: UITextView!

    

    
    var datos: [(marca: String, precio: String)] = []

    var telefonos: [String] = [

     ]
    let horarios: [String] = [
         "Sin especificar"
    ]
    let formasPago: [String] = [
        "Efectivo",
        "Tarjeta"

    ]
    
    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var latitud: String = ""
    var longitud: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fuente
        //fuente
        let poppin = UIFont(name: "Poppins", size: 14.0)
        let poppinBold = UIFont(name: "Poppins-Bold", size: 14.0)
        descripcionTitulo.font = poppinBold
        descripcion.font = poppin
        marcaTipoBalon.font = poppinBold
        precio.font = poppinBold
        horario.font = poppinBold
        distrito.font = poppinBold
        nombreDistrito.font = poppin
        direccionTitulo.font = poppinBold
        direccion.font = poppin
        formasPagoTitulo.font = poppinBold
        telefonoTitulo.font = poppinBold
     
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnInformacion.roundButton()
        btnReportar.roundButton()
        btnCali.roundButton()
        btnCalificar.roundButton()
        btnFavorito.roundButton()
        svInformacionHorario.showBottomBorder(width: 1.0)
        svReportar.showBottomBorder(width: 1.0)
        svCalificaciones.showBottomBorder(width: 1.0)
        
        vFondo.roundView()
        ivFondo.roundImagenFondoGrifo()
        
        hInformacionHorario.constant = 0
        vInformacionHorario.isHidden = true
        
        tvTabla.delegate = self
        tvTabla.dataSource = self
        tvTabla.rowHeight = UITableView.automaticDimension
        tvTabla.estimatedRowHeight = 80

        
        tvTelefonos.delegate = self
        tvTelefonos.dataSource = self
        tvTelefonos.rowHeight = UITableView.automaticDimension
        tvTelefonos.estimatedRowHeight = 80
        
        tvHorarios.delegate = self
        tvHorarios.dataSource = self
        tvHorarios.rowHeight = UITableView.automaticDimension
        tvHorarios.estimatedRowHeight = 44
        tvFormasPago.delegate = self
        tvFormasPago.dataSource = self
        tvFormasPago.rowHeight = UITableView.automaticDimension
        tvFormasPago.estimatedRowHeight = 44
        
        
        self.codigoOsinergmin = self.vBalonGasMapa.codigoOsinergmin
        self.nombreEstablecimiento = self.vBalonGasMapa.nombreEstablecimiento
        self.nombreBalonGas.text = self.nombreEstablecimiento
        let doubleValue = Double(self.vBalonGasMapa.valoracionEstablecimiento)
        cosmosContainerView.rating = doubleValue ?? 0.0
        self.direccionEstablecimiento = self.vBalonGasMapa.direccionEstablecimiento
        self.lblDIreccion.text = self.direccionEstablecimiento
        
        detalleEstablecimiento()
        direccion.adjustHeightToFitContent()
        hdireccion.constant = self.direccion.contentSize.height
        // Calcula la altura necesaria para el contenido del UILabel
        let requiredSize = lblDIreccion.sizeThatFits(CGSize(width: lblDIreccion.frame.size.width, height: CGFloat.greatestFiniteMagnitude))

        hDireccion.constant = requiredSize.height
        
        // Configura un valor máximo de altura
        let maxHeight: CGFloat = 200
        
        // Observa cambios en el contenido de la UITextView
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        // Configura la altura inicial de la UITextView y la restricción
        self.nombreBalonGas.textContainerInset = .zero
        hNombreBalonGas.constant = maxHeight
        
        
        
        
    }
    @objc func textViewDidChange(_ notification: Notification) {
            // Calcula la altura necesaria para mostrar el contenido
        let sizeToFit = self.nombreBalonGas.sizeThatFits(CGSize(width: self.nombreBalonGas.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            
            // Limita la altura al valor máximo
            let maxHeight: CGFloat = 200
            let newHeight = min(sizeToFit.height, maxHeight)
            
            // Actualiza la restricción de altura
        self.hNombreBalonGas.constant = newHeight
            
            // Llama a layoutIfNeeded para animar el cambio de altura
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
    }
        
        
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == tvTabla {
             return datos.count
         } else if tableView == tvTelefonos {
             return telefonos.count
         }else if tableView == tvHorarios {
             return horarios.count
         }else if tableView == tvFormasPago {
             return formasPago.count
         }
         return 0
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tvTabla {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMarcaPrecio", for: indexPath) as! marcaprecioCell

            let dato = datos[indexPath.row]
            cell.marca.text = dato.marca
            cell.precio.text = dato.precio

            return cell
        } else if tableView == tvTelefonos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTelefonos", for: indexPath) as! telefonosCell

            let telefono = telefonos[indexPath.row]
            cell.telefono.text = telefono
            cell.telefono.text = !telefono.isEmpty ? telefono : "Sin especificar"
            cell.btnLlamar.isHidden = telefono.isEmpty

            return cell
        } else if tableView == tvHorarios {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHorarios", for: indexPath) as! horariosCell

            let horario = horarios[indexPath.row]
            cell.tvHorarios.text = horario

            return cell
        } else if tableView == tvFormasPago {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFormasPago", for: indexPath) as! formaspagoCell

            let formaPago = formasPago[indexPath.row]
            cell.tvFormaPago.text = formaPago

            return cell
        }

        return UITableViewCell()
    }
    
    @IBAction func mostrarInformacionHorario(_ sender: Any) {
        if hInformacionHorario.constant == 0 {
            hInformacionHorario.constant = 938
            vInformacionHorario.isHidden = false
            ivInfoHorario.image = UIImage(systemName: "chevron.up")


            
        } else {
            hInformacionHorario.constant = 0
            vInformacionHorario.isHidden = true
            ivInfoHorario.image = UIImage(systemName: "chevron.down")
        }
        
    }
    
    
    @IBAction func mostrarCalificaciones(_ sender: Any) {
        
    }
    
    @IBAction func reportarEstablecimiento(_ sender: Any) {
        
    }
    
    //APIS
    private func detalleEstablecimiento() {
          let ac = APICaller()
          self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
          ac.GettDetalleBalonGas(codigoOsinergmin, completion: { (success, result, code) in
              self.hideActivityIndicatorWithText()
              debugPrint(result!)
              if (success && code == 200) {
                  if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                      do {
                          let json = try JSON(data: dataFromString)

                          if !json["codigoOsinergmin"].stringValue.isEmpty {
                              self.descripcion.text = json["nombreUnidad"].stringValue
                              self.direccion.text = json["direccion"].stringValue
                              self.latitud = json["latitud"].stringValue
                              self.longitud = json["longitud"].stringValue

                              if let provPais = json["provPais"].stringValue.components(separatedBy: " - ").first {
                                  self.nombreDistrito.text = provPais
                              }

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
                              
                              
                              if let listaProductos = json["listaProductos"].array {
                                  var datos: [(marca: String, precio: String)] = []

                                  for productoJSON in listaProductos {
                                      if let nombreProducto = productoJSON["nombreProducto"].string,
                                         let precio = productoJSON["precio"].string {
                                          let partes = nombreProducto.components(separatedBy: " - ")
                                          
                                          if partes.count == 2 {
                                              let marca = partes[1]
                                              let cantidad = partes[0].replacingOccurrences(of: "BALÓN DE GAS DE ", with: "")
                                              let nombreTransformado = "\(marca) - \(cantidad)"
                                              
                                              datos.append((marca: nombreTransformado, precio: precio))
                                          } else {
                                              datos.append((marca: nombreProducto, precio: precio))
                                          }
                                      }
                                  }

                                  self.datos = datos

                                  // Luego de cargar los datos, recarga la tabla para que se actualicen
                                  DispatchQueue.main.async {
                                      self.tvTabla.reloadData()
                                      self.tvTelefonos.reloadData()

                                  }
                              }
                          } else {
                              self.displayMessage = json["Mensaje"].stringValue
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
    
    
    @IBAction func unwindToPreviousViewController(_ sender: UIStoryboardSegue) {
        // Realizar la navegación de regreso a BalonGasMapaViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mostrarViewReporte(_ sender: Any) {
        self.performSegue(withIdentifier: "sgReportar", sender: self)

        
    }
    
    @IBAction func calificar(_ sender: Any) {
        self.performSegue(withIdentifier: "sgCalificar", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgReportar") {
            let vc = segue.destination as! ListaReportarBalonViewController
            vc.vBalonDetalle = self
        }
        if (segue.identifier == "sgCalificar") {
            let vc = segue.destination as! CalificarViewController
            //vc.vBalonDetalle = self
        }
      
    }
}

