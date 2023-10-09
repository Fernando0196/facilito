//
//  DenunciarViewController.swift
//  facilito
//
//  Created by iMac Mario on 16/02/23.
//



import UIKit
import SwiftyJSON

class DenunciarViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tvMenu: UITableView!
    
    var tituloMenu: String = ""
    var menu: [DenunciarMenu] = [DenunciarMenu]()
    var df : DenunciarMenu!

    struct MenuOpciones{
        let titulo: String
        let subtitulo : String
        let nombreImagen :String
    }
    
    let datosMenu: [MenuOpciones] = [
    MenuOpciones(titulo: "Recibos excesivos", subtitulo: "Si tu recibo es más alto de lo normal.", nombreImagen: "recibos"),
    
    MenuOpciones(titulo: "Llamar a la empresa eléctrica", subtitulo: "Reporta cualquier otro problema con el servicio de gas natural.", nombreImagen: "telefono"),
    
    
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
        let cell = tvMenu.dequeueReusableCell(withIdentifier: "cellDenunciar", for: indexPath) as! denunciarCell
        cell.titulo.text = datosMenu.titulo
        cell.tvSubtitulo.text = datosMenu.subtitulo
        cell.img.image = UIImage(named: datosMenu.nombreImagen)
        cell.btnSeleccionarMenu.tag = indexPath.item

        let m = DenunciarMenu()
        m.tituloMenu = datosMenu.titulo
        self.menu.append(m)
        
        cell.btnSeleccionarMenu.addTarget(self, action: #selector(self.btnSeleccionarMenuPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSeleccionarMenuPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.menu[sender.tag]
        
        
        if (self.df.tituloMenu == "Recibos excesivos"){
            self.performSegue(withIdentifier: "sgRecibo", sender: self)
        }
        if (self.df.tituloMenu == "Llamar a la empresa eléctrica"){
            self.performSegue(withIdentifier: "sgLlamar", sender: self)
        }

      
    }

}


