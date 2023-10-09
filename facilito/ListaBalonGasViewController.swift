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
    
    @IBOutlet weak var btnDistrito: UIButton!
    
    @IBOutlet weak var hViewFiltroExpan: NSLayoutConstraint!
    @IBOutlet weak var vFiltroExpan: UIView!

    @IBOutlet weak var tvMenu: UITableView!

    var balonGas: [BalonGasMenu] = [BalonGasMenu]()

    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"

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


        locManager.delegate = self
        locManager.requestWhenInUseAuthorization() // O locManager.requestAlwaysAuthorization() según tus necesidades.
        locManager.startUpdatingLocation()

        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self
        
        self.codigoOsinergmin = self.vBalonGasMapa.codigoOsinergmin

                
    }

    func obtenerUbicacionActual() {

        if let currentLocation = locManager.location {

            latitud = String(currentLocation.coordinate.latitude)
            longitud = String(currentLocation.coordinate.longitude)
            self.listarBalonGas()
            
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

    private func listarBalonGas() {
        // Variables para definir los parámetros de la solicitud
        let categoria = "010"
        let distancia = "30C"
        let idFamiliaGrifo = "-1"
        let marca = "-"
        let tiempo = "0"
        let tipoPago = "-"
        let variable = "-"
        let calificacionFiltro = "5"
        var calificacion: Double = 0.0
        let minPrecio: Double = 0.0
        var maxPrecio: Double = 999.0

        if let parsedCalificacion = Double(calificacionFiltro) {
            calificacion = parsedCalificacion
        }

        DispatchQueue.global().async {
            // Aquí realiza tu solicitud de red para obtener los datos
            let ac = APICaller()
            self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
            ac.GetListarBalonGas(categoria, self.latitud, self.longitud, distancia, idFamiliaGrifo, self.ubigeo, calificacion, minPrecio, maxPrecio, marca, tipoPago, variable, tiempo) { (success, result, code) in
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
                                    // Si es posible convertir el precio a un número, formatear con dos decimales
                                    let precioFormateado = String(format: "S/ %.2f", precio)
                                    f.precio = precioFormateado
                                } else {
                                    // Manejar el caso en que la conversión a número falla
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
                            
                            // Actualizar la vista en el hilo principal
                            DispatchQueue.main.async {
                                self.tvMenu.reloadData()
                                // Otras actualizaciones de la vista principal aquí
                                // ...
                            }
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

    


