//
//  MapaGrifosViewController.swift
//  facilito
//
//  Created by iMac Mario on 10/05/23.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import CoreLocation


class MapaGrifosViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    

    @IBOutlet weak var ivlogoGrifo: UIImageView!
    @IBOutlet weak var lblGrifo: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var octanos: UILabel!
    @IBOutlet weak var galones: UILabel!
    
    @IBOutlet weak var vGrifo: UIView!
    @IBOutlet weak var btnLlamar: UIButton!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.roundButton()
        btnLlamar.roundButton()
        //vGrifo.roundView()
        vGrifo.layer.shadowColor = UIColor.gray.cgColor
        vGrifo.layer.shadowOffset = CGSize(width: 0, height: 3)
        vGrifo.layer.shadowRadius = 8
        vGrifo.layer.shadowOpacity = 0.5
        vGrifo.layer.cornerRadius = 12
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Se agrega la vista encima del mapa
        mapView.addSubview(vGrifo)
    }
    
    // Función que se llama cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Obtiene la última ubicación conocida del dispositivo
        guard let location = locations.last else { return }

        // Crea una instancia de GMSCameraPosition con la ubicación actual
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        
        let marker = GMSMarker(position: location.coordinate)

        // Establece el título y la descripción del marcador
        marker.title = "Mi ubicación"
        marker.snippet = "Aquí estoy"

        // Carga el icono del marcador
        marker.icon = UIImage(named: "marker")

        // Agrega el marcador al mapa
        marker.map = mapView
        // Establece la cámara del mapa en la posición actual
        mapView.animate(with: GMSCameraUpdate.setCamera(camera))

        // Detiene la actualización de la ubicación
        locationManager.stopUpdatingLocation()
        
    }
    
}

