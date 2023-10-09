//
//  PrevioReporteViewController.swift
//  facilito
//
//  Created by iMac Mario on 4/10/23.
//



import UIKit
import SwiftyJSON

class PrevioReporteViewController: UIViewController, UITextFieldDelegate {
    
    var vParent: TuberiasExpuestasViewController!
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    @IBOutlet weak var vPregunta: UIView!
    @IBOutlet weak var vConfirmado: UIView!
    
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var lblUbicacion: UILabel!
    @IBOutlet weak var lblDescripción: UILabel!
    @IBOutlet weak var lblEmpresa: UILabel!
    
    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var btnContinuar: UIButton!
    
    @IBOutlet weak var lblReporte: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegresar.roundButton()
        btnContinuar.roundButton()

        vPregunta.roundView()
        vConfirmado.roundView()
        vConfirmado.isHidden = true
        vPregunta.isHidden = false

        lblAsunto.applyCustomFormatToHeader(headerText: "Asunto: ", contentText: vParent.asuntoDescripcion)
        lblUbicacion.applyCustomFormatToHeader(headerText: "Ubicación de denuncia: ", contentText: vParent.direccion)
        lblDescripción.applyCustomFormatToHeader(headerText: "Descripción: ", contentText: vParent.descripcionInconformidad)
        lblEmpresa.applyCustomFormatToHeader(headerText: "Empresa: ", contentText: vParent.nombreEmpresa)
        
        
    }
    
    @IBAction func regresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func enviarReporte(_ sender: Any) {
                
        let sector = vParent.sector
        let motivo = vParent.motivo
        let asunto = vParent.asunto
        let dni = vParent.dni
        let descripcionInconformidad = vParent.descripcionInconformidad
        let coordenada_x = vParent.coordenada_x
        let coordenada_y = vParent.coordenada_y
        let nroSuministro = vParent.nroSuministro
        let telefono = vParent.telefono
        let correo = vParent.correo
        let nombre = vParent.nombre
        let apellidoPaterno = vParent.apellidoPaterno
        let apellidoMaterno = vParent.apellidoMaterno
        let mesesAfectados = vParent.mesesAfectados
        let codigoCanalRegistro = vParent.codigoCanalRegistro
        let listaUAP = vParent.listaUAP
        let listaFotos = vParent.listaFotos
        let nombreEmpresa = vParent.nombreEmpresa

         let ac = APICaller()
         self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
         ac.PostReportar(sector: sector, motivo: motivo, asunto: asunto, dni: dni, descripcionInconformidad: descripcionInconformidad, coordenada_x: coordenada_x, coordenada_y: coordenada_y, nroSuministro: nroSuministro, telefono: telefono, correo: correo, nombre: nombre, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno, mesesAfectados: mesesAfectados, codigoCanalRegistro: codigoCanalRegistro, listaUAP: listaUAP, listaFotos: listaFotos, nombreEmpresa: nombreEmpresa) { (success, result, code) in
             self.hideActivityIndicatorWithText()
             if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                 do {
                     let json = try JSON(data: dataFromString)
                     if !json["nroInconformidad"].stringValue.isEmpty {
                         self.lblReporte.applyCustomFormatToHeader(headerText: "Reporte Nº ", contentText: json["nroInconformidad"].stringValue)
                         self.vConfirmado.isHidden = false
                         self.vPregunta.isHidden = true
                         
                     }
                     else{
                         self.displayMessage = "No se pudo reportar, vuelve a intentar"
                         self.performSegue(withIdentifier: "sgDM", sender: self)
                     }
                 } catch {
                     self.displayMessage = "No se pudoreportar, vuelve a intentar"
                     self.performSegue(withIdentifier: "sgDM", sender: self)
                 }
             } else {
                 self.displayMessage = "No se pudo reportar, vuelve a intentar"
                 self.performSegue(withIdentifier: "sgDM", sender: self)
             }
         }


    }
    
    @IBAction func volverInicio(_ sender: Any) {
        self.performSegue(withIdentifier: "sgTuberias", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgTuberias") {
            let vc = segue.destination as! TuberiasExpuestasViewController
           // vc.vParent = self
        }
    }
    
    
    
    
    
//Fin clase
}
