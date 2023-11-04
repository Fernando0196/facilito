//
//  IniciarRutaViewController.swift
//  facilito
//
//  Created by iMac Mario on 31/10/23.
//



import UIKit
import SwiftyJSON

class IniciarRutaViewController: UIViewController, UITextFieldDelegate {
    
    var vMapa: GrifosMapaViewController!


    @IBOutlet weak var btnCerrar: UIButton!
    @IBOutlet weak var btnContinuarApp: UIButton!
    @IBOutlet weak var btnGoogleMaps: UIButton!
    @IBOutlet weak var btnWaze: UIButton!
    @IBOutlet weak var vRuta: UIView!
    @IBOutlet weak var vCalificacion: UIView!
    
    @IBOutlet weak var btnCalificar: UIButton!
    @IBOutlet weak var btnReportar: UIButton!
    @IBOutlet weak var btnMuyMalo: UIButton!
    @IBOutlet weak var btnMalo: UIButton!
    @IBOutlet weak var btnNeutro: UIButton!
    @IBOutlet weak var btnBueno: UIButton!
    @IBOutlet weak var btnMuyBueno: UIButton!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    var latitudRuta: String = ""
    var longitudRuta: String = ""
        
    var correo: String = ""
    var token: String = ""
    var codOsinergmin: Int = 0
    var valoracion: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinuarApp.roundButton()
        btnGoogleMaps.roundButton()
        btnWaze.roundButton()
        vRuta.roundView()
        vCalificacion.roundView()
        btnCalificar.roundButton()
        btnReportar.roundButton()

        latitudRuta = vMapa.latitudRuta
        longitudRuta = vMapa.longitudRuta
        codOsinergmin = Int(vMapa.codigoOsinergmin)!

        vCalificacion.isHidden = true
        
    }
    
    
    @IBAction func cerrarAlert(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func abrirRutaApp(_ sender: Any) {
        self.performSegue(withIdentifier: "sgRuta", sender: self)

    }
    
    //para navegador web
    @IBAction func openGoogleMaps(_ sender: UIButton) {
        let latitude = latitudRuta
        let longitude = longitudRuta

        let alert = UIAlertController(title: "Navegación asistida",
                                      message: "Usted ha elegido navegar con Google Maps. ¿Desea continuar?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            if let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(googleMapsURL) {
                    UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
                } else {
                    let installAlert = UIAlertController(title: "Google Maps no está instalado",
                                                        message: "¿Desea instalar Google Maps desde la App Store?",
                                                        preferredStyle: .alert)
                    installAlert.addAction(UIAlertAction(title: "Instalar", style: .default) { _ in
                        if let appStoreURL = URL(string: "https://itunes.apple.com/us/app/google-maps/id585027354?mt=8") {
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { (success) in
                                if success {
                                    self.vCalificacion.isHidden = false
                                    self.vRuta.isHidden = true
                                }
                            })
                        }
                    })
                    installAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    self.present(installAlert, animated: true, completion: nil)
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    //ABRE NAVEGADOR WEB
   /* if let url = URL(string: "https://www.google.com/maps?q=\(latitude),\(longitude)") {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "No se puede abrir Google Maps en el navegador",
                                          message: "Asegúrate de tener un navegador web instalado para abrir Google Maps en el navegador.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }*/
    
    @IBAction func openWaze(_ sender: UIButton) {
        let latitude = latitudRuta
        let longitude = longitudRuta

        let alert = UIAlertController(title: "Navegación asistida",
                                      message: "Usted ha elegido navegar con Waze. ¿Desea continuar?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            if let wazeURL = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes") {
                if UIApplication.shared.canOpenURL(wazeURL) {
                    UIApplication.shared.open(wazeURL, options: [:], completionHandler: nil)
                } else {
                    let installAlert = UIAlertController(title: "Waze no está instalado",
                                                        message: "¿Desea instalar Waze desde la App Store?",
                                                        preferredStyle: .alert)
                    installAlert.addAction(UIAlertAction(title: "Instalar", style: .default) { _ in
                        if let appStoreURL = URL(string: "https://itunes.apple.com/app/id323229106") {
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { (success) in
                                if success {
                                    self.vCalificacion.isHidden = false
                                    self.vRuta.isHidden = true
                                }
                            })
                        }
                    })
                    installAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    self.present(installAlert, animated: true, completion: nil)
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cerrarCalificacion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func botonPresionado(_ sender: UIButton) {
        // Desactivar todos los botones
        btnMuyMalo.backgroundColor = UIColor.clear
        btnMalo.backgroundColor = UIColor.clear
        btnNeutro.backgroundColor = UIColor.clear
        btnBueno.backgroundColor = UIColor.clear
        btnMuyBueno.backgroundColor = UIColor.clear

        // Activar el botón seleccionado
        sender.backgroundColor = UIColor.red
    }
    
    @IBAction func calificarGrifo(_ sender: Any) {
        
        let correo = "rubefer1901@gmail.com"
        let token = "d826194dc375b0bd0cc72583de55f120599319dc"
        let codOsinergmin = self.codOsinergmin
        let tipoServicio = 0
        let valoracion = 5
        
        self.showActivityIndicatorWithText(msg: "Registrando...", true, 200)
        let ac = APICaller()
        ac.PostCalificarGrifo(correo: correo, token: token, codOsinergmin: codOsinergmin, tipoServicio: tipoServicio, valoracion: valoracion, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if (json["valorarGrifoOutRO"]["resultCode"].intValue == 1) {
                             let alertController = UIAlertController(title: "Establecimiento calificado", message: nil, preferredStyle: .alert)
                             alertController.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                                 self.dismiss(animated: true, completion: nil)
                             })
                             self.present(alertController, animated: true, completion: nil)
                         } else {
                            self.displayMessage = "No se pudo calificar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo calificar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo calificar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo calificar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
     
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgRuta") {
            let vc = segue.destination as! RutaViewController
            vc.vIniciarRuta = self
        }

    }
    
    
//Fin clase
}
