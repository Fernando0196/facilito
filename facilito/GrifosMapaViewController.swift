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


class GrifosMapaViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var vIniciarSesion: IniciarSesionViewController!
    
    var locationManager = CLLocationManager()
    var locManager = CLLocationManager()

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
    @IBOutlet weak var tfDistrito: UITextField!

    var grifos: [GrifosMenu] = [GrifosMenu]()

    var dropDown = DropDown()
    var distritos: [String] = []
    var nombreDistrito: String = ""
    var codigoDistrito: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var latitud: String = ""
    var longitud: String = ""
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
    var calificacion: Double = 0.0
    var minPrecio: Double = 0.0
    var maxPrecio: Double = 999.0
    var ratingFiltro: String = ""
    var establecimientosKmFiltro: String = ""
    var precioMayor: Double = 0.0
    var precioMenor: Double = 0.0
    var precioGrifo: Double = 0.0

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
    func obtenerUbicacionActual() {

        if let currentLocation = locManager.location {

            latitud = String(currentLocation.coordinate.latitude)
            longitud = String(currentLocation.coordinate.longitude)
            self.ubigeo = "-"
            //self.listarGrifos()
            
        } else {
            print("No se pudo obtener la ubicación actual.")
        }
    }
    var hasRespondedToAuthorizationChange = false

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !hasRespondedToAuthorizationChange {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                obtenerUbicacionActual()
                obtenerCoordenadas()
            }
            hasRespondedToAuthorizationChange = true
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
                             
                             self.listarDistritos()
                             
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
            //listarGrifos()

        }
        else {
            self.ubigeo = self.codDepartamento + self.codProvincia + codigoDist
            filtroDistrito = "2"
            //listarGrifos()
        }

    }
    /*
    private func listarGrifos() {
        
        self.grifos.removeAll()
        print("Limpio: \(self.grifos.count)")

        let categoria = "010"
        distancia = self.establecimientosKmFiltro
        if distancia == "-" {
            distancia = "20C"
        }
        let idFamiliaGrifo = "-1"
        let marca = "-"
        let tiempo = "0"
        let tipoPago = "-"
        let variable = "-"
        calificacionFiltro = self.ratingFiltro
        if calificacionFiltro == "-" {
            calificacionFiltro = "5"
        }
        if let parsedCalificacion = Double(calificacionFiltro) {
            calificacion = parsedCalificacion
        } else {
            calificacion = 0.0
        }
        let minPrecio: Double = 0.0
        var maxPrecio: Double = 999.0

        if let parsedCalificacion = Double(calificacionFiltro) {
            calificacion = parsedCalificacion
        }

            let ac = APICaller()
            self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
            ac.GetListarBalonGas(categoria, self.latitud, self.longitud, self.distancia, idFamiliaGrifo, self.ubigeo, self.calificacion, minPrecio, maxPrecio, marca, tipoPago, variable, tiempo) { (success, result, code) in
                self.hideActivityIndicatorWithText()
                if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if !json["coordenadas"]["coordenada"].arrayValue.isEmpty {
                            let jRecords = json["coordenadas"]["coordenada"].arrayValue
                            
                            // Procesar los datos y actualizar la vista
                            self.precioMenor = jRecords[0]["precio"].doubleValue
                            self.precioMayor = jRecords[0]["precio"].doubleValue
                            
                            for (_, subJson) in jRecords.enumerated() {
                                let f = GrifosMenu()
                                //CREAR EL MENÚ PARA GRIFOS
                                f.codigoOsinergmin = subJson["codigoOsinergmin"].stringValue
                                f.tituloMenu = subJson["nombreUnidad"].stringValue
                                f.valoracion = subJson["valorMedio"].stringValue
                                f.direccion = subJson["direccion"].stringValue
                                f.km = subJson["distanciaKm"].stringValue
                                f.nombreProducto = subJson["nombreProducto"].stringValue
                                f.precioBalonGas = Double(subJson["precio"].stringValue) ?? 0.0
                                self.precioGrifo = Double(subJson["precio"].stringValue) ?? 0.0
                                
                                let precioString = subJson["precio"].stringValue // Obtener el valor del precio como cadena

                                if let precio = Double(precioString) {
   
                                    let precioFormateado = String(format: "S/ %.2f", precio)
                                    f.precio = precioFormateado
                                } else {
                                    print("No se pudo convertir el precio a un número válido.")
                                }
                                f.latitudBalon = subJson["latitud"].stringValue
                                f.longitudBalon = subJson["longitud"].stringValue
                                self.grifos.append(f)

                                if self.precioMenor >= subJson["precio"].doubleValue {
                                    self.precioMenor = subJson["precio"].doubleValue
                                }
                                if self.precioMayor <= subJson["precio"].doubleValue {
                                    self.precioMayor = subJson["precio"].doubleValue
                                }
                            }
                            print("Total balon: \(self.grifos.count)")

                            for (index, _) in self.grifos.enumerated() {
                                let f = self.grifos[index]
                                
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
                                    priceButton.backgroundColor = UIColor(hex: 0xF8BD02)
                                    iconImageView.image = UIImage(named: "ubi_amarillo")
                                }
                            }
                                self.tvMenu.reloadData()

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
    
    */
    
}
