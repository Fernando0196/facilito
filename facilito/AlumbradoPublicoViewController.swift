//
//  AlumbradoPublicoViewController.swift
//  facilito
//
//  Created by iMac Mario on 11/05/23.
//

import UIKit
import SwiftyJSON

class AlumbradoPublicoViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var tituloMenu: String = ""
    var menu: [AlumbradoPublicoMenu] = [AlumbradoPublicoMenu]()
    var df : AlumbradoPublicoMenu!

    struct MenuOpciones{
        let titulo: String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Lámpara apagada o que se prende y apaga constantemente",nombreImagen: "poste"),
    MenuOpciones(titulo: "Lámpara rota o girada", nombreImagen: "poste"),
        MenuOpciones(titulo: "Falta el poste o no tiene lámpara", nombreImagen: "poste"),
    MenuOpciones(titulo: "Árbol interfiere la iluminación del poste", nombreImagen: "poste"),
    MenuOpciones(titulo: "Pantalla que protege la lámpara está rota u opaca", nombreImagen: "poste"),
    MenuOpciones(titulo: "Todos los postes de alumbrado público de la zona están apagados", nombreImagen: "poste"),

    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        tvMenu.dataSource = self


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosMenu.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datosMenu = datosMenu[indexPath.row]
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellAlumbradoPublico", for: indexPath) as! alumbradopublicoCell
        cell.titulo.text = datosMenu.titulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = AlumbradoPublicoMenu()
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

}
