//
//  GasNaturalViewController.swift
//  facilito
//
//  Created by iMac Mario on 19/12/22.
//
import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import ArcGIS

class GasNaturalViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, AGSGeoViewTouchDelegate {
    
    @IBOutlet weak var btnMenuUsuario: UIButton!
    

    @IBOutlet weak var btnReportar: UIButton!

    @IBOutlet weak var btnConsulta: UIButton!
    @IBOutlet weak var btnBeneficio: UIButton!
    @IBOutlet weak var btnProceso: UIButton!
    @IBOutlet weak var btnCalculadora: UIButton!

    
    @IBOutlet weak var vReportar: UIView!
    @IBOutlet weak var vConsulta: UIView!
    @IBOutlet weak var vBeneficio: UIView!
    @IBOutlet weak var vProceso: UIView!
    @IBOutlet weak var vCalculadora: UIView!

    //Botones de los cards

    @IBOutlet weak var btnConsultar: UIButton!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mapView: AGSMapView!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var locationManager = CLLocationManager()
    var location: CLLocation?

    var latitud_api: String = ""
    var longitud_api: String = ""

    private var lastGraphicOverlay: AGSGraphicsOverlay?
    private var initialLocationOverlay: AGSGraphicsOverlay?
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnConsulta.roundButton()
        
        vReportar.roundView()
        vConsulta.roundView()
        vBeneficio.roundView()
        vProceso.roundView()
        vCalculadora.roundView()
        
        btnReportar.roundButton()
        btnConsulta.roundButton()
        btnBeneficio.roundButton()
        btnProceso.roundButton()
        btnCalculadora.roundButton()
        btnConsultar.roundButton()
        btnConsultar.titleLabel?.textAlignment = .center

        
    
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Crea un mapa base (por ejemplo, un mapa topográfico)
        let basemap = AGSBasemap.topographic()
        
        // Crea una instancia de AGSMap con el mapa base
        let map = AGSMap(basemap: basemap)
        
        // Asigna el mapa a la vista AGSMapView
        mapView.map = map

        mapView.touchDelegate = self


  }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        print("Latitud Inicial: \(latitude), Longitud Inicial: \(longitude)")

        let point = AGSPoint(x: longitude, y: latitude, spatialReference: AGSSpatialReference.wgs84())
        let camera = AGSViewpoint(center: point, scale: 1000)
        mapView.setViewpoint(camera)
        
        let symbol = AGSSimpleMarkerSymbol(style: .circle, color: .blue, size: 12)
        let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: nil)
        mapView.graphicsOverlays.removeAllObjects()
        
        let initialLocationOverlay = AGSGraphicsOverlay()
        initialLocationOverlay.graphics.add(graphic)
        mapView.graphicsOverlays.add(initialLocationOverlay)
        
        locationManager.stopUpdatingLocation()
    }
    
    func convertirCoordenadasAGSALatitudLongitud(mapPoint: AGSPoint) -> (String, String) {
        // Convierte las coordenadas del sistema de coordenadas del mapa a grados decimales
        let webMercatorCoordinate = AGSGeometryEngine.projectGeometry(mapPoint, to: AGSSpatialReference.wgs84()) as! AGSPoint
        
        let latitude = webMercatorCoordinate.y
        let longitude = webMercatorCoordinate.x
        
        let formattedLatitude = String(format: "%.6f", latitude)
        let formattedLongitude = String(format: "%.6f", longitude)
        
        return (formattedLatitude, formattedLongitude)
    }
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        if let previousOverlay = lastGraphicOverlay {
            mapView.graphicsOverlays.remove(previousOverlay)
        }
        
        let symbol = AGSSimpleMarkerSymbol(style: .circle, color: .green, size: 10)
        let graphic = AGSGraphic(geometry: mapPoint, symbol: symbol, attributes: nil)
        let graphicsOverlay = AGSGraphicsOverlay()
        graphicsOverlay.graphics.add(graphic)
        mapView.graphicsOverlays.add(graphicsOverlay)
        
        lastGraphicOverlay = graphicsOverlay
        
        let (formattedLatitude, formattedLongitude) = convertirCoordenadasAGSALatitudLongitud(mapPoint: mapPoint)
        latitud_api = formattedLatitude
        longitud_api = formattedLongitude
        print("Latitud: \(formattedLatitude), Longitud: \(formattedLongitude)")
        
        
    }

    
    @IBAction func consultarGasNatural(_ sender: Any) {
        
        if latitud_api == "" || longitud_api == ""{
            self.displayMessage = "Seleccione una ubicación en el mapa para consultar"
            self.performSegue(withIdentifier: "sgDM", sender: self)
        }
        
        let appInvoker = "appInstitucional"
        let token = "0000"
        let coordenadaX = longitud_api
        let coordenadaY = latitud_api
        let cantidadMetros = 20
        
         let ac = APICaller()
         self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostConsultarGasNatural(appInvoker: appInvoker, token: token, coordenadaX: coordenadaX, coordenadaY: coordenadaY, cantidadMetros: cantidadMetros) { (success, result, code) in
             self.hideActivityIndicatorWithText()
             if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                 do {
                     let json = try JSON(data: dataFromString)
                     if (json["resultCode"].intValue == 1)  {
                         if (json["resultadoIndGasNatural"].stringValue == "S")  {
                             self.performSegue(withIdentifier: "sgPasa", sender: self)
                         }
                         else if (json["resultadoIndGasNatural"].stringValue == "N")  {
                             self.performSegue(withIdentifier: "sgNoPasa", sender: self)
                         }
                     }
                     else{
                         self.displayMessage = "No se pudo, vuelve a intentar"
                         self.performSegue(withIdentifier: "sgDM", sender: self)
                     }
                 } catch {
                     self.displayMessage = "No se pudo, vuelve a intentar"
                     self.performSegue(withIdentifier: "sgDM", sender: self)
                 }
             } else {
                 self.displayMessage = "No se pudo, vuelve a intentar"
                 self.performSegue(withIdentifier: "sgDM", sender: self)
             }
         }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
        if (segue.identifier == "sgPasa") {
            _ = segue.destination as! GasNaturalMensajeViewController

        }
        if (segue.identifier == "sgNoPasa") {
            _ = segue.destination as! GasNaturalNoPasaViewController

        }
    }
    
    
    
    

}

