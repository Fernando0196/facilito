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

class GrifosMapaViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var vIniciarSesion: IniciarSesionViewController!

    
    var locationManager = CLLocationManager()

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
    
    @IBOutlet weak var btnDistrito: UIButton!
    
    @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
    @IBOutlet weak var vFiltroExpan: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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

    }
    
    @IBAction func motrarFiltroExpan(_ sender: Any) {
        
        if vFiltroExpan.isHidden {
            hViewFiltroExpan.constant = 223.33
            vFiltroExpan.isHidden = false
        } else {
            vFiltroExpan.isHidden = true
            hViewFiltroExpan.constant = 0
        }
    }
    
    @IBAction func centrarUbicacion(_ sender: UIButton) {
        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            mapView.animate(with: GMSCameraUpdate.setCamera(camera))
        }
    }
    
    // Función que se llama cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Obtiene la última ubicación conocida del dispositivo
        guard let location = locations.last else { return }
        // Imprime la longitud y latitud
        print("Longitud: \(location.coordinate.longitude)")
        print("Latitud: \(location.coordinate.latitude)")
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
