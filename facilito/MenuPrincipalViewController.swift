//
//  MenuPrincipalViewController.swift
//  facilito
//
//  Created by iMac Mario on 18/05/23.
//

import UIKit
import SwiftyJSON


//MENU HAMBURGUESA
class MenuPrincipalViewController: UIViewController, UITextFieldDelegate,UITableViewDataSource {
    
    
    var vIniciarSesion: IniciarSesionViewController!

    @IBOutlet weak var btnPerfil: UIButton!
    
    @IBOutlet weak var vMenu: UIView!
    
    @IBOutlet weak var tvMenu: UITableView!
    
    @IBOutlet weak var tvNombre: UITextView!
    @IBOutlet weak var tvNroDocumento: UITextView!
    
    
    
    @IBOutlet weak var vDatosPersonales: UIView!
    @IBOutlet weak var vCambiarContrasena: UIView!
    @IBOutlet weak var vMisFavoritos: UIView!
    @IBOutlet weak var vDatosTerceros: UIView!
    @IBOutlet weak var vPedidos: UIView!
    @IBOutlet weak var vPantallaInicial: UIView!
    @IBOutlet weak var vCerrarSesion: UIView!
    @IBOutlet weak var vIniciar: UIView!

    
    
    
    var tituloMenu: String = ""
    var menu: [PrincipalMenu] = [PrincipalMenu]()
    var df : PrincipalMenu!

    struct MenuOpciones{
        let titulo: String
        let nombreImagen :String
    }
    
    var datosMenu: [MenuOpciones] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPerfil.roundButton()

        if let iniciarSesion = self.vIniciarSesion {
            
            
            tvNroDocumento.text = self.vIniciarSesion.jsonUsuario["nroDocumento"].stringValue
            tvNombre.text = self.vIniciarSesion.jsonUsuario["nombre"].stringValue + " " + self.vIniciarSesion.jsonUsuario["apellidos"].stringValue
            
            vDatosPersonales.isHidden = false
            vCambiarContrasena.isHidden = false
            vCerrarSesion.isHidden = false
            vIniciar.isHidden = true

            
        } else {
            
            tvNroDocumento.text = ""
            tvNombre.text = "Usuario invitado(a)"
            
            vDatosPersonales.isHidden = true
            vCambiarContrasena.isHidden = true
            vCerrarSesion.isHidden = true
            vIniciar.isHidden = false
          
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.presentedViewController == nil {
            let touch: UITouch? = touches.first
            if let touchView = touch?.view {
                if touchView != self.vMenu {
                    // Ocultar vMenu
                    self.vMenu.isHidden = true
                    
                    // Cerrar la vista MenuPrincipalViewController
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosMenu.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datosMenu = datosMenu[indexPath.row]
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellMenuPrincipal", for: indexPath) as! menuprincipalCell
        cell.titulo.text = datosMenu.titulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = PrincipalMenu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Tuberías expuestas"){
            self.performSegue(withIdentifier: "sgTuberiasExpuestas", sender: self)
        }
        if (self.df.tituloMenu == "Inclumplimiento de normas técnicas"){
            self.performSegue(withIdentifier: "sgIncumplimiento", sender: self)
        }
        if (self.df.tituloMenu == "Llamar a la empresa de gas natural"){
            self.performSegue(withIdentifier: "sgLlamar", sender: self)
        }
      
    }

    
    @IBAction func actualizarDatos(_ sender: Any) {
        
        self.performSegue(withIdentifier: "sgActualizarDatos", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgActualizarDatos") {
            let vc = segue.destination as! ActualizarDatosViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
            
        }
        if (segue.identifier == "sgActuContrasena") {
            let vc = segue.destination as! ActualizarContrasenaViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
   
            
        }
        if (segue.identifier == "sgFavoritos") {
            let vc = segue.destination as! TusFavoritosViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
   
            
        }
        if (segue.identifier == "sgPedidos") {
            let vc = segue.destination as! TusFavoritosViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
   
            
        }
    }
    
    
}
