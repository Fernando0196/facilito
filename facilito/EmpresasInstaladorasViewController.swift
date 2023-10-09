//
//  EmpresasInstaladorasViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/10/23.
//


import UIKit
import SwiftyJSON
import CoreLocation
import Cosmos

class EmpresasInstaladorasViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
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
    
    @IBOutlet weak var tvEmpresasInstaladoras: UITableView!


    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var vMenuInferior: UIView!
    @IBOutlet weak var svOptions: UIStackView!
    
    var locationManager = CLLocationManager()
    var latitud: String = ""
    var longitud: String = ""
    var ubigeo: String = ""
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var empresasDetalle: [EmpresasInstMenu] = [EmpresasInstMenu]()
    var df : EmpresasInstMenu!

    
    // Variables de instancia
    var currentPage = 1
    var registrosCargados = 0
    var registrosPorPagina = 10 // Número inicial de registros por página
    var isLoadingData = false
    var idEmpresa: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()
          
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


        // Configura el locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tvEmpresasInstaladoras.allowsSelection = false
        tvEmpresasInstaladoras.dataSource = self
        tvEmpresasInstaladoras.delegate = self
        tvEmpresasInstaladoras.rowHeight = 118
    }
    
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
                             self.listarEmpresasInstaladoras()
                             
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

        })
    }


    private func listarEmpresasInstaladoras() {
        let token = ""
        let appInvoker = "GMD"
        let page = currentPage
        let rowsPerPage = registrosPorPagina
        let asociadoFiseEmpresaInstaladora = ""
        let idCategoriaInstalacion = 0
        let ubigeoEmpresaInstaladora = ubigeo
        let tipoPersonaEmpresaInstaladora = ""
        
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        
        ac.PostListarEmpresasInstaladoras(token: token, appInvoker: appInvoker, page: page, rowsPerPage: rowsPerPage, asociadoFiseEmpresaInstaladora: asociadoFiseEmpresaInstaladora, idCategoriaInstalacion: idCategoriaInstalacion, ubigeoEmpresaInstaladora: ubigeoEmpresaInstaladora, tipoPersonaEmpresaInstaladora: tipoPersonaEmpresaInstaladora) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if !json["empresaInstaladora"].arrayValue.isEmpty {
                            let jRecords = json["empresaInstaladora"].arrayValue
                            
                            for (_, subJson) in jRecords.enumerated() {
                                let f = EmpresasInstMenu()
                                f.nombreEmpresaInstaladora = subJson["nombreEmpresaInstaladora"].stringValue
                                f.nroRegistro = "Registro Nº " + subJson["idEmpresaInstaladora"].stringValue
                                f.idEmpresa_api = subJson["idEmpresaInstaladora"].intValue

                                self.empresasDetalle.append(f)
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
            
            // Recargar la tabla en el hilo principal
            DispatchQueue.main.async {
                self.tvEmpresasInstaladoras.reloadData()
            }
            
            // Restablecer isLoadingData a falso después de cargar datos
            self.isLoadingData = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.bounds.height

        if contentOffsetY + screenHeight >= contentHeight && !isLoadingData {
            // El usuario llegó al final de la lista, carga más datos
            isLoadingData = true
            currentPage += 1 // Incrementa la página
            listarEmpresasInstaladoras()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
        if (segue.identifier == "sgDetalle") {
            let vc = segue.destination as! EmpresasInstaladorasDetalleViewController
            vc.vEmpresaInst = self
        }

    }
    
//Fin clase
}

extension EmpresasInstaladorasViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empresasDetalle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmpresasInst", for: indexPath) as! empresasinstCell
        
        let f = self.empresasDetalle[indexPath.row]

        cell.lblnombreEmpresaInstaladora.text = f.nombreEmpresaInstaladora
        cell.lblNroRegistro.text = f.nroRegistro

        cell.btnSeleccionarMenu.tag = indexPath.row
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
      
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
       
        self.df = self.empresasDetalle[sender.tag]
        self.idEmpresa = self.df.idEmpresa_api
        self.performSegue(withIdentifier: "sgDetalle", sender: self)
    }
    
}

