//
//  ProcesosCostosViewController.swift
//  facilito
//
//  Created by iMac Mario on 29/12/22.
//

import UIKit
import SwiftyJSON

class ProcesosCostosViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var tvMenu: UITableView!
    
    @IBOutlet weak var vMenu: UIView!
    
    var tituloMenu: String = ""
    var menu: [ProcesoCostoMenu] = [ProcesoCostoMenu]()
    var df : ProcesoCostoMenu!
    
    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Proceso de instalación", subtitulo: "Descubre los pasos para la instalación.", nombreImagen: "proceso_instalacion"),
    
    MenuOpciones(titulo: "Costo de instalación", subtitulo: "Aprende los pormenores y un estimado del costo, también podrás conocer quienes pueden hacer este trabajo.", nombreImagen: "costo"),
      
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
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellProcesoCosto", for: indexPath) as! procesocostoCell
        cell.titulo.text = datosMenu.titulo
        cell.tvSubtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = ProcesoCostoMenu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Proceso de instalación"){
            self.performSegue(withIdentifier: "sgProcesoInstalacion", sender: self)
        }
        if (self.df.tituloMenu == "Costo de instalación"){
            self.performSegue(withIdentifier: "sgCostoInstalacion", sender: self)
        }
 
    }

}
