//
//  PreguntasFrencuentesViewController.swift
//  facilito
//
//  Created by iMac Mario on 27/01/23.
//



import UIKit
import SwiftyJSON



class PreguntasFrecuentesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!


    
    var pregunta = ["1. ¿Qué es el gas natural?","2. ¿Cuáles son los usos del gas natural?","3. ¿Dónde se encuentra y cómo se extrae el gas natural?","4. ¿Cuáles son las ventajas del gas natural?","5. ¿Es seguro el gas natural?"]
    var respuesta = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore  Nam liber te conscient to factor tum poen legum odioque civiuda.","Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore  Nam liber te conscient to factor tum poen legum odioque civiuda.","Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore  Nam liber te conscient to factor tum poen legum odioque civiuda.","Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore  Nam liber te conscient to factor tum poen legum odioque civiuda.","Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore  Nam liber te conscient to factor tum poen legum odioque civiuda."]

    var SelectedIndex = -1
    var isColapse = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.roundButton()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self // 3
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 340
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pregunta.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SelectedIndex == indexPath.row && isColapse == true{
            return 340
        }
        else{
            return 60
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! preguntasCell
        cell.lblTitulo?.text = pregunta[indexPath.row]
        cell.tvSubtitulo?.text = respuesta[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if SelectedIndex == indexPath.row {
            if isColapse == false {
                isColapse = true
            }  else{
                isColapse = false
            }
        }
        else{
            isColapse = true
        }
        SelectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
