//
//  PedidoRealizadoViewController.swift
//  facilito
//
//  Created by iMac Mario on 6/11/23.
//



import UIKit
import SwiftyJSON
import Cosmos

class PedidoRealizadoViewController: UIViewController, UITextFieldDelegate {
    
    var vPedidos: PedidosViewController!


    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvFechaHora: UITextView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var btnLlamar: UIButton!
    @IBOutlet weak var tvDescripcion: UIFloatingLabeledTextView!
    
    @IBOutlet weak var btnCalificar: UIButton!
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var cosmosContainerView: CosmosView!

    @IBOutlet weak var btnMuyMalo: UIButton!
    @IBOutlet weak var btnMalo: UIButton!
    @IBOutlet weak var btnNeutro: UIButton!
    @IBOutlet weak var btnBueno: UIButton!
    @IBOutlet weak var btnMuyBueno: UIButton!
    
    @IBOutlet weak var vDetalle: UIView!
    
    var idPedidos: Int = 0
    var calificacion: Int = 0
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        btnLlamar.roundButton()
        btnReportar.roundButton()
        btnCalificar.roundButton()
        tvDescripcion.layer.cornerRadius = 5
        tvFechaHora.text = vPedidos.fechaHora
        lblNombre.text = vPedidos.nombre
        cosmosContainerView.rating = Double(vPedidos.valoracion) ?? 0.0
        let idPedido = Int(vPedidos.df.codigoOsinergmin)
        self.idPedidos = idPedido ?? 0
        vDetalle.roundView()
        vDetalle.addCardShadow()

    }
    
    @IBAction func botonPresionado(_ sender: UIButton) {

        btnMuyMalo.backgroundColor = UIColor.clear
        btnMalo.backgroundColor = UIColor.clear
        btnNeutro.backgroundColor = UIColor.clear
        btnBueno.backgroundColor = UIColor.clear
        btnMuyBueno.backgroundColor = UIColor.clear

        sender.backgroundColor = UIColor.red
        
        if sender == btnMuyMalo {
            self.calificacion = 1
        } else if sender == btnMalo {
            self.calificacion = 2
        } else if sender == btnNeutro {
            self.calificacion = 3
        } else if sender == btnBueno {
            self.calificacion = 4
        } else if sender == btnMuyBueno {
            self.calificacion = 5
        }
    }
    
    
    @IBAction func calificar(_ sender: Any) {
                    
        let idPedido = idPedidos
        
        guard self.calificacion != 0 else {
            self.displayMessage = "Califique el servicio."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            return
        }
        
        let estadoInconformidad = 1

        guard let comentario = tvDescripcion.text, !comentario.isEmpty else {
            self.displayMessage = "Cuéntanos sobre la atención."
            self.performSegue(withIdentifier: "sgDM", sender: self)
            return
        }

            let nroInconformidad = ""
         
                let ac = APICaller()
                self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
            ac.PutRegistrarCalificacion(idPedido: idPedido,calificacion: calificacion,estadoInconformidad: estadoInconformidad,comentario: comentario,nroInconformidad: nroInconformidad) { (success, result, code) in
                    self.hideActivityIndicatorWithText()
                    if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON(data: dataFromString)
                            if (json["actualizarPedidoOutRO"]["resultCode"].intValue == 1) {
                                let alertController = UIAlertController(title: "Gracias por la calificación.", message: "Esta información nos ayuda a mejorar los servicios y la vida de otros usuarios.", preferredStyle: .alert)

                                alertController.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                                    self.dismiss(animated: true, completion: nil)
                                })

                                self.present(alertController, animated: true, completion: nil)
                                
                                
                            } else {
                                self.displayMessage = "No se pudo registrar pedidos, vuelve a intentar"
                                self.performSegue(withIdentifier: "sgDM", sender: self)
                            }
                        } catch {
                            self.displayMessage = "No se pudo registrar pedidos, vuelve a intentar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } else {
                        debugPrint("error")
                        self.displayMessage = "No se pudo registrar pedidos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }

            }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    
    
//Fin clase
}
