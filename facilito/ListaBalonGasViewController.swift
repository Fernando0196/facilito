//
//  ListaBalonGasViewController.swift
//  facilito
//
//  Created by iMac Mario on 15/09/23.
//

import UIKit
import SwiftyJSON
import Cosmos
import CoreLocation
import DropDown


class ListaBalonGasViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var vBalonGasMapa: BalonGasMapaViewController!

    var locManager = CLLocationManager()


    @IBOutlet weak var btnMenuUsuario: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLista: UIButton!
    
    @IBOutlet weak var btnAbrirFiltroExpan: UIButton!
    @IBOutlet weak var btnCerarFiltroExpan: UIButton!
    //Balón
    @IBOutlet weak var btn3KG: UIButton!
    @IBOutlet weak var btn5KG: UIButton!
    @IBOutlet weak var btn10KG: UIButton!
    @IBOutlet weak var btn15KG: UIButton!
    @IBOutlet weak var btn45KG: UIButton!

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
    
    @IBOutlet weak var btnPorPrecio: UIButton!
    @IBOutlet weak var btnPorDistancia: UIButton!
    @IBOutlet weak var btnPorCali: UIButton!
    @IBOutlet weak var btnPorFavo: UIButton!
    @IBOutlet weak var btnAlfa: UIButton!
    
    
    @IBOutlet weak var btnDistrito: UIButton!
    
    @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
    @IBOutlet weak var vFiltroExpan: UIView!

    @IBOutlet weak var tvMenu: UITableView!

    var balonGas: [BalonGasMenu] = [BalonGasMenu]()

    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var filtroDistrito: String = ""

    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    @IBOutlet weak var tfDistrito: UITextField!
    
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

    var tituloMenu: String = ""
    var df : BalonGasMenu!
    var vParentBalonCell: balonCell!

    var precioMayor: Double = 0.0
    var precioMenor: Double = 0.0
    var precioBalon: Double = 0.0

    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var establecimientosKmFiltro: String = ""
    var ratingFiltro: String = ""
    var ordenarPor: String = ""

    var dropDown = DropDown()
    var distritos: [String] = []
    var nombreDistrito: String = ""
    var codigoDistrito: String = ""
    var locationManager = CLLocationManager()
    var codProvincia: String = ""
    var codDepartamento: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hViewFiltroExpan.constant = 0
        vFiltroExpan.isHidden = true
        btnCerarFiltroExpan.isHidden = true

        btnBack.roundButton()
        btnMenuUsuario.roundButton()
        btnCerarFiltroExpan.roundButton()
        btn3KG.roundButton()
        btn5KG.roundButton()
        btn10KG.roundButton()
        btn15KG.roundButton()
        btn45KG.roundButton()
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
        btnPorPrecio.roundButton()
        btnPorDistancia.roundButton()
        btnPorCali.roundButton()
        btnPorFavo.roundButton()
        btnAlfa.roundButton()
        
        btn3KG.addShadowOnBottom()
        btn5KG.addShadowOnBottom()
        btn10KG.addShadowOnBottom()
        btn15KG.addShadowOnBottom()
        btn45KG.addShadowOnBottom()
        btn10proximas.addShadowOnBottom()
        btn30proximas.addShadowOnBottom()
        btnGasolinera2km.addShadowOnBottom()
        btnGasolinera3km.addShadowOnBottom()
        btnCali1.addShadowOnBottom()
        btnCali2.addShadowOnBottom()
        btnCali3.addShadowOnBottom()
        btnCali4.addShadowOnBottom()
        btnCali5.addShadowOnBottom()
        btnPorPrecio.addShadowOnBottom()
        btnPorDistancia.addShadowOnBottom()
        btnPorCali.addShadowOnBottom()
        btnPorFavo.addShadowOnBottom()
        btnAlfa.addShadowOnBottom()

        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization() // O locManager.requestAlwaysAuthorization() según tus necesidades.
        locManager.startUpdatingLocation()

        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self
        
        self.codigoOsinergmin = self.vBalonGasMapa.codigoOsinergmin
        
        self.establecimientosKmFiltro = "20C"
        self.ratingFiltro = "5"
        tvMenu.addShadowToTop()
        btnLista.addShadowOnBottom()
        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func obtenerUbicacionActual() {

        if let currentLocation = locManager.location {

            latitud = String(currentLocation.coordinate.latitude)
            longitud = String(currentLocation.coordinate.longitude)
            self.ubigeo = "-"
            self.listarBalonGas()
            
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
    
    /*
    // Función que se llama cuando se actualiza la ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        guard let location = locations.last else { return }
        // Imprime la longitud y latitud
        print("Longitud: \(location.coordinate.longitude)")
        print("Latitud: \(location.coordinate.latitude)")
        longitud = String(location.coordinate.longitude)
        latitud = String(location.coordinate.latitude)
        obtenerCoordenadas()


    }
    */
    private func filtrarPorDistrito() {
        
        _ = self.codDepartamento
        _ = self.codProvincia
        let codigoDist = self.codigoDistrito
        
        if codigoDistrito == "-"{
            filtroDistrito = "1"
            self.ubigeo = "-"
            listarBalonGas()

        }
        else {
            self.ubigeo = self.codDepartamento + self.codProvincia + codigoDist
            filtroDistrito = "2"
            listarBalonGas()
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
    
    
    private func listarBalonGas() {
        
        self.balonGas.removeAll()
        print("Limpio: \(self.balonGas.count)")

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
                                let f = BalonGasMenu()
                                
                                f.codigoOsinergmin = subJson["codigoOsinergmin"].stringValue
                                f.tituloMenu = subJson["nombreUnidad"].stringValue
                                f.valoracion = subJson["valorMedio"].stringValue
                                f.direccion = subJson["direccion"].stringValue
                                f.km = subJson["distanciaKm"].stringValue
                                f.nombreProducto = subJson["nombreProducto"].stringValue
                                f.precioBalonGas = Double(subJson["precio"].stringValue) ?? 0.0
                                self.precioBalon = Double(subJson["precio"].stringValue) ?? 0.0
                                
                                let precioString = subJson["precio"].stringValue // Obtener el valor del precio como cadena

                                if let precio = Double(precioString) {
   
                                    let precioFormateado = String(format: "S/ %.2f", precio)
                                    f.precio = precioFormateado
                                } else {
                                    print("No se pudo convertir el precio a un número válido.")
                                }
                                f.latitudBalon = subJson["latitud"].stringValue
                                f.longitudBalon = subJson["longitud"].stringValue
                                self.balonGas.append(f)

                                if self.precioMenor >= subJson["precio"].doubleValue {
                                    self.precioMenor = subJson["precio"].doubleValue
                                }
                                if self.precioMayor <= subJson["precio"].doubleValue {
                                    self.precioMayor = subJson["precio"].doubleValue
                                }
                            }
                            print("Total balon: \(self.balonGas.count)")

                            for (index, _) in self.balonGas.enumerated() {
                                let f = self.balonGas[index]
                                
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

    @IBAction func mostrarDistritos(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func motrarFiltroExpan(_ sender: Any) {
        
        if vFiltroExpan.isHidden {
            hViewFiltroExpan.constant = 276
            vFiltroExpan.isHidden = false
            btnCerarFiltroExpan.isHidden = false
            btnAbrirFiltroExpan.isHidden = true

        } else {
            btnAbrirFiltroExpan.isHidden = false
            vFiltroExpan.isHidden = true
            btnCerarFiltroExpan.isHidden = true
            hViewFiltroExpan.constant = 0
        }
    }
    
    @IBAction func verMapa(_ sender: Any) {
        self.performSegue(withIdentifier: "sgVerMapa", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
        
        if (segue.identifier == "sgDetalleBalonGas") {
            let vc = segue.destination as! ListaBalonDetalleViewController
            vc.vBalonGasMapa = self

        }
        if (segue.identifier == "sgVerMapa") {
            let vc = segue.destination as! BalonGasMapaViewController

        }
    }
    
    @IBAction func botonPresionadoBalon(_ sender: UIButton) {
        // Desactivar todos los botones
        btn3KG.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btn5KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn10KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn15KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn45KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn3KG.tintColor = UIColor(hex: 0x67738F)
        btn5KG.tintColor = UIColor(hex: 0x67738F)
        btn10KG.tintColor = UIColor(hex: 0x67738F)
        btn15KG.tintColor = UIColor(hex: 0x67738F)
        btn45KG.tintColor = UIColor(hex: 0x67738F)

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
        listarBalonGas()

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
        listarBalonGas()
    }
    

    @IBAction func borrarFiltros(_ sender: Any) {
        ratingFiltro = "-"
        establecimientosKmFiltro = "-"
        categoria = "010"
        codigoDistrito = "-"
        distancia = "20C"
        self.ubigeo = "-"
        tfDistrito.text = "Distritos"
        btn3KG.backgroundColor =  UIColor(hex: 0xF5F6FB)
        btn5KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn10KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn15KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn45KG.backgroundColor = UIColor(hex: 0xF5F6FB)
        btn3KG.tintColor = UIColor(hex: 0x67738F)
        btn5KG.tintColor = UIColor(hex: 0x67738F)
        btn10KG.tintColor = UIColor(hex: 0x000090)
        btn15KG.tintColor = UIColor(hex: 0x67738F)
        btn45KG.tintColor = UIColor(hex: 0x67738F)

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
      
        listarBalonGas()
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
            let balonGasOrdenado = self.balonGas.sorted { (f1, f2) -> Bool in
                return f1.precioBalonGas < f2.precioBalonGas
            }
            self.balonGas = balonGasOrdenado
            tvMenu.reloadData()
        }
        else if sender == btnPorDistancia {
            let balonGasOrdenado = self.balonGas.sorted { (f1, f2) -> Bool in
                if let km1 = Double(f1.km.replacingOccurrences(of: ",", with: ".")),
                   let km2 = Double(f2.km.replacingOccurrences(of: ",", with: ".")) {
                    return km1 > km2
                }
                return false
            }
            self.balonGas = balonGasOrdenado
            tvMenu.reloadData()            
        }
        else if sender == btnPorCali {
            let balonGasOrdenado = self.balonGas.sorted { (f1, f2) -> Bool in
                if let valoracion1 = Double(f1.valoracion.replacingOccurrences(of: ",", with: ".")),
                   let valoracion2 = Double(f2.valoracion.replacingOccurrences(of: ",", with: ".")) {
                    return valoracion1 > valoracion2
                }
                return false
            }
            self.balonGas = balonGasOrdenado
            tvMenu.reloadData()
            
        }
        else if sender == btnPorFavo {
            
            
        }
        else if sender == btnAlfa {
            let balonGasOrdenado = self.balonGas.sorted { (f1, f2) -> Bool in
                return f1.tituloMenu < f2.tituloMenu
            }
            self.balonGas = balonGasOrdenado
            tvMenu.reloadData()           
        }
    }
    


}

extension ListaBalonGasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.balonGas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBalon", for: indexPath) as! balonCell
        
        let f = self.balonGas[indexPath.row]
        
        cell.lblNombre.text = f.tituloMenu
        let doubleValue = Double(f.valoracion)
        cell.cosmosContainerView.rating = doubleValue ?? 0.0
        cell.lblNombrePeso.text = f.nombreProducto
        cell.btnPrecio.setTitle(f.precio, for: .normal)
        cell.lblKm.text = f.km + " km"
        
        cell.precioMay = self.precioMayor
        cell.precioMen = self.precioMenor
        cell.precioGalon = f.precioBalonGas
        
        cell.btnSeleccionarMenu.tag = indexPath.row
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.balonGas[sender.tag]
        self.codigoOsinergmin = self.df.codigoOsinergmin
        self.nombreEstablecimiento = self.df.tituloMenu
        self.valoracionEstablecimiento = self.df.valoracion
        self.direccionEstablecimiento =  self.df.direccion
        self.performSegue(withIdentifier: "sgDetalleBalonGas", sender: self)
    }
    
}
    
    


    


