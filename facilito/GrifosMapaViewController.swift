//
//  GrifosMapaViewController.swift
//  facilito
//
//  Created by iMac Mario on 23/08/23.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import DropDown
import Cosmos
import GooglePlaces


class GrifosMapaViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var vIniciarSesion: IniciarSesionViewController!
    
    var locationManager = CLLocationManager()
    var locManager = CLLocationManager()
    var userLocationMarker: GMSMarker?

    @IBOutlet weak var btnMenuUsuario: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnLista: UIButton!
    @IBOutlet weak var btnMiUbicacion: UIButton!
    
    //Combustible
    @IBOutlet weak var btng84: UIButton!
    @IBOutlet weak var btnglp: UIButton!
    @IBOutlet weak var btngnv: UIButton!
    @IBOutlet weak var btndiesel: UIButton!
    @IBOutlet weak var btngRegular: UIButton!
    @IBOutlet weak var btngPremium: UIButton!
    
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
    @IBOutlet weak var btnCerrarFiltro: UIButton!
    @IBOutlet weak var btnAbrirFiltroExpan: UIButton!
    
    @IBOutlet weak var btnDistrito: UIButton!
    
    @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
    @IBOutlet weak var vFiltroExpan: UIView!
    @IBOutlet weak var tfDistrito: UITextField!
    
    @IBOutlet weak var vDetalleGrifo: UIView!
    @IBOutlet weak var btnIconGrifo: UIButton!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var lblCombustible: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var btnRuta: UIButton!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    @IBOutlet weak var hDetalleGrifo: NSLayoutConstraint!

    @IBOutlet weak var vDetalleRuta: UIView!
    @IBOutlet weak var lblMinutosEstimado: UILabel!
    @IBOutlet weak var lblKmEstimado: UILabel!
    @IBOutlet weak var lblHoraLlegadaEstimado: UILabel!
    
    
    var grifos: [GrifosMapaMenu] = [GrifosMapaMenu]()

    var dropDown = DropDown()
    var distritos: [String] = []
    var nombreDistrito: String = ""
    var codigoDistrito: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var latitud: String = ""
    var longitud: String = ""
    var latitudUbiActual: String = ""
    var longitudUbiActual: String = ""
    var ubigeo: String = ""
    var filtroDistrito: String = ""
    var codProvincia: String = ""
    var codDepartamento: String = ""
    var categoria: String = ""
    var distancia: String = ""
    var idFamiliaGrifo: String = ""
    var marca: String = ""
    var tiempo: String = ""
    var tipoPago: String = ""
    var variable: String = ""
    var calificacionFiltro: String = ""
    var minPrecio: Double = 0.0
    var maxPrecio: Double = 999.0
    var ratingFiltro: String = ""
    var establecimientosKmFiltro: String = ""
    var precioMayor: String = ""
    var precioMenor: String = ""
    var precioGrifo: String = ""
    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var routeOverlays: [GMSPolyline] = []
    var tiempoEstimado: String = ""
    var knEstimado: String = ""
    var horaLlegadaEstiamdo: String = ""
    var latitudRuta: String = ""
    var longitudRuta: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        filtroDistrito = "1"
        

        btnCerrarFiltro.isHidden = true
        btnCerrarFiltro.roundButton()
        lblPrecio.roundLabel()
        vDetalleGrifo.roundView()
        vDetalleGrifo.addCardShadow()
        vDetalleRuta.roundView()
        vDetalleRuta.addCardShadow()
        btnIconGrifo.roundButton()
        btnRuta.roundButton()
        btnRuta.addCardShadow()
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btng84.roundButton()
        btnglp.roundButton()
        btngnv.roundButton()
        btndiesel.roundButton()
        btngRegular.roundButton()
        btngPremium.roundButton()
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

        hViewFiltroExpan.constant = 0
        vFiltroExpan.isHidden = true
        
        hDetalleGrifo.constant = 0
        vDetalleGrifo.isHidden = true
        vDetalleRuta.isHidden = true
        //btnVerDetalle.isHidden = true
        btnRuta.isHidden = true
        ratingFiltro = "-"
        //hBtnDetalleBalonGas.constant = 0
    }
    
    @IBAction func motrarFiltroExpan(_ sender: Any) {
        
        if vFiltroExpan.isHidden {
            hViewFiltroExpan.constant = 223.33
            vFiltroExpan.isHidden = false
            btnCerrarFiltro.isHidden = false
            btnAbrirFiltroExpan.isHidden = true

        } else {
            btnAbrirFiltroExpan.isHidden = false
            vFiltroExpan.isHidden = true
            btnCerrarFiltro.isHidden = true
            hViewFiltroExpan.constant = 0
        }
    }
    
    @IBAction func centrarUbicacion(_ sender: UIButton) {
        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
    }
    func obtenerUbicacionActual() {

        if let currentLocation = locManager.location {

            latitud = String(currentLocation.coordinate.latitude)
            longitud = String(currentLocation.coordinate.longitude)
            self.ubigeo = "-"
            self.listarGrifos()
            
        } else {
            print("No se pudo obtener la ubicación actual.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        print("Longitud: \(location.coordinate.longitude)")
        print("Latitud: \(location.coordinate.latitude)")
        longitud = String(location.coordinate.longitude)
        latitud = String(location.coordinate.latitude)
        //obtenerCoordenadas()

        if userLocationMarker == nil {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
            self.latitudUbiActual = latitud
            self.longitudUbiActual = longitud
            let marker = GMSMarker(position: location.coordinate)
            marker.title = "Mi ubicación"
            marker.snippet = "Aquí estoy"
            
            marker.icon = UIImage(named: "marker")
            marker.map = mapView
            userLocationMarker = marker
        }
    }
    
    var isFirstMapLoad = true
    var isPanningMap = false

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if !isPanningMap {
            vDetalleGrifo.isHidden = true
            hDetalleGrifo.constant = 0
            vDetalleRuta.isHidden = true
            clearRoutes()

        }
            isPanningMap = false
    }
    
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
                if vDetalleGrifo.isHidden {
                    let centerLatitude = cameraPosition.target.latitude
                    let centerLongitude = cameraPosition.target.longitude
                    print("Latitud del centro del mapa: \(centerLatitude)")
                    print("Longitud del centro del mapa: \(centerLongitude)")
                    
                    self.latitud = String(format: "%.6f", centerLatitude)
                    self.longitud = String(format: "%.6f", centerLongitude)
                    self.ubigeo = "-"
                    self.listarGrifos()
                }
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
                         
                         if !json["empresaConcesionariaOutRO"]["ubigeo"].stringValue.isEmpty {
                             
                             self.ubigeo = json["empresaConcesionariaOutRO"]["ubigeo"].stringValue
                             self.codDepartamento = String(self.ubigeo.prefix(2))
                             self.codProvincia = String(self.ubigeo.suffix(4).prefix(2))
                             
                             print("codDepartamento: " + self.codDepartamento)
                             print("codProvincia: " + self.codProvincia)
                             
                             //self.listarDistritos() REVISAR URL
                             //self.ubigeo = "-"
                             self.listarGrifos()
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
                                print("Distrito seleccionado: \(self.tfDistrito.text)")

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
    
    private func filtrarPorDistrito() {
        
        _ = self.codDepartamento
        _ = self.codProvincia
        let codigoDist = self.codigoDistrito
        
        if codigoDistrito == "-"{
            filtroDistrito = "1"
            self.ubigeo = "-"
            listarGrifos()

        }
        else {
            self.ubigeo = self.codDepartamento + self.codProvincia + codigoDist
            filtroDistrito = "2"
            listarGrifos()
        }

    }
    
    private func listarGrifos() {
        
        self.grifos.removeAll()
        print("Limpio: \(self.grifos.count)")

        let metodo = 1
        if metodo == 1 {
            
            let categoria = "7"
            let preferencesFiltro = UserDefaults.standard
            let combustibleF = preferencesFiltro.string(forKey: "combustibleF") ?? "002"
            
            let latitud1 = String(latitud)
            let longitud1 = String(longitud)
            
            var pordefecto: String
            if let distanciaF = UserDefaults.standard.string(forKey: "distanciaF"), distanciaF != "-" {
                pordefecto = distanciaF
            } else {
                pordefecto = "20C"
            }
            
            let numero = "-1"
            let latitud2 = String(latitud)
            let longitud2 = String(longitud)
            
            let calificacionFiltro = ratingFiltro


        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)

            ac.GetListarGrifosMapa(categoria: categoria, latitud1: latitud1, longitud1: longitud1, pordefecto: pordefecto, numero: numero, latitud2: latitud2, longitud2: longitud2, calificacionFiltro: calificacionFiltro, ubigeo: ubigeo) { (success, result, code) in
                self.hideActivityIndicatorWithText()
                if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if !json["coordenadas"]["coordenada"].arrayValue.isEmpty {
                            let jRecords = json["coordenadas"]["coordenada"].arrayValue
                            
                            // Procesar los datos y actualizar la vista
                            self.precioMenor = jRecords[0]["precio"].stringValue
                            self.precioMayor = jRecords[0]["precio"].stringValue
                            
                            for (_, subJson) in jRecords.enumerated() {
                                let f = GrifosMapaMenu()
                                //CREAR EL MENÚ PARA GRIFOS
                                f.codigoOsinergmin = subJson["codigoOsinergmin"].stringValue
                                f.tituloMenu = subJson["nombreUnidad"].stringValue
                                f.valoracion = subJson["valorMedio"].stringValue
                                f.direccion = subJson["direccion"].stringValue
                                f.km = subJson["distanciaKm"].stringValue
                                f.nombreProducto = subJson["nombreProducto"].stringValue
                                f.precioGrifo = subJson["precio"].stringValue
                                self.precioGrifo = subJson["precio"].stringValue
                                
                                let precioString = subJson["precio"].stringValue // Obtener el valor del precio como cadena

                                if let precio = Double(precioString) {
   
                                    let precioFormateado = String(format: "S/ %.2f", precio)
                                    f.precio = precioFormateado
                                } else {
                                    print("No se pudo convertir el precio a un número válido.")
                                }
                                f.latitudGrifo = subJson["latitud"].stringValue
                                f.longitudGrifo = subJson["longitud"].stringValue
                                self.grifos.append(f)

                                if self.precioMenor >= subJson["precio"].stringValue {
                                    self.precioMenor = subJson["precio"].stringValue
                                }
                                if self.precioMayor <= subJson["precio"].stringValue {
                                    self.precioMayor = subJson["precio"].stringValue
                                }
                            }
                            print("Total grifos: \(self.grifos.count)")
                            self.mapView.clear()
                            let userLocationMarker = self.userLocationMarker
                            for (index, _) in self.grifos.enumerated() {
                                let f = self.grifos[index]
                                
                                let latitud = Double(f.latitudGrifo) ?? 0.0
                                let longitud = Double(f.longitudGrifo) ?? 0.0

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

                                if (f.precioGrifo == self.precioMayor) {
                                    priceButton.backgroundColor = UIColor(hex: 0xFE3A46)
                                    iconImageView.image = UIImage(named: "ubi_rojo")
                                    print("ROJO")

                                }
                                else if (f.precioGrifo == self.precioMenor) {
                                    priceButton.backgroundColor = UIColor(hex: 0x029F1D)
                                    iconImageView.image = UIImage(named: "ubi_verde")
                                    print("VERDE")

                                }
                                else {
                                    priceButton.backgroundColor = UIColor(hex: 0xF8BD02)
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
                                marker.title = f.codigoOsinergmin
                                marker.iconView = customMarkerView
                                marker.map = self.mapView
                            }

                            // Vuelve a agregar el marcador de ubicación del usuario actual
                            if let userMarker = userLocationMarker {
                                userMarker.map = self.mapView
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
            }
        }
    
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let apiKey = "AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo"  // Reemplaza con tu clave de API de Google Maps
        guard let index = self.grifos.firstIndex(where: { $0.codigoOsinergmin == marker.title }) else {
            return false
        }
        clearRoutes()
        
        var precioMayor = self.grifos[0].precioGrifo
        var precioMenor = self.grifos[0].precioGrifo
        var segundoPrecioMenor = Double.greatestFiniteMagnitude
        var precioPromedio: Double = 0.0

        var ubicacionPrecioMayor: CLLocationCoordinate2D?
        var ubicacionPrecioMenor: CLLocationCoordinate2D?
        var ubicacionSegundoPrecioMenor: CLLocationCoordinate2D?
        var ubicacionPrecioPromedio: CLLocationCoordinate2D?

        var nombrePrecioMayor = self.grifos[0].tituloMenu
        var nombrePrecioMenor = self.grifos[0].tituloMenu
        var nombreSegundoPrecioMenor: String?
        var nombrePrecioPromedio: String?

        var minDiferencia = Double.greatestFiniteMagnitude

        for grifo in self.grifos {
            if let precioGrifo = Double(grifo.precioGrifo), let latitud = Double(grifo.latitudGrifo), let longitud = Double(grifo.longitudGrifo) {
                if precioGrifo > Double(precioMayor)! {
                    precioMayor = grifo.precioGrifo
                    ubicacionPrecioMayor = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                    nombrePrecioMayor = grifo.tituloMenu
                } else if precioGrifo < Double(precioMenor)! {
                    segundoPrecioMenor = Double(precioMenor)!
                    precioMenor = grifo.precioGrifo
                    ubicacionSegundoPrecioMenor = ubicacionPrecioMenor
                    ubicacionPrecioMenor = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                    nombreSegundoPrecioMenor = nombrePrecioMenor
                    nombrePrecioMenor = grifo.tituloMenu
                } else if precioGrifo < segundoPrecioMenor {
                    segundoPrecioMenor = precioGrifo
                    ubicacionSegundoPrecioMenor = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                    nombreSegundoPrecioMenor = grifo.tituloMenu
                }
                precioPromedio += precioGrifo
                let diferencia = abs(precioGrifo - precioPromedio / Double(self.grifos.count))
                if diferencia < minDiferencia {
                    minDiferencia = diferencia
                    nombrePrecioPromedio = grifo.tituloMenu
                    ubicacionPrecioPromedio = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                }
            }
        }
        precioPromedio = precioPromedio / Double(self.grifos.count)

        if let ubicacionPrecioMenor = ubicacionPrecioMenor {
            print("Primer grifo con precio menor:")
            print("Nombre: \(nombrePrecioMenor)")
            print("Precio: \(precioMenor)")
            print("Ubicación: Latitud \(ubicacionPrecioMenor.latitude), Longitud \(ubicacionPrecioMenor.longitude)")
        }

        if let ubicacionSegundoPrecioMenor = ubicacionSegundoPrecioMenor {
            print("Segundo grifo con precio menor:")
            print("Nombre: \(nombreSegundoPrecioMenor)")
            print("Precio: \(segundoPrecioMenor)")
            print("Ubicación: Latitud \(ubicacionSegundoPrecioMenor.latitude), Longitud \(ubicacionSegundoPrecioMenor.longitude)")
        }

        let grifoSeleccionado = self.grifos[index]

        if let latitudGrifoSeleccionado = Double(grifoSeleccionado.latitudGrifo),
           let longitudGrifoSeleccionado = Double(grifoSeleccionado.longitudGrifo) {
            let ubicacionGrifoSeleccionado = CLLocationCoordinate2D(latitude: latitudGrifoSeleccionado, longitude: longitudGrifoSeleccionado)
            print("Grifo seleccionado:")
            print("Nombre: \(grifoSeleccionado.tituloMenu)")
            print("Precio: \(grifoSeleccionado.precioGrifo)")
            print("Ubicación: Latitud \(formatLocation(ubicacionGrifoSeleccionado))")
            // Asignar latitud y longitud a las variables
            self.latitudRuta = String(latitudGrifoSeleccionado)
            self.longitudRuta = String(longitudGrifoSeleccionado)
            
            if let distanceURL = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.latitudUbiActual),\(self.longitudUbiActual)&destinations=\(ubicacionGrifoSeleccionado.latitude),\(ubicacionGrifoSeleccionado.longitude)&key=\(apiKey)") {
                let task = URLSession.shared.dataTask(with: distanceURL) { (data, response, error) in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let rows = json["rows"] as? [[String: Any]], let elements = rows.first?["elements"] as? [[String: Any]], let duration = elements.first?["duration"] as? [String: Any], let distance = elements.first?["distance"] as? [String: Any] {
                        if let text = duration["text"] as? String, let km = distance["text"] as? String {
                            if let durationInSeconds = duration["value"] as? Int {
                                let currentTime = Date()
                                let calendar = Calendar.current
                                if let estimatedArrivalTime = calendar.date(byAdding: .second, value: durationInSeconds, to: currentTime) {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "HH:mm a"
                                    let arrivalTimeString = dateFormatter.string(from: estimatedArrivalTime)
                                    
                                    DispatchQueue.main.async {
                                        self.lblMinutosEstimado.text = "    " + text
                                        self.lblKmEstimado.text = "    " + km
                                        self.lblHoraLlegadaEstimado.text = "    Hora estimada de llegada: " + arrivalTimeString
                                        self.vDetalleRuta.isHidden = false
                                    }
                                }
                            }
                        }
                    }
                }
                task.resume()
            }

            let routeColorSeleccionado = UIColor.blue
            drawRoute(to: ubicacionGrifoSeleccionado, color: routeColorSeleccionado)

            if let ubicacionPrecioMenor = ubicacionPrecioMenor {
                let routeColorMenor = UIColor(hex: 0x008000)
                drawRoute(to: ubicacionPrecioMenor, color: routeColorMenor)
            }

            let routeColorSegundoPrecioMenor = UIColor.orange

            if let ubicacionSegundoPrecioMenor = ubicacionSegundoPrecioMenor {
                drawRoute(to: ubicacionSegundoPrecioMenor, color: routeColorSegundoPrecioMenor)
            }

            hDetalleGrifo.constant = 112
            vDetalleGrifo.isHidden = false
            btnRuta.isHidden = false

            lblNombre.text = grifoSeleccionado.tituloMenu
            cosmosContainerView.rating = Double(grifoSeleccionado.valoracion) ?? 0.0
            lblKm.text = grifoSeleccionado.km + " km"
            lblCombustible.text = grifoSeleccionado.nombreProducto + " a: "
            lblPrecio.text = " " + grifoSeleccionado.precio + " "

            if (grifoSeleccionado.precioGrifo == self.precioMayor) {
                lblPrecio.backgroundColor = UIColor(hex: 0xFE3A46)
                lblPrecio.textColor = UIColor(hex: 0xFFFFFF)
            } else if (grifoSeleccionado.precioGrifo == self.precioMenor) {
                lblPrecio.backgroundColor = UIColor(hex: 0x029F1D)
                lblPrecio.textColor = UIColor(hex: 0xFFFFFF)
            } else {
                lblPrecio.backgroundColor = UIColor(hex: 0xF8BD00)
                lblPrecio.textColor = UIColor(hex: 0x000000)
            }

            self.codigoOsinergmin = grifoSeleccionado.codigoOsinergmin
            self.nombreEstablecimiento = grifoSeleccionado.tituloMenu
            self.valoracionEstablecimiento = grifoSeleccionado.valoracion
            self.direccionEstablecimiento = grifoSeleccionado.direccion

        } else {
            print("Error: Las coordenadas del grifo seleccionado no son válidas.")
        }

        return true
    }

    // Función para formatear la ubicación
    func formatLocation(_ location: CLLocationCoordinate2D) -> String {
        let latitudFormat = String(format: "%.6f", location.latitude)
        let longitudFormat = String(format: "%.6f", location.longitude)
        return "Latitud \(latitudFormat), Longitud \(longitudFormat)"
    }
    
    //API AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo
    func drawRoute(to destination: CLLocationCoordinate2D, color: UIColor) {
        let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
        let apiKey = "AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo"

        if let latitud = Double(self.latitudUbiActual), let longitud = Double(self.longitudUbiActual) {
            let origin = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)

            if let url = URL(string: "\(baseURL)origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&key=\(apiKey)") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let routes = json["routes"] as? [[String: Any]], let route = routes.first, let overviewPolyline = route["overview_polyline"] as? [String: String], let points = overviewPolyline["points"] {
                            let path = GMSPath(fromEncodedPath: points)
                            
                            DispatchQueue.main.async {
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 5
                                polyline.strokeColor = color
                                polyline.map = self.mapView
                                self.routeOverlays.append(polyline)
                            }
                        }
                    }
                }
                task.resume()
            }
        } else {
            // Manejar el caso en el que no se puedan convertir las cadenas en valores Double
            print("Error: No se pudieron convertir latitud y/o longitud en Double")
        }
    }
    
    func clearRoutes() {
        for polyline in routeOverlays {
            polyline.map = nil
        }
        routeOverlays.removeAll()
    }
    
    
    @IBAction func mostrarLista(_ sender: Any) {
        self.performSegue(withIdentifier: "sgLista", sender: self)

    }
    
    @IBAction func botonPresionadoCombustible(_ sender: UIButton) {
        // Desactivar todos los botones
        btng84.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btnglp.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngnv.backgroundColor = UIColor(hex: 0xF5F6FB)
        btndiesel.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngRegular.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngPremium.backgroundColor = UIColor(hex: 0xF5F6FB)
        btng84.tintColor = UIColor(hex: 0x67738F)
        btnglp.tintColor = UIColor(hex: 0x67738F)
        btngnv.tintColor = UIColor(hex: 0x67738F)
        btndiesel.tintColor = UIColor(hex: 0x67738F)
        btngRegular.tintColor = UIColor(hex: 0x67738F)
        btngPremium.tintColor = UIColor(hex: 0x67738F)

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
        listarGrifos()

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
        listarGrifos()
    }
    

    @IBAction func borrarFiltros(_ sender: Any) {
        ratingFiltro = "-"
        //categoria = "010"
        //codigoDistrito = "-"
        self.establecimientosKmFiltro = "20C"
        self.ubigeo = "-"
        //tfDistrito.text = "Distritos"
        btng84.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btnglp.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngnv.backgroundColor = UIColor(hex: 0xF5F6FB)
        btndiesel.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngRegular.backgroundColor = UIColor(hex: 0xF5F6FB)
        btngPremium.backgroundColor = UIColor(hex: 0xF5F6FB)
        
        btng84.tintColor = UIColor(hex: 0x67738F)
        btnglp.tintColor = UIColor(hex: 0x67738F)
        btngnv.tintColor = UIColor(hex: 0x67738F)
        btndiesel.tintColor = UIColor(hex: 0x000090)
        btngRegular.tintColor = UIColor(hex: 0x67738F)
        btngPremium.tintColor = UIColor(hex: 0x67738F)

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
      
        listarGrifos()
    }
    
    
    @IBAction func iniciarRuta(_ sender: Any) {
        self.performSegue(withIdentifier: "sgIniciarRuta", sender: self)

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgIniciarRuta") {
            let vc = segue.destination as! IniciarRutaViewController
            vc.vMapa = self
        }

    }
}
