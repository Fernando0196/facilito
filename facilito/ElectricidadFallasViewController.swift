//
//  ElectricidadFallasViewController.swift
//  facilito
//
//  Created by iMac Mario on 22/02/23.
//

import UIKit
import SwiftyJSON

class ElectricidadFallasViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var tituloMenu: String = ""
    var menu: [ElectricidaFallasdMenu] = [ElectricidaFallasdMenu]()
    var df : ElectricidaFallasdMenu!

    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Interrupción de servicio eléctrico", subtitulo: "Un apagón en tu barrio, comunidad o distrito.", nombreImagen: "interrupcion"),
    
    MenuOpciones(titulo: "Alumbrado público", subtitulo: "Si vez la luz del poste apagada o rota, un árbol tapa la luz, etc.", nombreImagen: "alumbrado"),
    
    MenuOpciones(titulo: "Daño de artefactos eléctricos", subtitulo: "Cuando tus artefactos se encienden y apagan muchas veces.", nombreImagen: "daño_artefacto"),
    
    MenuOpciones(titulo: "Peligro por postes o cables", subtitulo: "Si vez un medidor expuesto, cables caídos, postes dañados.", nombreImagen: "peligro_poste"),
    
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
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellElectricidadFallas", for: indexPath) as! electricidadfallasCell
        cell.titulo.text = datosMenu.titulo
        cell.tvSubtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = ElectricidaFallasdMenu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Interrupción de servicio eléctrico"){
            self.performSegue(withIdentifier: "sgInterrupcion", sender: self)
        }
        if (self.df.tituloMenu == "Alumbrado público"){
            self.performSegue(withIdentifier: "sgAlumbrado", sender: self)
        }
        if (self.df.tituloMenu == "Daño de artefactos eléctricos"){
            self.performSegue(withIdentifier: "sgDano", sender: self)
        }
        if (self.df.tituloMenu == "Peligro por postes o cables"){
            self.performSegue(withIdentifier: "sgPeligro", sender: self)
        }
      
    }

}
