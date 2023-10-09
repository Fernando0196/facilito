//
//  FallasProblemasViewController.swift
//  facilito
//
//  Created by iMac Mario on 9/02/23.
//


import UIKit
import SwiftyJSON

class FallasProblemasViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var tituloMenu: String = ""
    var menu: [ProblemasFallasMenu] = [ProblemasFallasMenu]()
    var df : ProblemasFallasMenu!

    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Tuberías expuestas", subtitulo: "Si vez descubierta una tubería en la vía pública.", nombreImagen: "tuberia"),
    
    MenuOpciones(titulo: "Inclumplimiento de normas técnicas", subtitulo: "Si vez que el trabajo implica riesgo para otras personas.", nombreImagen: "fallas"),
    
    MenuOpciones(titulo: "Llamar a la empresa de gas natural", subtitulo: "Reporta cualquier otro problema con el servicio de gas natural.", nombreImagen: "telefono"),
    
    
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
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellFallasProblemas", for: indexPath) as! fallasproblemasCell
        cell.titulo.text = datosMenu.titulo
        cell.tvSubtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = ProblemasFallasMenu()
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
