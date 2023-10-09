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
    
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var tvPostes: UITextView!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var locationManager = CLLocationManager()

    var nombreReporte: String = ""


    let dropDown = DropDown()
    
    let tiposReporte = ["Reportar recibo excesivo","Interrupción de servicio eléctrico","Reportar alumbrado público","Daño de artefactos eléctricos","Peligro por postes o cables"]
    
    
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
        
        btnReportar.layer.cornerRadius = 5        
        
        vPostesSeleccionados.layer.shadowColor = UIColor.gray.cgColor
        vPostesSeleccionados.layer.shadowOffset = CGSize(width: 0, height: 3)
        vPostesSeleccionados.layer.shadowRadius = 8
        vPostesSeleccionados.layer.shadowOpacity = 0.5
        vPostesSeleccionados.layer.cornerRadius = 12
        tvPostes.layer.cornerRadius = 7
        
        
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.addSubview(vPostesSeleccionados)
        
        //btnTipoPeligro.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        btnReportar.translatesAutoresizingMaskIntoConstraints = false



        
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
        }
        // Configurar el UITextField
        tfTipoReporte.borderStyle = .roundedRect
        tfTipoReporte.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar el UIImageView
        ivIcon.image = UIImage(named: "down") // Imagen inicial cuando el desplegable está cerrado
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.translatesAutoresizingMaskIntoConstraints = false

        ivIcon.leadingAnchor.constraint(equalTo: btnReportar.trailingAnchor, constant: 8).isActive = true
        ivIcon.centerYAnchor.constraint(equalTo: btnReportar.centerYAnchor).isActive = true
        

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
    
    
    @IBAction func mostrarTiposDenuncia(_ sender: Any) {
        dropDown.show()
    }
    
}
