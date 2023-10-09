//
//  ContratosDetalleViewController.swift
//  facilito
//
//  Created by iMac Mario on 24/09/23.
//


import UIKit
import SwiftyJSON

class ContratosDetalleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var vContratos: TramitesViewController!

    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMenuUsuario: UIButton!

    @IBOutlet weak var tvMenu: UITableView!
    @IBOutlet weak var lblAsunto: UILabel!
    

    var contratosDetalle: [ContratosDetalleMenu] = [ContratosDetalleMenu]()
    var dfContrato : ContratosDetalleMenu!

    var contratosDetalle1: [ContratosDetalleMenu] = []
    var contratosDetalle2: [ContratosDetalleMenu] = []
    var contratosDetalle3: [ContratosDetalleMenu] = []
    var contratosDetalle4: [ContratosDetalleMenu] = []
    
    var newContratosDetalle = [ContratosDetalleMenu]()

    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var idSolicitud: Int = 0
    var datosDetalle = [JSON]()

    var SelectedIndex = -1
    var isColapse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnMenuUsuario.roundButton()

        self.idSolicitud = self.vContratos.idSolicitud
        lblAsunto.text = "Contrato Nº " + String(self.idSolicitud)
        
        tvMenu.allowsSelection = true // Habilitar la selección de celdas
        tvMenu.dataSource = self
        tvMenu.delegate = self
        tvMenu.rowHeight = UITableView.automaticDimension
        tvMenu.estimatedRowHeight = 150

        listarDetalleContratos()
        
        
    }
    
    private func listarDetalleContratos() {
        
        let appInvoker = "appInstitucional"
        let idSolicitud = idSolicitud


        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarDetalleContratos(appInvoker: appInvoker, idSolicitud: idSolicitud) { (success, result, code) in
            self.hideActivityIndicatorWithText()
            if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    if let idSolicitud = json["idSolicitud"].int, idSolicitud > 0 {
                        let jRecords = json["solicitudInformacionGeneral"].arrayValue
                        
                        self.contratosDetalle.removeAll()
                        self.datosDetalle.append(json)

                            //self.contratosDetalle.append(f)
                        self.tratarDatos(self.datosDetalle)
                        
                        let detalleContrato1 = self.contratosDetalle[0]
                        let detalleContrato2 = self.contratosDetalle[1]
                        let detalleContrato3 = self.contratosDetalle[2]
                        let detalleContrato4 = self.contratosDetalle[3]

                        let detalleContratos = Array(self.contratosDetalle.prefix(4))

                        for detalleContrato in detalleContratos {
                            let f = ContratosDetalleMenu()
                            
                            f.idEstadoSolicitud = detalleContrato.idEstadoSolicitud
                            f.estadoNombre = detalleContrato.estadoNombre
                            f.descripcion = detalleContrato.descripcion
                            f.fechaInicio = detalleContrato.fechaInicio
                            f.fechaTermino = detalleContrato.fechaTermino
                            f.diasTranscurridos = detalleContrato.diasTranscurridos
                            f.empresaInstaladora = detalleContrato.empresaInstaladora
                            f.instalador = detalleContrato.instalador

                            // Agrega los nuevos elementos a newContratosDetalle
                            self.newContratosDetalle.append(f)
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
            //recargar
            // Invierte la lista antes de cargarla en la tabla
            self.newContratosDetalle = self.newContratosDetalle.reversed()
            self.tvMenu.reloadData()
        }
    }
    
    private func tratarDatos(_ datosDetalle: [JSON]) {
        // Código para tratar los datos JSON aquí
        for json in datosDetalle {
            
        if json["etapaAprobacionContratoConcluidaSolicitud"].stringValue == "S" {
            var objEstadoTramitenuevo1 = ContratosDetalleMenu()
            objEstadoTramitenuevo1.estadoNombre = "Contrato aprobado"
            objEstadoTramitenuevo1.idEstadoSolicitud = 1
            objEstadoTramitenuevo1.descripcion = "La concesionaria de gas natural aprobó tu contrato de suministro para acceder al servicio público de gas natural"
            
            objEstadoTramitenuevo1.fechaInicio = json["fechaRegistroAprobacionSolicitud"].stringValue
            objEstadoTramitenuevo1.fechaTermino = json["fechaAprobacionSolicitud"].stringValue
            var dias: Int = calcularDiasEntreFechas( fechaInicialStr: objEstadoTramitenuevo1.fechaTermino,  fechaFinalStr: objEstadoTramitenuevo1.fechaInicio)
            objEstadoTramitenuevo1.diasTranscurridos = String(dias) + " días"
            //objEstadoTramitenuevo1.empresaInstaladora = json["nombreCortoEmpresaInstaladora"].stringValue
            //objEstadoTramitenuevo1.instalador = json["nombreInstalador"].stringValue
            
            self.contratosDetalle.append(objEstadoTramitenuevo1)
        }
            
        else {
    
            var objEstadoTramitenuevo1 = ContratosDetalleMenu()
            objEstadoTramitenuevo1.estadoNombre = "Contrato aprobado"
            objEstadoTramitenuevo1.idEstadoSolicitud = 1
            objEstadoTramitenuevo1.descripcion = "La concesionaria de gas natural aprobó tu contrato de suministro para acceder al servicio público de gas natural"
            
            objEstadoTramitenuevo1.fechaInicio = "NO"
            objEstadoTramitenuevo1.fechaTermino =  "NO"
            objEstadoTramitenuevo1.fechaEstimadaAprobacionSolicitud =  "NO"
            objEstadoTramitenuevo1.diasTranscurridos = "0"
            //objEstadoTramitenuevo1.empresaInstaladora = json["nombreCortoEmpresaInstaladora"].stringValue
            //objEstadoTramitenuevo1.instalador = json["nombreInstalador"].stringValue
            
            self.contratosDetalle.append(objEstadoTramitenuevo1)
        }
            
        //2
        if json["etapaAprobacionContratoConcluidaSolicitud"].stringValue == "S" {
            var objEstadoTramitenuevo2 = ContratosDetalleMenu()
            objEstadoTramitenuevo2.estadoNombre = "Instalación interna construida"
            objEstadoTramitenuevo2.idEstadoSolicitud = 2
            objEstadoTramitenuevo2.descripcion = "El instalador de gas natural visitó tu vivienda para construir la instalación interna, que va desde el medidor hasta tus artefactos de gas natural."
                
            objEstadoTramitenuevo2.fechaInicio = json["fechaInicioInstalacionSolicitud"].stringValue
            objEstadoTramitenuevo2.fechaTermino = json["fechaFinalizacionInstalacionSolicitud"].stringValue
                var dias: Int = calcularDiasEntreFechas( fechaInicialStr: objEstadoTramitenuevo2.fechaTermino,  fechaFinalStr: objEstadoTramitenuevo2.fechaInicio)
            objEstadoTramitenuevo2.diasTranscurridos = String(dias) + " días"
            objEstadoTramitenuevo2.empresaInstaladora = json["nombreCortoEmpresaInstaladora"].stringValue
            objEstadoTramitenuevo2.instalador = json["nombreInstalador"].stringValue
                
            self.contratosDetalle.append(objEstadoTramitenuevo2)
            
        }
                
        else {
                
            var objEstadoTramitenuevo2 = ContratosDetalleMenu()
            objEstadoTramitenuevo2.estadoNombre = "Instalación interna construida"
            objEstadoTramitenuevo2.idEstadoSolicitud = 1
            objEstadoTramitenuevo2.descripcion = "El instalador de gas natural visitó tu vivienda para construir la instalación interna, que va desde el medidor hasta tus artefactos de gas natural."
                
            objEstadoTramitenuevo2.fechaInicio = "NO"
            objEstadoTramitenuevo2.fechaTermino =  "NO"
            objEstadoTramitenuevo2.fechaEstimadaAprobacionSolicitud = "NO"
            objEstadoTramitenuevo2.diasTranscurridos = "0"
            objEstadoTramitenuevo2.empresaInstaladora = "NO"
            objEstadoTramitenuevo2.instalador = "NO"
                
            self.contratosDetalle.append(objEstadoTramitenuevo2)
            
            }
        
        //3
            if json["etapaAprobacionContratoConcluidaSolicitud"].stringValue == "S" {
                var objEstadoTramitenuevo3 = ContratosDetalleMenu()
                objEstadoTramitenuevo3.estadoNombre = "Instalación externa construida"
                objEstadoTramitenuevo3.idEstadoSolicitud = 3
                objEstadoTramitenuevo3.descripcion = "La concesionaria de gas natural ha realizado la construcción de la instalación que va fuera de tu hogar, desde la red de gas natural de la vía pública hasta tu medidor."
                objEstadoTramitenuevo3.fechaInicio = json["fechaAprobacionSolicitud"].stringValue
                objEstadoTramitenuevo3.fechaTermino = json["fechaFinalizacionInstalacionAcometida"].stringValue
                var dias: Int = calcularDiasEntreFechas( fechaInicialStr: objEstadoTramitenuevo3.fechaTermino,  fechaFinalStr: objEstadoTramitenuevo3.fechaInicio)
                objEstadoTramitenuevo3.diasTranscurridos = String(dias) + " días"
                //objEstadoTramitenuevo1.empresaInstaladora = json["nombreCortoEmpresaInstaladora"].stringValue
                //objEstadoTramitenuevo1.instalador = json["nombreInstalador"].stringValue
                
                self.contratosDetalle.append(objEstadoTramitenuevo3)
            }
                
            else {
        
                var objEstadoTramitenuevo3 = ContratosDetalleMenu()
                objEstadoTramitenuevo3.estadoNombre = "Instalación externa construida"
                objEstadoTramitenuevo3.idEstadoSolicitud = 3
                objEstadoTramitenuevo3.descripcion = "La concesionaria de gas natural ha realizado la construcción de la instalación que va fuera de tu hogar, desde la red de gas natural de la vía pública hasta tu medidor."
                objEstadoTramitenuevo3.fechaInicio = "NO"
                objEstadoTramitenuevo3.fechaTermino =  "NO"
                objEstadoTramitenuevo3.fechaEstimadaAprobacionSolicitud =  "NO"
                objEstadoTramitenuevo3.diasTranscurridos = "0"
                //objEstadoTramitenuevo1.empresaInstaladora = json["nombreCortoEmpresaInstaladora"].stringValue
                //objEstadoTramitenuevo1.instalador = json["nombreInstalador"].stringValue
                
                self.contratosDetalle.append(objEstadoTramitenuevo3)
            }
            
            //4
            if json["etapaAprobacionContratoConcluidaSolicitud"].stringValue == "S" {
                var objEstadoTramitenuevo4 = ContratosDetalleMenu()
                objEstadoTramitenuevo4.estadoNombre = "Habilitación del servicio"
                objEstadoTramitenuevo4.idEstadoSolicitud = 4
                objEstadoTramitenuevo4.descripcion = "La concesionaria de gas natural acudió a tu vivienda a realizar la habilitación del servicio. Es decir, a realizar las pruebas de seguridad, capacitarte y conectarse al gas natural."
                    
                objEstadoTramitenuevo4.fechaInicio = json["fechaFinalizacionInstalacionAcometida"].stringValue
                objEstadoTramitenuevo4.fechaTermino = json["fechaHabilitacionSolicitud"].stringValue
                    var dias: Int = calcularDiasEntreFechas( fechaInicialStr: objEstadoTramitenuevo4.fechaTermino,  fechaFinalStr: objEstadoTramitenuevo4.fechaInicio)
                objEstadoTramitenuevo4.diasTranscurridos = String(dias) + " días"
                objEstadoTramitenuevo4.empresaInstaladora = json["nombreCortoEmpresaConcesionaria"].stringValue
                objEstadoTramitenuevo4.instalador = json["nombreInspector"].stringValue //inspector
                    
                self.contratosDetalle.append(objEstadoTramitenuevo4)
                
            }
                    
            else {
                    
                var objEstadoTramitenuevo2 = ContratosDetalleMenu()
                objEstadoTramitenuevo2.estadoNombre = "Habilitación del servicio"
                objEstadoTramitenuevo2.idEstadoSolicitud = 4
                objEstadoTramitenuevo2.descripcion = "La concesionaria de gas natural acudió a tu vivienda a realizar la habilitación del servicio. Es decir, a realizar las pruebas de seguridad, capacitarte y conectarse al gas natural."
                    
                objEstadoTramitenuevo2.fechaInicio = "NO"
                objEstadoTramitenuevo2.fechaTermino =  "NO"
                objEstadoTramitenuevo2.diasTranscurridos = "0"
                objEstadoTramitenuevo2.empresaInstaladora = "NO"
                objEstadoTramitenuevo2.instalador = "NO" //inspector
                    
                self.contratosDetalle.append(objEstadoTramitenuevo2)
                
                }
            
    }
    
    func calcularDiasEntreFechas(fechaInicialStr: String, fechaFinalStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let fechaInicial = dateFormatter.date(from: fechaInicialStr),
           let fechaFinal = dateFormatter.date(from: fechaFinalStr) {
            let calendario = Calendar.current
            let unidades: Set<Calendar.Component> = [.day]
            
            let diferencia = calendario.dateComponents(unidades, from: fechaInicial, to: fechaFinal)
            
            // Obtiene el número de días de la diferencia
            if let dias = diferencia.day {
                return abs(dias)
            }
        } else {
            print("Error: No se pudo convertir una o ambas fechas.")
        }
        
        return 0
    }

    }
    
    @IBAction func ocultarDetalle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newContratosDetalle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContratosDetalle", for: indexPath) as! contratosdetalleCell

        let f = self.newContratosDetalle[indexPath.row]
       
        cell.lblEstado.text = "  " + f.estadoNombre + "  "
        cell.lblDescripcion.text = f.descripcion
        cell.lblFechaInicio.text = f.fechaInicio
        cell.lblFechaTermino.text = f.fechaTermino
        cell.lblDias.text = f.diasTranscurridos
        cell.lblEmpresaInstaladora.text = f.empresaInstaladora
        cell.lblInstalador.text = f.instalador
        cell.btnEstado.setTitle(String(f.idEstadoSolicitud), for: .normal)
        cell.idEstado = f.idEstadoSolicitud
        return cell
            
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if SelectedIndex == indexPath.row {
            isColapse.toggle() // Cambia el estado de colapso si la celda seleccionada es la misma
        } else {
            isColapse = true // Colapsa la celda anterior y expande la nueva
            SelectedIndex = indexPath.row
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let f = self.newContratosDetalle[indexPath.row]
        if SelectedIndex == indexPath.row && isColapse == true && (f.idEstadoSolicitud == 1 || f.idEstadoSolicitud == 3)  {
            return 240 // Altura expandida
        }
        if SelectedIndex == indexPath.row && isColapse == true && (f.idEstadoSolicitud == 2 || f.idEstadoSolicitud == 4)  {
            return 318 // Altura expandida
        }
        else {
            return 150 // Altura normal
        }
    }
    
    
//Fin clase
}


