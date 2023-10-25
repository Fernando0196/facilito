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
import DropDown


class BalonGasMapaViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
        
    var vIniciarSesion: IniciarSesionViewController!
    var jsonUsuario: IniciarSesionViewController? = nil

        var locationManager = CLLocationManager()
    var userLocationMarker: GMSMarker?

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
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    @IBOutlet weak var lblCombustible: UILabel!
    @IBOutlet weak var lblKm: UILabel!

    
    @IBOutlet weak var lblGalon: UILabel!
    
    @IBOutlet weak var hDetalleBalonGas: NSLayoutConstraint!
    @IBOutlet weak var hBtnDetalleBalonGas: NSLayoutConstraint!
    
    
    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var filtroDistrito: String = ""
   
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
    var telefonoBalon: String = ""
    
    var balonPesoFiltro: String = ""
    var establecimientosKmFiltro: String = ""
    var ratingFiltro: String = ""
    var distritoFiltro: String = ""
    var codProvincia: String = ""
    var codDepartamento: String = ""
    
    var dropDown = DropDown()
    var distritos: [String] = []
    var nombreDistrito: String = ""
    var codigoDistrito: String = ""

    @IBOutlet weak var tfDistrito: UITextField!
    
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
        lblGalon.roundLabel()
        btnDistrito.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        filtroDistrito = "1"
        
        btn3KG.addShadowOnBottom()
        btn5KG.addShadowOnBottom()
        btn10KG.addShadowOnBottom()
        btn15KG.addShadowOnBottom()
        btn45KG.addShadowOnBottom()
        btn10proximas.addShadowOnBottom()
        btn30proximas.addShadowOnBottom()
        btnGasolinera2km.addShadowOnBottom()
        btnGasolinera3km.addShadowOnBottom()
        btnCali1.addShadowOnBottom()
        btnCali2.addShadowOnBottom()
        btnCali3.addShadowOnBottom()
        btnCali4.addShadowOnBottom()
        btnCali5.addShadowOnBottom()
        

        vDetalleGrifo.roundView()
        vDetalleGrifo.addCardShadow()

        //ivBalonGas.cornerRadius = 23
        ivBalonGas.layer.cornerRadius = ivBalonGas.frame.size.width / 2
        ivBalonGas.clipsToBounds = true
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

        btnCall.addCardShadow()
        self.establecimientosKmFiltro = "20C"
        self.ratingFiltro = "5"
        mapView.addShadowToTop()

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
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
            print("Longitud: \(location.coordinate.longitude)")
              print("Latitud: \(location.coordinate.latitude)")
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Imprime la longitud y latitud
        print("Longitud: \(location.coordinate.longitude)")
        print("Latitud: \(location.coordinate.latitude)")
        longitud = String(location.coordinate.longitude)
        latitud = String(location.coordinate.latitude)
        //obtenerCoordenadas()

        // Si el marcador de ubicación del usuario aún no se ha creado, créalo.
        if userLocationMarker == nil {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))

            let marker = GMSMarker(position: location.coordinate)
            marker.title = "Mi ubicación"
            marker.snippet = "Aquí estoy"
            marker.icon = UIImage(named: "marker")
            marker.map = mapView

            // Asigna el marcador del usuario a la variable userLocationMarker
            userLocationMarker = marker
        }
    }
    var isFirstMapLoad = true

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        if isFirstMapLoad {
            guard let userLocation = locationManager.location else {
                return
            }
            
            let userLatitude = userLocation.coordinate.latitude
            let userLongitude = userLocation.coordinate.longitude
            
            let camera = GMSCameraPosition.camera(withLatitude: userLatitude, longitude: userLongitude, zoom: 14)
            mapView.camera = camera
            
            self.latitud = String(format: "%.6f", userLatitude)
            self.longitud = String(format: "%.6f", userLongitude)
            obtenerCoordenadas()
            isFirstMapLoad = false
            
        } else {
            if filtroDistrito == "1" {
                let centerLatitude = cameraPosition.target.latitude
                let centerLongitude = cameraPosition.target.longitude
                print("Latitud del centro del mapa: \(centerLatitude)")
                print("Longitud del centro del mapa: \(centerLongitude)")
                
                self.latitud = String(format: "%.6f", centerLatitude)
                self.longitud = String(format: "%.6f", centerLongitude)
                self.ubigeo = "-"
                self.listarBalonGas()
            }
            
        }
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
                             self.codDepartamento = String(self.ubigeo.prefix(2))
                             self.codProvincia = String(self.ubigeo.suffix(4).prefix(2)) 
                             
                             
                             print("codDepartamento: " + self.codDepartamento)
                             print("codProvincia: " + self.codProvincia)
                             
                             //self.listarDistritos() REVISAR URL 
                             self.ubigeo = "-"
                             self.listarBalonGas()
                             
                         }
                          else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obetener, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obetener, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obetener, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }

        })
    }
    
    var codigoDistritoMap = [String: String]()
    private func listarDistritos() {
        let codDpto = self.codDepartamento
        let codProv = self.codProvincia

        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarDistritos(codDpto, codProv) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)

                        // Limpia la lista de distritos antes de agregar nuevos valores
                        self.distritos.removeAll()
                        self.distritos.append("TODOS")
                        self.codigoDistritoMap["TODOS"] = "-"
                        if !json["distritos"].arrayValue.isEmpty {
                            let jRecords = json["distritos"].arrayValue
                            for subJson in jRecords {
                                let codigo = subJson["codDist"].stringValue
                                let nombreDistrito = subJson["distrito"].stringValue.trimmingCharacters(in: .whitespaces)

                                if !self.distritos.contains(nombreDistrito) {
                                    self.distritos.append(nombreDistrito)
                                }
                                self.codigoDistritoMap[nombreDistrito] = codigo
                            }
                            self.dropDown.anchorView = self.btnDistrito
                            self.dropDown.dataSource = self.distritos
                            self.dropDown.bottomOffset = CGPoint(x: 0, y: (self.dropDown.anchorView?.plainView.bounds.height)!)
                            self.dropDown.topOffset = CGPoint(x: 0, y: -(self.dropDown.anchorView?.plainView.bounds.height)!)
                            self.dropDown.direction = .bottom
                            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                //self.btnDistrito.setTitle(self.distritos[index] + " ", for: .normal)
                                self.tfDistrito.text = self.distritos[index]
                                let selectedNombreDistrito = self.distritos[index]
                                
                                if let selectedCodigoDistrito = codigoDistritoMap[selectedNombreDistrito] {
                                    self.codigoDistrito = selectedCodigoDistrito
                                    self.nombreDistrito = selectedNombreDistrito
                                    print("Código del distrito seleccionado: \(self.codigoDistrito)")
                                    filtrarPorDistrito()
                                }
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
        }
    }

    @IBAction func mostrarDistritos(_ sender: Any) {
        dropDown.show()
    }
    
    
    private func listarBalonGas() {
        
        
        let metodo = 1
        if metodo == 1 {
             categoria = "010"

            distancia = self.establecimientosKmFiltro
            if distancia == "-" {
                distancia = "20C"
            }

             idFamiliaGrifo = "-1"
             marca = "-"
             tiempo = "0"
             tipoPago = "-"
             variable = "-"

            calificacionFiltro = self.ratingFiltro
            if calificacionFiltro == "-" {
                calificacionFiltro = "5"
            }

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
                            self.balonGas.removeAll()
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
                                    f.telefono = subJson["telefono"].stringValue
                                    let precioString = subJson["precio"].stringValue // Obtener el valor del precio como cadena

                                    if let precio = Double(precioString) {
                                        let precioFormateado = String(format: "%.2f", precio)
                                        f.precio = precioFormateado
                                    } else {
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
                                print("Total balon: \(self.balonGas.count)")
                                self.mapView.clear()
                                let userLocationMarker = self.userLocationMarker

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
                                        priceButton.backgroundColor = UIColor(hex: 0xF8BD00)
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

                                // Vuelve a agregar el marcador de ubicación del usuario actual
                                if let userMarker = userLocationMarker {
                                    userMarker.map = self.mapView
                                }


                                
                                
                            }
                             else {
                                 self.displayMessage = "No se pudo obtener, vuelve a intentar"
                               self.performSegue(withIdentifier: "sgDM", sender: self)
                           }
                       }  catch {
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


            }
    }

    // Función para mostrar los detalles del balón al tocar el marcador
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let index = self.balonGas.firstIndex(where: { $0.tituloMenu == marker.title }) else {
            return false
        }
        
        let balon = self.balonGas[index]
        
        hDetalleBalonGas.constant = 95
        vDetalleGrifo.isHidden = false
        btnVerDetalle.isHidden = false
        btnCall.isHidden = false
        hBtnDetalleBalonGas.constant = 95
        
        lblNombre.text = balon.tituloMenu
        
        let doubleValue = Double(balon.valoracion)
        cosmosContainerView.rating = doubleValue ?? 0.0
        
        lblKm.text = balon.km + " km"
        lblCombustible.text = balon.nombreProducto + " a: "
        lblGalon.text = " S/ " + balon.precio + " "

        let priceButton = UIButton()
        priceButton.setTitle(balon.precio, for: .normal)
        priceButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        priceButton.setTitleColor(.white, for: .normal)

        if (Double(balon.precio) == self.precioMayor) {
            lblGalon.backgroundColor = UIColor(hex: 0xFE3A46)
        }
        else if (Double(balon.precio) == self.precioMenor) {
            lblGalon.backgroundColor = UIColor(hex: 0x029F1D)
        }
        else {
            lblGalon.backgroundColor = UIColor(hex: 0xF8BD00)
        }
        
        
        
        
        //para enviar al detalle
        self.codigoOsinergmin = balon.codigoOsinergmin
        self.nombreEstablecimiento = balon.tituloMenu
        self.valoracionEstablecimiento = balon.valoracion
        self.direccionEstablecimiento =  balon.direccion
        self.telefonoBalon = balon.telefono
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
    

    @IBAction func llamar(_ sender: Any) {
        // Verifica si self.telefonoBalon no es nulo ni vacío
        if !self.telefonoBalon.isEmpty {
            self.realizarLlamada(telefono: self.telefonoBalon)
        } else {
            // Manejar la situación en la que self.telefonoBalon está vacío
            // Puedes mostrar un mensaje de error o tomar alguna otra acción apropiada.
        }
    }
    
    @IBAction func botonPresionadoBalon(_ sender: UIButton) {
        // Desactivar todos los botones
        btn3KG.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btn5KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn10KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn15KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn45KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn3KG.tintColor = UIColor(hex: 0x67738F)
        btn5KG.tintColor = UIColor(hex: 0x67738F)
        btn10KG.tintColor = UIColor(hex: 0x67738F)
        btn15KG.tintColor = UIColor(hex: 0x67738F)
        btn45KG.tintColor = UIColor(hex: 0x67738F)

        // Activar el botón seleccionado
        sender.backgroundColor = UIColor(hex: 0x000090)
        sender.tintColor = UIColor.white
        
    }
    
    
    @IBAction func botonPresionadEstablecimiento(_ sender: UIButton) {
        for boton in [btn10proximas, btn30proximas, btnGasolinera2km, btnGasolinera3km] {
            boton?.backgroundColor = UIColor(hex: 0xF5F6FB)
            boton?.tintColor = UIColor(hex: 0x67738F)
        }

        if sender == btn10proximas {
            btn10proximas.backgroundColor = UIColor(hex: 0x000090)
            btn10proximas.tintColor = UIColor.white
            establecimientosKmFiltro = "20C"
        } else if sender == btn30proximas {
            btn30proximas.backgroundColor = UIColor(hex: 0x000090)
            btn30proximas.tintColor = UIColor.white
            establecimientosKmFiltro = "30C"
        } else if sender == btnGasolinera2km {
            btnGasolinera2km.backgroundColor = UIColor(hex: 0x000090)
            btnGasolinera2km.tintColor = UIColor.white
            establecimientosKmFiltro = "02K"
        } else if sender == btnGasolinera3km {
            btnGasolinera3km.backgroundColor = UIColor(hex: 0x000090)
            btnGasolinera3km.tintColor = UIColor.white
            establecimientosKmFiltro = "03K"
        }
        print("Valor de establecimientosKmFiltro:", establecimientosKmFiltro)
        listarBalonGas()

    }
   
    
    @IBAction func botonPresionadCalificacion(_ sender: UIButton) {
        let buttons = [btnCali1, btnCali2, btnCali3, btnCali4, btnCali5]
        for button in buttons {
            if let unwrappedButton = button {
                unwrappedButton.backgroundColor = UIColor(hex: 0xF5F6FB)
                unwrappedButton.tintColor = UIColor(hex: 0x67738F)
            }
        }

        sender.backgroundColor = UIColor(hex: 0x000090)
        sender.tintColor = UIColor.white

        if sender == btnCali1 {
            ratingFiltro = "1"
        } else if sender == btnCali2 {
            ratingFiltro = "2"
        } else if sender == btnCali3 {
            ratingFiltro = "3"
        } else if sender == btnCali4 {
            ratingFiltro = "4"
        } else if sender == btnCali5 {
            ratingFiltro = "5"
        }
        print("Valor de ratingFiltro:", ratingFiltro)
        listarBalonGas()
    }
    
    
    @IBAction func borrarFiltros(_ sender: Any) {
        ratingFiltro = "-"
        establecimientosKmFiltro = "-"
        categoria = "010"
        filtroDistrito = "1"
        distancia = "20C"
        codigoDistrito = "-"
        tfDistrito.text = "Distritos"
        btn3KG.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btn5KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn10KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn15KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn45KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn3KG.tintColor = UIColor(hex: 0x67738F)
        btn5KG.tintColor = UIColor(hex: 0x67738F)
        btn10KG.tintColor = UIColor(hex: 0x000090)
        btn15KG.tintColor = UIColor(hex: 0x67738F)
        btn45KG.tintColor = UIColor(hex: 0x67738F)
        
        for boton in [btn10proximas, btn30proximas, btnGasolinera2km, btnGasolinera3km] {
            boton?.backgroundColor = UIColor(hex: 0xF5F6FB)
            boton?.tintColor = UIColor(hex: 0x67738F)
        }
        let buttons = [btnCali1, btnCali2, btnCali3, btnCali4, btnCali5]
        for button in buttons {
            if let unwrappedButton = button {
                unwrappedButton.backgroundColor = UIColor(hex: 0xF5F6FB)
                unwrappedButton.tintColor = UIColor(hex: 0x67738F)
            }
        }
        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            print("Longitud: \(location.coordinate.longitude)")
              print("Latitud: \(location.coordinate.latitude)")
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
        
        
        listarBalonGas()
    }
    

    private func filtrarPorDistrito() {
        
        
        _ = self.codDepartamento
        _ = self.codProvincia
        let codigoDist = self.codigoDistrito
        
        if codigoDistrito == "-"{
            filtroDistrito = "1"
            self.ubigeo = "-"
            listarBalonGas()

        }
        else{
            self.ubigeo = self.codDepartamento + self.codProvincia + codigoDist
            filtroDistrito = "2"
            listarBalonGas()
        }

        
    }

    
}
