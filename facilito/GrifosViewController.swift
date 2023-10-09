//
//  GrifosViewController.swift
//  facilito
//
//  Created by iMac Mario on 19/04/23.
//

import UIKit
import SwiftyJSON
import CoreLocation

class GrifosViewController: UIViewController,CLLocationManagerDelegate {
    
    var vIniciarSesion: IniciarSesionViewController!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMapa: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var vParentGrifosCell: grifosCell!
    
    var tituloMenu: String = ""
    var grifos: [GrifosMenu] = [GrifosMenu]()
    var df : GrifosMenu!
    
    let tvGrifos = UITableView()
    var nombreUnidad: String = ""
    var valoracion: String = ""
    
    var latitud: String = ""
    var longitud: String = ""

    var precioMayor: Double = 0.0
    var precioMenor: Double = 0.0

    struct MenuOpciones{
        let titulo: String
        let km : String
        let octanos : String
        let galones : String
        let nombreImagen :String
    }
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Petro Perú", km: "0.3km", octanos: "G90 octanos a:",galones: " S/ 17.50 / Galón", nombreImagen: "petroperu"),
    MenuOpciones(titulo: "Grifo San Martín", km: "0.35 km", octanos: "G90 octanos a:",galones: " S/ 16.50 / Galón", nombreImagen: "sanmartin"),
    MenuOpciones(titulo: "Primax", km: "0.4 km", octanos: "G90 octanos a:",galones: " S/ 19.85 / Galón", nombreImagen: "primax"),
    MenuOpciones(titulo: "Grifo Señor de Luren", km: "0.3km", octanos: "G90 octanos a:",galones: " S/ 16.00 / Galón", nombreImagen: "senorluren"),
    MenuOpciones(titulo: "Shell", km: "0.3km", octanos: "G90 octanos a:",galones: " S/ 16.90 / Galón", nombreImagen: "shell"),
    MenuOpciones(titulo: "Pecsa", km: "0.9km", octanos: "G90 octanos a:",galones: " S/ 19.90 / Galón", nombreImagen: "pecsa"),
    MenuOpciones(titulo: "Repsol", km: "1.28km", octanos: "G90 octanos a:",galones: " S/ 18.00 / Galón", nombreImagen: "repsol"),
    MenuOpciones(titulo: "Hermanos Pinoto", km: "1.35km", octanos: "G90 octanos a:",galones: " S/ 16.90 / Galón", nombreImagen: "hermanospinoto"),
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()
        btnMapa.roundButton()
        
        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization() // O locManager.requestAlwaysAuthorization() según tus necesidades.
        locManager.startUpdatingLocation()

    }

    func obtenerUbicacionActual() {

        if let currentLocation = locManager.location {

            latitud = String(currentLocation.coordinate.latitude)
            longitud = String(currentLocation.coordinate.longitude)
            print(latitud)
            print(longitud)

            self.listarGrifos()
            
        } else {
            print("No se pudo obtener la ubicación actual.")
        }
    }
    // Función del protocolo CLLocationManagerDelegate que se llama cuando cambia el estado de la autorización de ubicación
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            obtenerUbicacionActual()
        }
    }
    
    
    
    
    private func listarGrifos() {
        //let available = UserDefaults.standard.value(forKey: "available") as! Bool
        //latitud y longitud
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.GettListarGrifos(latitud,longitud, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if !json["coordenada"].arrayValue.isEmpty {
                             let jRecords = json["coordenada"].sorted(by: <)
                             
                             self.precioMenor = jRecords[0].1["precio"].doubleValue
                             self.precioMayor = jRecords[0].1["precio"].doubleValue
                             print("Menor: \(self.precioMenor)")
                             print("Mayor: \(self.precioMayor)")
                             
                             for (_, subJson): (String, JSON) in jRecords {
                                 let f = GrifosMenu()
                                 
                                 f.tituloMenu = subJson["nombreUnidad"].stringValue
                                 f.valoracion = subJson["valorMedio"].stringValue
                                 f.km = subJson["distanciaKm"].stringValue
                                 f.nombreProducto = subJson["nombreProducto"].stringValue
                                 f.precio = subJson["precio"].stringValue
                                 self.grifos.append(f)

                                 if self.precioMenor >= subJson["precio"].doubleValue {
                                     self.precioMenor = subJson["precio"].doubleValue
                                     print("Menor: \(self.precioMenor)")

                                     }
                                 if self.precioMayor <= subJson["precio"].doubleValue {
                                     self.precioMayor = subJson["precio"].doubleValue
                                     print("Mayor: \(self.precioMayor)")

                                     }
                             }

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
            //recargar
            print(self.grifos.count)
            print("Menor: \(self.precioMenor)")
            print("Mayor: \(self.precioMayor)")
            self.tvMenu.reloadData()
        })
    }

}
    
extension GrifosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("conteo")
        return self.grifos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGrifos") as! grifosCell
       
        let f = self.grifos[indexPath.row]
        
        cell.titulo.text = f.tituloMenu
        
        let doubleValue = Double(f.valoracion)
        cell.cosmosContainerView.rating = doubleValue ?? 0.0
        
        cell.km.text = f.km + " km"
        cell.octanos.text = f.nombreProducto + " a: "
        cell.galones.text = "S/" + f.precio + " Galón"
        cell.precioGalon = Double(f.precio)!
        cell.precioMay = self.precioMayor
        cell.precioMen = self.precioMenor

        //idAdjunto = f.id
        cell.btnSeleccionarMenu.tag = indexPath.item
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
               
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.grifos[sender.tag]
        self.performSegue(withIdentifier: "sgDetalleGrifo", sender: self)



    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDetalleGrifo") {
            let vc = segue.destination as! GrifoViewController
            //enviar datos del usuario
            vc.vGrifos = self
            //
            
        }
        
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    
}
    
