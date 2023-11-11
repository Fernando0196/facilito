//
//  PedidosViewController.swift
//  facilito
//
//  Created by iMac Mario on 6/11/23.
//



import UIKit
import SwiftyJSON

class PedidosViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var tvMenu: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var displayMessage: String = ""
    var displayTitle: String = "Facilito"
    
    var pedidos: [PedidosMenu] = [PedidosMenu]()
    var df : PedidosMenu!
    var nombre: String = ""
    var fechaHora: String = ""
    var valoracion: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnBack.roundButton()
        self.listarPedidos()
        
        
        tvMenu.allowsSelection = false
        tvMenu.dataSource = self
        tvMenu.delegate = self

    }
    
    
    private func listarPedidos() {

        self.pedidos.removeAll()
        
        let idUsuario = 60045
        
     
            let ac = APICaller()
            self.showActivityIndicatorWithText(msg: "Cargando...", true, 200)
            ac.GetListarPedidos(idUsuario) { (success, result, code) in
                self.hideActivityIndicatorWithText()
                if success, code == 200, let dataFromString = result?.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let json = try JSON(data: dataFromString)
                        if !json["listaBaloncitoPedidoOutRO"]["listaPedidos"].arrayValue.isEmpty {
                            let jRecords = json["listaBaloncitoPedidoOutRO"]["listaPedidos"].arrayValue
                            
                            
                            for (_, subJson) in jRecords.enumerated() {
                                let f = PedidosMenu()
                                
                                f.codigoOsinergmin = subJson["idPedido"].stringValue
                                f.tituloMenu = subJson["nombreUnidad"].stringValue
                                f.valoracion = subJson["valoracion"].stringValue
                                f.fechaHora = subJson["fecha"].stringValue
                                f.nombreProducto = subJson["nombreUnidad"].stringValue

                                self.pedidos.append(f)

                            }
                            print("Total pedidos: \(self.pedidos.count)")

                            self.tvMenu.reloadData()

                        } else {
                            self.displayMessage = "No se pudo obtener pedidos, vuelve a intentar"
                            self.performSegue(withIdentifier: "sgDM", sender: self)
                        }
                    } catch {
                        self.displayMessage = "No se pudo obtener pedidos, vuelve a intentar"
                        self.performSegue(withIdentifier: "sgDM", sender: self)
                    }
                } else {
                    debugPrint("error")
                    self.displayMessage = "No se pudo obtener pedidos, vuelve a intentar"
                    self.performSegue(withIdentifier: "sgDM", sender: self)
                }
                
                //recargar
                print(self.pedidos.count)
                self.tvMenu.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sgDetallePedido") {
            let vc = segue.destination as! PedidoRealizadoViewController
            vc.vPedidos = self
            
        }
        if (segue.identifier == "sgDM") {
            let vc = segue.destination as! NotificacionViewController
            vc.message = self.displayMessage
            vc.header = self.displayTitle
        }
    }
    
    
    
    
//Fin clase
}


extension PedidosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("conteo")
        return self.pedidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPedidos") as! pedidosCell
       
        let f = self.pedidos[indexPath.row]
        
        cell.nombre.text = f.nombreProducto
        cell.fechaHora.text = f.fechaHora

        let doubleValue = Double(f.valoracion)
        
        cell.cosmosContainerView.rating = doubleValue ?? 0.0
        //idAdjunto = f.id
        cell.btnSeleccionarPedido.tag = indexPath.item
        cell.btnSeleccionarPedido.addTarget(self, action: #selector(self.btnSeleccionarPedidoPressed(_:)), for: .touchUpInside)
            
        return cell
    }
    
    @objc func btnSeleccionarPedidoPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        self.df = self.pedidos[sender.tag]
        
        self.nombre = self.df.nombreProducto
        self.fechaHora = self.df.fechaHora
        self.valoracion = self.df.valoracion

        
        self.performSegue(withIdentifier: "sgDetallePedido", sender: self)


    }
    
    
    
}
