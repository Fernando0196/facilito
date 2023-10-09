//
//  PrincipalViewController.swift
//  facilito
//
//  Created by iMac Mario on 5/10/22.
//
import UIKit
import Foundation
import SwiftyJSON

class PrincipalViewController: UIViewController, UITableViewDataSource {
    
    var vIniciarSesion: IniciarSesionViewController!

    //se volvió a agregar
    var vParentRegistro: RegistrarUsuario2ViewController!
    var vActualizarDatos: ActualizarDatosViewController!

    var tituloMenu: String = ""
    var menu: [Menu] = [Menu]()
    var df : Menu!
    
    //DATOS PERSONALES
    var nroDocumento: String = ""
    var nombreUsua: String = ""
    var apellidoUsua: String = ""
    var correoUsua: String = ""
    var telefonoUsua: String = ""

    
    @IBOutlet weak var tvMenu: UITableView!
    @IBOutlet weak var btnDenunciar: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Grifos", subtitulo: "Todas las gasolineras para tu automóvil", nombreImagen: "menu_grifos"),
    MenuOpciones(titulo: "Balón de gas", subtitulo: "Conoce a todos los proveedores formales", nombreImagen: "menu_balongas"),
    MenuOpciones(titulo: "Electricidad", subtitulo: "Mapas del alumbrado público y reportes", nombreImagen: "menu_electricidad"),
    MenuOpciones(titulo: "Gas natural", subtitulo: "Conoce los beneficios y reporta incidencias", nombreImagen: "menu_gasnatural"),
    MenuOpciones(titulo: "Trámites", subtitulo: "Conoce el estado de tus solicitudes", nombreImagen: "menu_tramites")
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nroDocumento = self.vIniciarSesion.jsonUsuario["nroDocumento"].stringValue
        nombreUsua = self.vIniciarSesion.jsonUsuario["nombre"].stringValue
        apellidoUsua = self.vIniciarSesion.jsonUsuario["apellidos"].stringValue
        correoUsua = self.vIniciarSesion.jsonUsuario["correo"].stringValue
        telefonoUsua = self.vIniciarSesion.jsonUsuario["11345678"].stringValue

        btnMenu.roundButton()
        
        tvMenu.dataSource = self
        self.tabBarController?.tabBar.isHidden = true
        btnDenunciar.roundButton()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datosMenu = datosMenu[indexPath.row]
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! menuCell
        cell.titulo.text = datosMenu.titulo
        cell.subtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = Menu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Grifos"){
            self.performSegue(withIdentifier: "sgGrifos", sender: self)
        }
        if (self.df.tituloMenu == "Balón de gas"){
            self.performSegue(withIdentifier: "sgBalonGas", sender: self)
        }
        if (self.df.tituloMenu == "Electricidad"){
            self.performSegue(withIdentifier: "sgElectricidad", sender: self)
        }
        if (self.df.tituloMenu == "Gas natural"){
            self.performSegue(withIdentifier: "sgGasNatural", sender: self)
        }
        if (self.df.tituloMenu == "Trámites"){
            self.performSegue(withIdentifier: "sgTramites", sender: self)
        }
    }

    @IBAction func btnMostrarBalonGas(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgGrifos", sender: self)
        
    }
    
    @IBAction func btnMostrarMenuHamburguesa(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgMenuHamburguesa", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgMenuHamburguesa") {
            let vc = segue.destination as! MenuPrincipalViewController
            //enviar datos del usuario
            vc.vIniciarSesion = self.vIniciarSesion
   
            
        }

    }
    
    
}
