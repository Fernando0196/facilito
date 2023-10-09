//
//  ObtenerDireccionViewController.swift
//  facilito
//
//  Created by iMac Mario on 3/10/23.
//




import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation
import DropDown

class ObtenerDireccionViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

    var locationManager = CLLocationManager()
    var initialLocationMarker: GMSMarker?
    var markers: [GMSMarker] = []

    
    @IBOutlet weak var btnMiUbicacion: UIButton!


    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mapView: GMSMapView!


    @IBOutlet weak var btnObtener: UIButton!
    @IBOutlet weak var lblDireccion: UILabel!
    
    @IBOutlet weak var vUbi: UIView!
    
    var latitud: String = ""
    var longitud: String = ""

    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var direccion: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnObtener.roundButton()
        btnMiUbicacion.roundButton()
        vUbi.roundView()
        lblDireccion.roundLabel()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.delegate = self

        initialLocationMarker = GMSMarker()
        initialLocationMarker?.title = "Mi ubicación"
        initialLocationMarker?.snippet = "Aquí estoy"
        initialLocationMarker?.icon = UIImage(systemName: "location.circle")
        initialLocationMarker?.map = mapView // Muestra el marcador en el mapa
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let location = locationManager.location {
            let roundedLatitude = String(format: "%.6f", location.coordinate.latitude)
            let roundedLongitude = String(format: "%.6f", location.coordinate.longitude)

            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            mapView.camera = camera

        } else {
            print("No se pudo obtener la ubicación actual para centrar la cámara.")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideMarkers()
        // Oculta el marcador inicial
        initialLocationMarker?.map = nil
        let newMarker = GMSMarker(position: coordinate)
        newMarker.title = "Nuevo marcador"
        newMarker.icon = UIImage(named: "marker")
        newMarker.map = mapView
        markers.append(newMarker)

        getAddressForCoordinate(coordinate) { address in
            DispatchQueue.main.async {
                self.lblDireccion.text = address
                self.direccion = address!
                self.latitud = "\(coordinate.latitude)"
                self.longitud = "\(coordinate.longitude)"
                print("Latitud: \(self.latitud), Longitud: \(self.longitud)")
            }
        }
    }
    
    func hideMarkers() {
        for marker in markers {
            marker.map = nil
        }
        markers.removeAll()
    }
    
    
    @IBAction func centrarUbicacion(_ sender: UIButton) {
        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))

            // Verifica si el marcador ya existe, y si no, créalo y agréguelo al mapa
            if initialLocationMarker == nil {
                initialLocationMarker = GMSMarker()
                initialLocationMarker?.title = "Mi ubicación"
                initialLocationMarker?.snippet = "Aquí estoy"
                initialLocationMarker?.icon = UIImage(systemName: "location.circle")
            }
            initialLocationMarker?.position = location.coordinate
            initialLocationMarker?.map = mapView // Muestra el marcador en el mapa
            // Obtén la dirección de la ubicación actual
            getAddressForCoordinate(location.coordinate) { address in
                DispatchQueue.main.async {
                    self.lblDireccion.text = address
                    self.direccion = address!
                    self.latitud = "\(location.coordinate.latitude)"
                    self.longitud = "\(location.coordinate.longitude)"
                    print("Latitud: \(self.latitud), Longitud: \(self.longitud)")
                }
            }
            
            hideMarkersExceptInitialLocation()
        }
    }

    func hideMarkersExceptInitialLocation() {
        for marker in markers {
            if marker != initialLocationMarker {
                marker.map = nil
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

        initialLocationMarker?.position = location.coordinate
        initialLocationMarker?.title = "Mi ubicación"

        getAddressForCoordinate(location.coordinate) { address in
            DispatchQueue.main.async {
                self.lblDireccion.text = address
                self.direccion = address!
                self.latitud = "\(location.coordinate.latitude)"
                self.longitud = "\(location.coordinate.longitude)"
                print("Latitud: \(self.latitud), Longitud: \(self.longitud)")

                // Centra la cámara en la ubicación actual
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
                self.mapView.animate(with: GMSCameraUpdate.setCamera(camera))
            }
        }
    }

    func getAddressForCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Error al obtener la dirección: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let result = response?.firstResult() {
                    let address = result.lines?.joined(separator: "\n")
                    completion(address)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    @IBAction func ocultarVista(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func obetenerDireccion(_ sender: Any) {
        self.performSegue(withIdentifier: "sgUbicacion", sender: self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificationViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }*/
        if (segue.identifier == "sgUbicacion") {
            let vc = segue.destination as! TuberiasExpuestasViewController
            vc.vObtenerDireccion = self
        }

        
    }
    
//Fin clase
}



















