//
//  BalonGasMapaViewController.swift
//  facilito
//
//  Created by iMac Mario on 24/08/23.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import Cosmos

class BalonGasMapaViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
        
    var vIniciarSesion: IniciarSesionViewController!
    var jsonUsuario: IniciarSesionViewController? = nil

        var locationManager = CLLocationManager()

        @IBOutlet weak var btnMenuUsuario: UIButton!
        @IBOutlet weak var btnBack: UIButton!
        @IBOutlet weak var mapView: GMSMapView!
        @IBOutlet weak var btnLista: UIButton!
        @IBOutlet weak var btnMiUbicacion: UIButton!
        
        @IBOutlet weak var btnAbrirFiltroExpan: UIButton!
        @IBOutlet weak var btnCerarFiltroExpan: UIButton!
        //Balón
        @IBOutlet weak var btn3KG: UIButton!
        @IBOutlet weak var btn5KG: UIButton!
        @IBOutlet weak var btn10KG: UIButton!
        @IBOutlet weak var btn15KG: UIButton!
        @IBOutlet weak var btn45KG: UIButton!
    
        //Establecimientos
        @IBOutlet weak var btn10proximas: UIButton!
        @IBOutlet weak var btn30proximas: UIButton!
        @IBOutlet weak var btnGasolinera2km: UIButton!
        @IBOutlet weak var btnGasolinera3km: UIButton!
        
        //Calificación
        @IBOutlet weak var btnCali1: UIButton!
        @IBOutlet weak var btnCali2: UIButton!
        @IBOutlet weak var btnCali3: UIButton!
        @IBOutlet weak var btnCali4: UIButton!
        @IBOutlet weak var btnCali5: UIButton!
        
        @IBOutlet weak var btnDistrito: UIButton!
        
        @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
        @IBOutlet weak var vFiltroExpan: UIView!
    
    @IBOutlet weak var vDetalleGrifo: UIView!
    @IBOutlet weak var ivBalonGas: UIImageView!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var btnVerDetalle: UIButton!
    
    @IBOutlet weak var tvNombre: UITextView!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    @IBOutlet weak var lblCombustible: UILabel!
    @IBOutlet weak var lblKm: UILabel!

    
    @IBOutlet weak var lblGalon: UILabel!
    
    @IBOutlet weak var hDetalleBalonGas: NSLayoutConstraint!
    @IBOutlet weak var hBtnDetalleBalonGas: NSLayoutConstraint!
    
    
    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var categoria: String = ""
    var distancia: String = ""
    var idFamiliaGrifo: String = ""
    var marca: String = ""
    var tiempo: String = ""
    var tipoPago: String = ""
    var variable: String = ""
    var calificacionFiltro: String = ""
    var calificacion: Double = 0.0
    var minPrecio: Double = 0.0
    var maxPrecio: Double = 999.0

    var tituloMenu: String = ""
    var balonGas: [BalonGasMenu] = [BalonGasMenu]()
    var df : BalonGasMenu!
    
    var precioMayor: Double = 0.0
    var precioMenor: Double = 0.0
    var precioBalon: Double = 0.0

    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""

    //Datos USUARIO
    var logueado: Bool = false
    var nroDocumento: String = ""
    var nombreUsua: String = ""
    var apellidoUsua: String = ""
    var correoUsua: String = ""
    var telefonoUsua: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Datos USUARIO
        if let iniciarSesion = self.vIniciarSesion {
            self.logueado = iniciarSesion.jsonUsuario["loginOutRO"]["logueado"].boolValue
            nroDocumento = iniciarSesion.jsonUsuario["loginOutRO"]["nroDocumento"].stringValue
            nombreUsua = iniciarSesion.jsonUsuario["loginOutRO"]["nombre"].stringValue
            apellidoUsua = iniciarSesion.jsonUsuario["loginOutRO"]["apellidos"].stringValue
            correoUsua = iniciarSesion.jsonUsuario["loginOutRO"]["correo"].stringValue
            telefonoUsua = iniciarSesion.jsonUsuario["loginOutRO"]["telefono"].stringValue
            self.jsonUsuario = iniciarSesion
        }



 
        hViewFiltroExpan.constant = 0
        vFiltroExpan.isHidden = true
        btnCerarFiltroExpan.isHidden = true
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnCerarFiltroExpan.roundButton()
        btn3KG.roundButton()
        btn5KG.roundButton()
        btn10KG.roundButton()
        btn15KG.roundButton()
        btn45KG.roundButton()
        btn10proximas.roundButton()
        btn30proximas.roundButton()
        btnGasolinera2km.roundButton()
        btnGasolinera3km.roundButton()
        btnCali1.roundButton()
        btnCali2.roundButton()
        btnCali3.roundButton()
        btnCali4.roundButton()
        btnCali5.roundButton()
        btnLista.roundButton()
        btnMiUbicacion.roundButton()
        



        vDetalleGrifo.roundView()
        ivBalonGas.cornerRadius = 20
        btnCall.roundButton()
        
        //traer al frente view
        if let superview = vDetalleGrifo.superview {
            superview.bringSubviewToFront(vDetalleGrifo)
        }
        if let superview = btnCall.superview {
            superview.bringSubviewToFront(btnCall)
        }
        
        hDetalleBalonGas.constant = 0
        vDetalleGrifo.isHidden = true
        btnVerDetalle.isHidden = true
        btnCall.isHidden = true
        hBtnDetalleBalonGas.constant = 0

    }
    
    @IBAction func motrarFiltroExpan(_ sender: Any) {
        
        if vFiltroExpan.isHidden {
            hViewFiltroExpan.constant = 223.33
            vFiltroExpan.isHidden = false
            btnCerarFiltroExpan.isHidden = false
            btnAbrirFiltroExpan.isHidden = true

        } else {
            btnAbrirFiltroExpan.isHidden = false
            vFiltroExpan.isHidden = true
            btnCerarFiltroExpan.isHidden = true
            hViewFiltroExpan.constant = 0
        }
    }
    
    @IBAction func centrarUbicacion(_ sender: UIButton) {

        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            print("Longitud: \(location.coordinate.longitude)")
              print("Latitud: \(location.coordinate.latitude)")
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
    }
    
    // Función que se llama cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        guard let location = locations.last else { return }
        // Imprime la longitud y latitud
        print("Longitud: \(location.coordinate.longitude)")
        print("Latitud: \(location.coordinate.latitude)")
        longitud = String(location.coordinate.longitude)
        latitud = String(location.coordinate.latitude)
        obtenerCoordenadas()

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
        mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        
        let marker = GMSMarker(position: location.coordinate)

        marker.title = "Mi ubicación"
        marker.snippet = "Aquí estoy"
        marker.icon = UIImage(named: "marker")
        marker.map = mapView

    }
    
    private func obtenerCoordenadas() {
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostConsultarUbigeo(latitud,longitud, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if !json["ubigeo"].stringValue.isEmpty {
                             
                             self.ubigeo = json["ubigeo"].stringValue
                             self.listarBalonGas()
                             
                         }
                          else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }

        })
    }
    
    
    private func listarBalonGas() {
        
        var metodo = 1
        if metodo == 1 {
             categoria = "010"

             distancia = "30C"
            if distancia == "-" {
                distancia = "30C"
            }

             idFamiliaGrifo = "-1"
             marca = "-"
             tiempo = "0"
             tipoPago = "-"
             variable = "-"

             calificacionFiltro = "5"
            if calificacionFiltro == "-" {
                calificacionFiltro = "5"
            }
             calificacion = 0.0

            if let parsedCalificacion = Double(calificacionFiltro) {
                calificacion = parsedCalificacion
            } else {
                calificacion = 0.0
            }

             minPrecio = 0.0
             maxPrecio = 999.0

        }

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.GetListarBalonGas(categoria, latitud, longitud, distancia, idFamiliaGrifo, ubigeo, calificacion, minPrecio, maxPrecio, marca, tipoPago, variable, tiempo) { (success, result, code) in

            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                    if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                        do {
                           let json = try JSON(data: dataFromString)
                           
                            if !json["coordenadas"]["coordenada"].arrayValue.isEmpty {
                                let jRecords = json["coordenadas"]["coordenada"].arrayValue
                                
                                self.precioMenor = jRecords[0]["precio"].doubleValue
                                self.precioMayor = jRecords[0]["precio"].doubleValue
                                print("Menor: \(self.precioMenor)")
                                print("Mayor: \(self.precioMayor)")
                                
                                for (_, subJson) in jRecords.enumerated() {
                                    let f = BalonGasMenu()
                                    
                                    f.codigoOsinergmin = subJson["codigoOsinergmin"].stringValue
                                    f.tituloMenu = subJson["nombreUnidad"].stringValue
                                    f.valoracion = subJson["valorMedio"].stringValue
                                    f.direccion = subJson["direccion"].stringValue
                                    f.km = subJson["distanciaKm"].stringValue
                                    f.nombreProducto = subJson["nombreProducto"].stringValue
                                    f.precioBalonGas = Double(subJson["precio"].stringValue) ?? 0.0
                                    self.precioBalon = Double(subJson["precio"].stringValue) ?? 0.0
                                    
                                    let precioString = subJson["precio"].stringValue // Obtener el valor del precio como cadena

                                    if let precio = Double(precioString) {
                                        // Si es posible convertir el precio a un número, formatear con dos decimales
                                        let precioFormateado = String(format: "S/ %.2f", precio)
                                        f.precio = precioFormateado
                                    } else {
                                        // Manejar el caso en que la conversión a número falla
                                        print("No se pudo convertir el precio a un número válido.")
                                    }
                                    f.latitudBalon = subJson["latitud"].stringValue
                                    f.longitudBalon = subJson["longitud"].stringValue
                                    self.balonGas.append(f)

                                    if self.precioMenor >= subJson["precio"].doubleValue {
                                        self.precioMenor = subJson["precio"].doubleValue
                                        print("Menor: \(self.precioMenor)")
                                    }
                                    if self.precioMayor <= subJson["precio"].doubleValue {
                                        self.precioMayor = subJson["precio"].doubleValue
                                        print("Mayor: \(self.precioMayor)")
                                    }
                                    
                                }
                                
                                
                                
                                for (index, _) in self.balonGas.enumerated() {
                                    let f = self.balonGas[index]
                                    
                                    let latitud = Double(f.latitudBalon) ?? 0.0
                                    let longitud = Double(f.longitudBalon) ?? 0.0

                                    let customMarkerView = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 100))

                                    let iconImageView = UIImageView()
                                    iconImageView.contentMode = .scaleAspectFit
                                    iconImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20) // Cambiar el tamaño del icono
                                    iconImageView.center.x = customMarkerView.center.x
                                    iconImageView.frame.origin.y = 5
                                    customMarkerView.addSubview(iconImageView)

                                    let priceButton = UIButton()
                                    priceButton.setTitle(f.precio, for: .normal)
                                    priceButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
                                    priceButton.setTitleColor(.white, for: .normal)

                                    if (f.precioBalonGas == self.precioMayor) {
                                        priceButton.backgroundColor = UIColor(hex: 0xFE3A46)
                                        iconImageView.image = UIImage(named: "ubi_rojo")
                                    }
                                    else if (f.precioBalonGas == self.precioMenor) {
                                        priceButton.backgroundColor = UIColor(hex: 0x029F1D)
                                        iconImageView.image = UIImage(named: "ubi_verde")
                                    }
                                    else {
                                        priceButton.backgroundColor = UIColor(hex: 0xFE3A46)
                                        iconImageView.image = UIImage(named: "ubi_amarillo")
                                    }

                                    priceButton.layer.cornerRadius = 15
                                    priceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                                    customMarkerView.addSubview(priceButton)

                                    priceButton.translatesAutoresizingMaskIntoConstraints = false

                                    // Configurar restricciones para el botón del precio
                                    priceButton.centerXAnchor.constraint(equalTo: customMarkerView.centerXAnchor).isActive = true
                                    priceButton.centerYAnchor.constraint(equalTo: customMarkerView.centerYAnchor, constant: -15).isActive = true
                                    priceButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
                                    priceButton.heightAnchor.constraint(equalToConstant: 32).isActive = true

                                    iconImageView.translatesAutoresizingMaskIntoConstraints = false
                                    // Configurar restricciones para el icono debajo del botón
                                    iconImageView.centerXAnchor.constraint(equalTo: customMarkerView.centerXAnchor).isActive = true
                                    iconImageView.topAnchor.constraint(equalTo: priceButton.bottomAnchor, constant: 0).isActive = true

                                    let marker = GMSMarker()
                                    marker.position = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                                    marker.title = f.tituloMenu
                                    marker.iconView = customMarkerView
                                    marker.map = self.mapView

                                }


                                
                                
                            }
                             else {
                               self.displayMessage = json["Mensaje"].stringValue
                               self.performSegue(withIdentifier: "sgDM", sender: self)
                           }
                       }  catch {
                            self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } else {
                        self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    debugPrint("error")
                    self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            }
    }
    
    // Función para mostrar los detalles del balón al tocar el marcador
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let index = self.balonGas.firstIndex(where: { $0.tituloMenu == marker.title }) else {
            return false
        }
        
        let balon = self.balonGas[index]
        
        hDetalleBalonGas.constant = 136
        vDetalleGrifo.isHidden = false
        btnVerDetalle.isHidden = false
        btnCall.isHidden = false
        hBtnDetalleBalonGas.constant = 136
        
        tvNombre.text = balon.tituloMenu
        
        let doubleValue = Double(balon.valoracion)
        cosmosContainerView.rating = doubleValue ?? 0.0
        
        lblKm.text = balon.km + " km"
        lblCombustible.text = balon.nombreProducto + " a: "
        lblGalon.text = " " + balon.precio + " Galón"

        //para enviar al detalle
        self.codigoOsinergmin = balon.codigoOsinergmin
        self.nombreEstablecimiento = balon.tituloMenu
        self.valoracionEstablecimiento = balon.valoracion
        self.direccionEstablecimiento =  balon.direccion
        
        return true
    }
    
    @IBAction func btnLlamar(_ sender: Any) {
        let alertController = UIAlertController(title: "Confirmar Llamada", message: "¿Deseas realizar la llamada?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let llamarAction = UIAlertAction(title: "Llamar", style: .default) { (_) in
            // Coloca aquí el código para realizar la llamada
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(llamarAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnVerDetalle(_ sender: Any) {
        self.performSegue(withIdentifier: "sgDetalleBalonGas", sender: self)
        
    }
    
    @IBAction func btnLista(_ sender: Any) {
        self.performSegue(withIdentifier: "sgLista", sender: self)

    }
    
    @IBAction func mostrarTramites(_ sender: Any) {
         if logueado == true {
             self.performSegue(withIdentifier: "sgTramites", sender: self)
         } else {
             let alertController = UIAlertController(title: "Aviso", message: "¿Desea iniciar sesión para acceder a los trámites?", preferredStyle: .alert)
             
             let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
             alertController.addAction(cancelAction)
             
             let aceptarAction = UIAlertAction(title: "Aceptar", style: .default) { (action:UIAlertAction) in
                 self.performSegue(withIdentifier: "sgInicio", sender: self)
             }
             alertController.addAction(aceptarAction)
             self.present(alertController, animated: true, completion: nil)
         }
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgDetalleBalonGas") {
            let vc = segue.destination as! BalonGasDetalleViewController
            vc.vBalonGasMapa = self
            //
            
        }
        if (segue.identifier == "sgLista") {
            let vc = segue.destination as! ListaBalonGasViewController
            vc.vBalonGasMapa = self
            //
            
        }
        if (segue.identifier == "sgTramites") {
            let vc = segue.destination as! TramitesViewController
            vc.vIniciarSesion = self
            //
            
        }
        if (segue.identifier == "sgInicio") {
            let vc = segue.destination as! InicioViewController
            //
            
        }
        if (segue.identifier == "sgMenuHamburguesa") {
            let vc = segue.destination as! MenuPrincipalViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
   
            
        }
    }
    
    
    @IBAction func btnMostrarMenuHamburguesa(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgMenuHamburguesa", sender: self)
        
    }
    

    
}
