//
//  RutaViewController.swift
//  facilito
//
//  Created by iMac Mario on 2/11/23.
//


import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import Cosmos
import GooglePlaces

class RutaViewController:  UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var vIniciarRuta: IniciarRutaViewController!

    var locationManager = CLLocationManager()
    var locManager = CLLocationManager()
    var userLocationMarker: GMSMarker?
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vDetalleGrifo: UIView!
    @IBOutlet weak var btnIconGrifo: UIButton!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var lblCombustible: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    @IBOutlet weak var hDetalleGrifo: NSLayoutConstraint!

    @IBOutlet weak var vDetalleRuta: UIView!
    @IBOutlet weak var lblMinutosEstimado: UILabel!
    @IBOutlet weak var lblKmEstimado: UILabel!
    @IBOutlet weak var lblHoraLlegadaEstimado: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnMiUbicacion: UIButton!
    
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var latitud: String = ""
    var longitud: String = ""
    var latitudUbiActual: String = ""
    var longitudUbiActual: String = ""
    var ubigeo: String = ""
    var ratingFiltro: String = ""
    var precioMayor: String = ""
    var precioMenor: String = ""
    var precioGrifo: String = ""
    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var latitudRuta: String = ""
    var longitudRuta: String = ""
    var routeOverlays: [GMSPolyline] = []
    var filtroDistrito: String = ""
    var grifos: [GrifosMapaMenu] = [GrifosMapaMenu]()


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        filtroDistrito = "1"

        btnBack.roundButton()
        lblPrecio.roundLabel()
        vDetalleGrifo.roundView()
        vDetalleGrifo.addCardShadow()
        vDetalleRuta.roundView()
        btnIconGrifo.roundButton()
        btnMiUbicacion.roundButton()
        hDetalleGrifo.constant = 0
        vDetalleGrifo.isHidden = true
        vDetalleRuta.isHidden = true
        ratingFiltro = "-"

        latitudRuta = vIniciarRuta.vMapa.latitudRuta
        longitudRuta = vIniciarRuta.vMapa.longitudRuta
        codigoOsinergmin = vIniciarRuta.vMapa.codigoOsinergmin
        
    }
    
    @IBAction func centrarUbicacion(_ sender: UIButton) {
        if let location = locationManager.location {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
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
    
    var isFirstMapLoad = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if CLLocationCoordinate2DIsValid(location.coordinate) && location.coordinate.latitude != 0.0 && location.coordinate.longitude != 0.0 {
            print("Longitud: \(location.coordinate.longitude)")
            print("Latitud: \(location.coordinate.latitude)")
            longitud = String(location.coordinate.longitude)
            latitud = String(location.coordinate.latitude)

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
            self.ubigeo = "-"
            //SERVICIO EN OBSERVACIÓN obtenerCoordenadas
            //obtenerCoordenadas()
            self.listarGrifos()
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
    var isPanningMap = false

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if !isPanningMap {
            vDetalleGrifo.isHidden = true
            hDetalleGrifo.constant = 0
            vDetalleRuta.isHidden = false
            //clearRoutes()

        }
            isPanningMap = false
    }
    
    var selectedMarker: GMSMarker?
    var currentLocationMarker: GMSMarker?

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

                                let customMarkerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))

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
                
                            let destination = CLLocationCoordinate2D(latitude: Double(self.latitudRuta) ?? 0.0, longitude: Double(self.longitudRuta) ?? 0.0)
                            self.drawRoute(to: destination, color: UIColor.blue)
                     

                        } else {
                            self.displayMessage = "No se pudo obtener grifos, vuelve a intentar"
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
    
    func clearRoutes() {
        for polyline in routeOverlays {
            polyline.map = nil
        }
        routeOverlays.removeAll()
    }
    
    // Función para formatear la ubicación
    func formatLocation(_ location: CLLocationCoordinate2D) -> String {
        let latitudFormat = String(format: "%.6f", location.latitude)
        let longitudFormat = String(format: "%.6f", location.longitude)
        return "Latitud \(latitudFormat), Longitud \(longitudFormat)"
    }
    
    //API AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let apiKey = "AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo"

        if let selectedMarker = selectedMarker, selectedMarker == marker {
            // El mismo marcador ya está seleccionado, no hacemos nada
            return true
        }

        // Guardar el marcador seleccionado actual
        selectedMarker = marker

        clearRoutes()

        let grifoSeleccionado = self.grifos.first { $0.codigoOsinergmin == marker.title }

        if let grifoSeleccionado = grifoSeleccionado, let latitudGrifoSeleccionado = Double(grifoSeleccionado.latitudGrifo), let longitudGrifoSeleccionado = Double(grifoSeleccionado.longitudGrifo) {
            let ubicacionGrifoSeleccionado = CLLocationCoordinate2D(latitude: latitudGrifoSeleccionado, longitude: longitudGrifoSeleccionado)

            print("Grifo seleccionado:")
            print("Nombre: \(grifoSeleccionado.tituloMenu)")
            print("Precio: \(grifoSeleccionado.precioGrifo)")
            print("Ubicación: Latitud \(formatLocation(ubicacionGrifoSeleccionado))")

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

            hDetalleGrifo.constant = 112
            vDetalleGrifo.isHidden = false

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
    
    var ejecutarInicio = true // Bandera para controlar la ejecución del bucle

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
        
        if ejecutarInicio {
            for grifo in self.grifos where grifo.codigoOsinergmin == self.codigoOsinergmin {
                // Obtener el nombre de la unidad
                let lat = grifo.latitudGrifo
                let lon = grifo.longitudGrifo

                if let lat = Double(lat), let lon = Double(lon) {
                    let ubicacionGrifoSeleccionado = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                    // Muestra el detalle del grifo seleccionado
                    print("Grifo seleccionado:")
                    print("Nombre: \(grifo.tituloMenu)")
                    print("Precio: \(grifo.precioGrifo)")
                    print("Ubicación: Latitud \(lat), Longitud \(lon)")

                    self.latitudRuta = String(lat)
                    self.longitudRuta = String(lon)

                    if let distanceURL = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(self.latitudUbiActual),\(self.longitudUbiActual)&destinations=\(lat),\(lon)&key=\(apiKey)") {
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

                    // Mostrar el detalle del grifo en la vista
                    self.vDetalleRuta.isHidden = false
                }
            }

            // Una vez que el código del bucle for se ha ejecutado, establece ejecutarInicio en false para evitar futuras ejecuciones
            ejecutarInicio = false
        }
    }
    
    @IBAction func cerrarRuta(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
//Fin clase
}
