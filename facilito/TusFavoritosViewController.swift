//
//  TusFavoritosViewController.swift
//  facilito
//
//  Created by iMac Mario on 20/07/23.
//

import UIKit
import Foundation
import SwiftyJSON
import DropDown
import Cosmos

class TusFavoritosViewController: UIViewController {
    
    var vIniciarSesion: IniciarSesionViewController!

    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMensajeSiInSesion: UILabel!
    
    var vParentFavoritosCell: favoritosCell!
    
    var tituloMenu: String = ""
    var idUsuario: Int = 0
    var correo: String = ""

    var favoritos: [FavoritosMenu] = [FavoritosMenu]()
    var df : FavoritosMenu!
    
    let tvFavoritos = UITableView()
    var nombreUnidad: String = ""
    var valoracion: String = ""

    
    struct MenuOpciones{
        let titulo: String
        let km : String
        let nombreImagen :String
    }
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.roundButton()

        
        //Datos USUARIO
        if let iniciarSesion = self.vIniciarSesion {
            
            tableView.isHidden = false
            lblMensajeSiInSesion.isHidden = true

            idUsuario = self.vIniciarSesion.jsonUsuario["idUsuario"].intValue
            
            tableView.allowsSelection = false
            tableView.dataSource = self
            tableView.delegate = self

            self.listarFavoritos()
            
        }
        else {
            tableView.isHidden = true
            lblMensajeSiInSesion.isHidden = false
        }

        


    }
    
    private func listarFavoritos() {
        //let available = UserDefaults.standard.value(forKey: "available") as! Bool
        let ac = APICaller()
        self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
        ac.PostListarFavoritos(idUsuario, completion: { (success, result, code) in
            self.hideActivityIndicatorWithText()
            debugPrint(result!)
            if (success && code == 200) {
                if let dataFromString = result!.data(using: .utf8, allowLossyConversion: false) {
                     do {
                        let json = try JSON(data: dataFromString)
                        
                         if !json["favorito"].arrayValue.isEmpty {
                             var uniqueUnidades = Set<String>()
                             var favoritosSinDuplicados: [FavoritosMenu] = []

                             let jRecords = json["favorito"].sorted(by: <)

                             for (_, subJson): (String, JSON) in jRecords {
                                 let f = FavoritosMenu()
                                 f.nombreUnidad = subJson["nombreUnidad"].stringValue
                                 f.valoracion = subJson["valoracion"].stringValue

                                 
                                 
                                 if !uniqueUnidades.contains(f.nombreUnidad) {
                                     favoritosSinDuplicados.append(f)
                                     uniqueUnidades.insert(f.nombreUnidad)
                                 }
                             }
                             self.favoritos = favoritosSinDuplicados
                         }
                          else {
                            self.displayMessage = json["Mensaje"].stringValue
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obetener favoritos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    self.displayMessage = "No se pudo obetener favoritos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
            } else {
                debugPrint("error")
                self.displayMessage = "No se pudo obetener favoritos, vuelve a intentar"
                self.performSegue(withIdentifier: "sgDM", sender: self)
            }
            //recargar
            print(self.favoritos.count)
            self.tableView.reloadData()
        })
    }

    @IBAction func mostrarInformacionHorario(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

//Fin clase
}




extension TusFavoritosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("conteo")
        return self.favoritos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFavoritos") as! favoritosCell
       
        let f = self.favoritos[indexPath.row]
        
        cell.titulo.text = f.nombreUnidad
        
        let doubleValue = Double(f.valoracion)
        
        cell.cosmosContainerView.rating = doubleValue ?? 0.0
        //idAdjunto = f.id
        cell.btnSeleccionarFavorito.tag = indexPath.item
        cell.btnSeleccionarFavorito.addTarget(self, action: #selector(self.btnSeleccionarFavoritoPressed(_:)), for: .touchUpInside)
               
        return cell
    }
    
    @objc func btnSeleccionarFavoritoPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.favoritos[sender.tag]
    /*    self.idAdjunto = self.df.id
        self.adju_estado = self.df.eadjId
        self.adju_Id = self.df.adjuId
        self.idCond = self.id_conductor

        self.titulo = self.df.nombre
        self.subtitulo = self.df.adjuObservacion
*/


        self.performSegue(withIdentifier: "sgDetalleFavorito", sender: self)



    }
}
