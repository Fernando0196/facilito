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
    
    @IBOutlet weak var btnMenuUsuario: UIButton!

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
    
    @IBOutlet weak var btnMapa: UIButton!
    @IBOutlet weak var vFiltroExpan: UIView!
    @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
    @IBOutlet weak var btnDistrito: UIButton!
    @IBOutlet weak var tvGrifos: UITableView!

    @IBOutlet weak var btnPorPrecio: UIButton!
    @IBOutlet weak var btnPorDistancia: UIButton!
    @IBOutlet weak var btnPorCali: UIButton!
    @IBOutlet weak var btnPorFavo: UIButton!
    @IBOutlet weak var btnAlfa: UIButton!
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var vParentGrifosCell: grifosCell!
    var ratingFiltro: String = ""

    var tituloMenu: String = ""
    var grifos: [GrifosMenu] = [GrifosMenu]()
    var df : GrifosMenu!
    var nombreUnidad: String = ""
    var valoracion: String = ""
    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var distancia: String = ""
    var establecimientosKmFiltro: String = ""

    var filtroDistrito: String = ""
    var codProvincia: String = ""
    var codDepartamento: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var precioMayor: String = ""
    var precioMenor: String = ""
    var precioGrifo: String = ""
    
    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPorPrecio.roundButton()
        btnPorDistancia.roundButton()
        btnPorCali.roundButton()
        btnPorFavo.roundButton()
        btnAlfa.roundButton()
        btnCerrarFiltro.isHidden = true
        btnCerrarFiltro.roundButton()
        btnAbrirFiltroExpan.roundButton()
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
        btnMapa.roundButton()
        tvGrifos.allowsSelection = false
        tvGrifos.dataSource = self
        tvGrifos.delegate = self
        tvGrifos.addShadowToTop()
        
        hViewFiltroExpan.constant = 0
        vFiltroExpan.isHidden = true
        establecimientosKmFiltro = "20C"
        self.ratingFiltro = "-"
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization() // O locManager.requestAlwaysAuthorization() según tus necesidades.
        locManager.startUpdatingLocation()

    }
    
    @IBAction func motrarFiltroExpan(_ sender: Any) {
        
        if vFiltroExpan.isHidden {
            hViewFiltroExpan.constant = 276
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
                         
                         if !json["empresaConcesionariaOutRO"]["ubigeo"].stringValue.isEmpty {
                             
                             self.ubigeo = json["empresaConcesionariaOutRO"]["ubigeo"].stringValue
                             self.codDepartamento = String(self.ubigeo.prefix(2))
                             self.codProvincia = String(self.ubigeo.suffix(4).prefix(2))
                             
                             print("codDepartamento: " + self.codDepartamento)
                             print("codProvincia: " + self.codProvincia)
                             
                             //self.listarDistritos()
                             
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
    
    
    
    private func listarGrifos() {
        
        self.grifos.removeAll()

        let ubigeo = self.ubigeo
        distancia = self.establecimientosKmFiltro
        let rating = self.ratingFiltro
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.GettListarGrifos(latitud,longitud,ubigeo,distancia,rating, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if !json["coordenadas"]["coordenada"].arrayValue.isEmpty {
                             let jRecords = json["coordenadas"]["coordenada"].sorted(by: <)
                             
                             self.precioMenor = jRecords[0].1["precio"].stringValue
                             self.precioMayor = jRecords[0].1["precio"].stringValue
                             print("Menor: \(self.precioMenor)")
                             print("Mayor: \(self.precioMayor)")
                             
                             
                             
                             for (_, subJson): (String, JSON) in jRecords {
                                 let f = GrifosMenu()
                                 f.codigoOsinergmin = subJson["codigoOsinergmin"].stringValue
                                 f.tituloMenu = subJson["nombreUnidad"].stringValue
                                 f.valoracion = subJson["valorMedio"].stringValue
                                 f.km = subJson["distanciaKm"].stringValue
                                 f.nombreProducto = subJson["nombreProducto"].stringValue
                                 f.precio = "S/ " + subJson["precio"].stringValue
                                 f.precioGrifo = subJson["precio"].stringValue
                                 f.direccion = subJson["direccion"].stringValue

                                 if self.precioMenor >= subJson["precio"].stringValue {
                                     self.precioMenor = subJson["precio"].stringValue
                                     print("Menor: \(self.precioMenor)")

                                     }
                                 if self.precioMayor <= subJson["precio"].stringValue {
                                     self.precioMayor = subJson["precio"].stringValue
                                     print("Mayor: \(self.precioMayor)")

                                     }
                                 self.grifos.append(f)

                                 if self.precioMenor >= subJson["precio"].stringValue {
                                     self.precioMenor = subJson["precio"].stringValue
                                 }
                                 if self.precioMayor <= subJson["precio"].stringValue {
                                     self.precioMayor = subJson["precio"].stringValue
                                 }
                             }
                             
                             print("Total grifos: \(self.grifos.count)")

                             for (index, _) in self.grifos.enumerated() {
                                 let f = self.grifos[index]
                                 /*
                                 let latitud = Double(f.latitudGrifo) ?? 0.0
                                 let longitud = Double(f.longitudBalon) ?? 0.0
                                  */
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
                                 }
                                 else if (f.precioGrifo == self.precioMenor) {
                                     priceButton.backgroundColor = UIColor(hex: 0x029F1D)
                                     iconImageView.image = UIImage(named: "ubi_verde")
                                 }
                                 else {
                                     priceButton.backgroundColor = UIColor(hex: 0xF8BD02)
                                     iconImageView.image = UIImage(named: "ubi_amarillo")
                                 }
                             }
                                 self.tvGrifos.reloadData()

                         }
                          else {
                              self.displayMessage = "No se pudo obetener grifos, vuelve a intentar"
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
            self.tvGrifos.reloadData()
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
        
        cell.lblNombre.text = f.tituloMenu
        
        let doubleValue = Double(f.valoracion)
        cell.cosmosContainerView.rating = doubleValue ?? 0.0
        
        cell.km.text = f.km + " km"
        cell.lblNombreProducto.text = f.nombreProducto
        cell.btnPrecio.setTitle(f.precio, for: .normal)
        cell.precioGrifo = f.precioGrifo
        cell.precioMay = self.precioMayor
        cell.precioMen = self.precioMenor

        cell.btnSeleccionarMenu.tag = indexPath.item
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
               
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.grifos[sender.tag]
        self.codigoOsinergmin = self.df.codigoOsinergmin
        self.nombreEstablecimiento = self.df.tituloMenu
        self.valoracionEstablecimiento = self.df.valoracion
        self.direccionEstablecimiento =  self.df.direccion
        self.precioGrifo = self.df.precio
        self.performSegue(withIdentifier: "sgDetalleGrifo", sender: self)



    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDetalleGrifo") {
            let vc = segue.destination as! GrifoDetalleViewController
            vc.vGrifos = self
            
        }
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
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
    
    @IBAction func botonPresionadoOrdenarPor(_ sender: UIButton) {
        let buttons = [btnPorPrecio, btnPorDistancia, btnPorCali, btnPorFavo, btnAlfa]
        for button in buttons {
            if let unwrappedButton = button {
                unwrappedButton.backgroundColor = UIColor(hex: 0xF5F6FB)
                unwrappedButton.tintColor = UIColor(hex: 0x67738F)
            }
        }

        sender.backgroundColor = UIColor(hex: 0x000090)
        sender.tintColor = UIColor.white

        if sender == btnPorPrecio {
            let grifoOrdenado = self.grifos.sorted { (f1, f2) -> Bool in
                return f1.precioGrifo < f2.precioGrifo
            }
            self.grifos = grifoOrdenado
            tvGrifos.reloadData()
        }
        else if sender == btnPorDistancia {
            let grifoOrdenado = self.grifos.sorted { (f1, f2) -> Bool in
                if let km1 = Double(f1.km.replacingOccurrences(of: ",", with: ".")),
                   let km2 = Double(f2.km.replacingOccurrences(of: ",", with: ".")) {
                    return km1 > km2
                }
                return false
            }
            self.grifos = grifoOrdenado
            tvGrifos.reloadData()
        }
        else if sender == btnPorCali {
            let grifoOrdenado = self.grifos.sorted { (f1, f2) -> Bool in
                if let valoracion1 = Double(f1.valoracion.replacingOccurrences(of: ",", with: ".")),
                   let valoracion2 = Double(f2.valoracion.replacingOccurrences(of: ",", with: ".")) {
                    return valoracion1 > valoracion2
                }
                return false
            }
            self.grifos = grifoOrdenado
            tvGrifos.reloadData()
            
        }
        else if sender == btnPorFavo {
            
            
        }
        else if sender == btnAlfa {
            let grifoOrdenado = self.grifos.sorted { (f1, f2) -> Bool in
                return f1.tituloMenu < f2.tituloMenu
            }
            self.grifos = grifoOrdenado
            tvGrifos.reloadData()
        }
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
        for boton in [btnPorPrecio, btnPorDistancia, btnPorCali, btnPorFavo, btnAlfa] {
            boton?.backgroundColor = UIColor(hex: 0xF5F6FB)
            boton?.tintColor = UIColor(hex: 0x67738F)
        }
      
        listarGrifos()
    }
    
    @IBAction func verMapa(_ sender: Any) {
        self.performSegue(withIdentifier: "sgVerMapaGrifos", sender: self)

    }
    
    
}
    
