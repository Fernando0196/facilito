//
//  DenunciarEViewController.swift
//  facilito
//
//  Created by iMac Mario on 2/05/23.
//

import UIKit
import SwiftyJSON

class DenunciarEViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var tituloMenu: String = ""
    var menu: [DenunciarEMenu] = [DenunciarEMenu]()
    var df : DenunciarEMenu!

    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Recibos excesivos", subtitulo: "Si tu recibo es más alto de lo normal.", nombreImagen: "recibos"),
    
    
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
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellDenunciarE", for: indexPath) as! denunciareCell
        cell.titulo.text = datosMenu.titulo
        cell.tvSubtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = DenunciarEMenu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Recibos excesivos"){
            self.performSegue(withIdentifier: "sgReciboE", sender: self)
        }

      
    }

}
