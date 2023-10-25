//
//  SeleccionePosteViewController.swift
//  facilito
//
//  Created by iMac Mario on 11/05/23.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import DropDown

class SeleccionePosteViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var btnMenuUsuario: UIButton!
    
    @IBOutlet weak var vLlamar: UIView!
    @IBOutlet weak var vDenunciasReporte: UIView!
    @IBOutlet weak var vCuidados: UIView!
    
    @IBOutlet weak var btnLlamar: UIButton!
    @IBOutlet weak var btnDenuncias: UIButton!
    @IBOutlet weak var btnCuidados: UIButton!
    
    
    @IBOutlet weak var btnLlamarEmpresaE: UIButton!
    @IBOutlet weak var btnDenunciasReportes: UIButton!
    @IBOutlet weak var btnCuidadoConsejos: UIButton!
    
    //COMBO
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var tfTipoReporte: UITextField!
    @IBOutlet weak var ivIcon: UIImageView!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vPostesSeleccionados: UIView!
    @IBOutlet weak var btnUbicacion: UIButton!
    
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var tvPostes: UITextView!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var locationManager = CLLocationManager()
    var userLocationMarker: GMSMarker?
    
    var codProvincia: String = ""
    var codDepartamento: String = ""

    var nombreReporte: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var lonPrincipal: String = ""
    var latPrincipal: String = ""

    let dropDown = DropDown()
    
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Daño de artefactos eléctricos","Peligro por cables o postes caídos"]
    
    var filtroDistrito: String = ""
    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    
    var postes: [PostesMenu] = [PostesMenu]()
    var df : PostesMenu!
    
    var selectedPostes: [PostesMenu] = []
    var posteMarkers: [GMSMarker] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnContinuar.roundButton()
        vLlamar.roundView()
        vDenunciasReporte.roundView()
        vCuidados.roundView()
        
        btnLlamar.roundButton()
        btnDenuncias.roundButton()
        btnCuidados.roundButton()
        btnUbicacion.roundButton()
        btnReportar.layer.cornerRadius = 5        
        
        vPostesSeleccionados.layer.shadowColor = UIColor.gray.cgColor
        vPostesSeleccionados.layer.shadowOffset = CGSize(width: 0, height: 3)
        vPostesSeleccionados.layer.shadowRadius = 8
        vPostesSeleccionados.layer.shadowOpacity = 0.5
        vPostesSeleccionados.layer.cornerRadius = 12
        tvPostes.layer.cornerRadius = 7

        mapView.addSubview(vPostesSeleccionados)
        mapView.delegate = self

        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnReportar.translatesAutoresizingMaskIntoConstraints = false

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        dropDown.anchorView = btnReportar
        dropDown.dataSource = tiposReporte
        
        //Reportes combo
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnReportar.setTitle("" + tiposReporte[index], for: .normal)
            self.nombreReporte = tiposReporte[index]
            print(self.nombreReporte)
            let buttonFont = UIFont(name: "Poppins-Regular", size: 14);
            let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont]
            let attributedString = NSAttributedString(string: self.nombreReporte, attributes: attributes)
            btnReportar.setAttributedTitle(attributedString, for: .normal)
            
            
            if (self.nombreReporte == "Reportar recibo excesivo"){
                self.performSegue(withIdentifier: "sgReciboE", sender: self)
            }

            if (self.nombreReporte == "Daño de artefactos eléctricos"){
                self.performSegue(withIdentifier: "sgDanioE", sender: self)
            }
            if (self.nombreReporte == "Interrupción de servicio eléctrico"){
                self.performSegue(withIdentifier: "sgInterrupcionE", sender: self)
            }
            if (self.nombreReporte == "Peligro por cables o postes caídos"){
                self.performSegue(withIdentifier: "sgPostesE", sender: self)
            }
            
        }
        tfTipoReporte.borderStyle = .roundedRect
        tfTipoReporte.translatesAutoresizingMaskIntoConstraints = false
        
        ivIcon.image = UIImage(named: "down")
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnReportar.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnReportar.centerYAnchor).isActive = true
        
        
        
  }
    
    var isFirstMapLoad = true

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if isFirstMapLoad {
            longitud = String(location.coordinate.longitude)
            latitud = String(location.coordinate.latitude)
            lonPrincipal = longitud
            latPrincipal = latitud

            isFirstMapLoad = false

            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 19)
            mapView.camera = camera

            // Asegúrate de que el marcador de ubicación esté presente en el mapa en todo momento
            if userLocationMarker == nil {
                let marker = GMSMarker(position: location.coordinate)
                marker.title = "Mi ubicación"
                marker.snippet = "Aquí estoy"
                marker.icon = UIImage(named: "marker")
                marker.map = mapView
                userLocationMarker = marker
            }
        }
    }


    var latitudCentro: Double = 0.0
    var longitudCentro: Double = 0.0
    var ultimaLatitud: Double = 0.0
    var ultimaLongitud: Double = 0.0
    var distanciaMinima: Double = 85.0

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let centerLatitude = cameraPosition.target.latitude
        let centerLongitude = cameraPosition.target.longitude

        if isFirstMapLoad == false {
            self.latitud = latPrincipal
            self.longitud = lonPrincipal
            let camera = GMSCameraPosition.camera(withLatitude: Double(latPrincipal) ?? 0.0, longitude: Double(lonPrincipal) ?? 0.0, zoom: 19)
            mapView.camera = camera
            isFirstMapLoad = true
        } else {
            self.latitud = String(format: "%.6f", centerLatitude)
            self.longitud = String(format: "%.6f", centerLongitude)
        }

        let distancia = calcularDistancia(latitud1: centerLatitude, longitud1: centerLongitude, latitud2: latitudCentro, longitud2: longitudCentro)
        let distanciaUltimaUbicacion = calcularDistancia(latitud1: centerLatitude, longitud1: centerLongitude, latitud2: ultimaLatitud, longitud2: ultimaLongitud)
        if distancia >= distanciaMinima && distanciaUltimaUbicacion >= distanciaMinima {
            obtenerCoordenadas()
        }

        ultimaLatitud = centerLatitude
        ultimaLongitud = centerLongitude
    }

    func calcularDistancia(latitud1: Double, longitud1: Double, latitud2: Double, longitud2: Double) -> Double {
        let location1 = CLLocation(latitude: latitud1, longitude: longitud1)
        let location2 = CLLocation(latitude: latitud2, longitude: longitud2)
        return location1.distance(from: location2)
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
                             self.listarPostes()
                         }
                          else {
                              self.displayMessage = "No se pudo obetener, vuelve a intentar"
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
    
    private func listarPostes() {
        let latitud =  self.latitud
        let longitud = self.longitud
        let radio = "100C"
        let idEmpresa = "2"
        let ubigeo = self.ubigeo
 
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.GetPostes(latitud: latitud, longitud: longitud, radio: radio, idEmpresa: idEmpresa, ubigeo: ubigeo) { (success, result, code) in            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                    if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                        do {
                           let json = try JSON(data: dataFromString)
                            self.postes.removeAll()
                            if !json["postes"]["postes"].arrayValue.isEmpty {
                                let jRecords = json["postes"]["postes"].arrayValue
                                
                                for (_, subJson) in jRecords.enumerated() {
                                    let f = PostesMenu()
                                    
                                    f.codApEmpresa = subJson["codApEmpresa"].stringValue
                                    f.latitudPoste = subJson["latitud"].stringValue
                                    f.longitudPoste = subJson["longitud"].stringValue
                                    self.postes.append(f)
                                }

                                let userLocationMarker = self.userLocationMarker
                                self.mapView.clear()
                                if let userMarker = userLocationMarker {
                                    userMarker.map = self.mapView
                                }
                                print("Total postes: \(self.postes.count)")
                                
                                for poste in self.postes {
                                    let latitud = Double(poste.latitudPoste) ?? 0.0
                                    let longitud = Double(poste.longitudPoste) ?? 0.0
                                    let customMarkerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                                
                                    if let iconImage = UIImage(named: "poste") {
                                        let imageView = UIImageView(frame: customMarkerView.bounds)
                                        imageView.image = iconImage
                                        customMarkerView.addSubview(imageView)
                                    }

                                    let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitud, longitude: longitud))
                                    marker.iconView = customMarkerView
                                    marker.map = self.mapView
                                    marker.userData = poste
                                    marker.isTappable = true
                                    marker.map = self.mapView
                                }
                                
                                if let userMarker = userLocationMarker {
                                    userMarker.map = self.mapView
                                }
                                
                                self.tvPostes.text = ""

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

    var selectedMarkers: [GMSMarker] = []

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poste = marker.userData as? PostesMenu {
            if selectedMarkers.contains(marker) {
                tvPostes.text = tvPostes.text.replacingOccurrences(of: "\(poste.codApEmpresa), ", with: "")
                selectedMarkers.removeAll { $0 == marker }
            } else {
                tvPostes.text += "\(poste.codApEmpresa), "
                selectedMarkers.append(marker)
            }
         
            let iconName = selectedMarkers.contains(marker) ? "poste_select" : "poste"
            if let iconImage = UIImage(named: iconName) {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = iconImage
                marker.iconView = imageView
            }

            return true
        }
        return false
    }

    
    @IBAction func centrarUbicacion(_ sender: UIButton) {

        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 19)
            print("Longitud: \(location.coordinate.longitude)")
              print("Latitud: \(location.coordinate.latitude)")
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
    }

    
    
    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgInterrupcionE") {
            let vc = segue.destination as! InterrupcionServicioViewController
            //vc.vBalonGasMapa = self
            //
            
        }
        if (segue.identifier == "sgDanioE") {
            let vc = segue.destination as! DanoArtefactoViewController
            //vc.vBalonGasMapa = self
            //
            
        }
        if (segue.identifier == "sgReciboE") {
            let vc = segue.destination as! ElectricidadViewController
            //vc.vBalonGasMapa = self
            //
        }
        if (segue.identifier == "sgReportarAlumbradoE") {
            let vc = segue.destination as! SeleccionePosteViewController
            //vc.vBalonGasMapa = self
            //
            
        }

    }
    
    
}
