//
//  balonCell.swift
//  facilito
//
//  Created by iMac Mario on 18/09/23.
//

import Foundation
import UIKit
import Cosmos

class balonCell : UITableViewCell {

    
    @IBOutlet weak var btnPrecio: UIButton!
    @IBOutlet weak var btnLlamar: UIButton!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblNombrePeso: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    

    var precioGalon: Double = 0.0
    var precioMay: Double = 0.0
    var precioMen: Double = 0.0

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.filledColor = .yellow
        cosmosView.settings.emptyBorderColor = .yellow
        cosmosView.settings.updateOnTouch = true

        btnPrecio.roundButton()
        btnLlamar.roundButton()

        configurePrecioButton()
        btnPrecio.addShadowOnBottom()
        btnLlamar.addShadowOnBottom()
    }

    func configurePrecioButton() {
        var buttonBackgroundColor: UIColor
        var borderColor: UIColor

        var fontSize: CGFloat

        if self.precioGalon == self.precioMay {
            buttonBackgroundColor = UIColor(hex: 0xFE3A46)
            borderColor = UIColor(hex: 0xFE3A46)

            fontSize = 18
        } else if precioGalon == self.precioMen {
            buttonBackgroundColor = UIColor(hex: 0x029F1D)
            borderColor = UIColor(hex: 0x029F1D)

            fontSize = 18
        } else {
            buttonBackgroundColor = UIColor(hex: 0xF8BD02)
            borderColor = UIColor(hex: 0xF8BD02)

            fontSize = 18
        }
        
        // Establecer el fondo de color personalizado
        btnPrecio.backgroundColor = buttonBackgroundColor
        btnPrecio.borderColor = borderColor

        // Crear un estilo de texto con un salto de línea después de "S/"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5.0 // Espacio entre las dos líneas de texto (ajústalo según tus preferencias)

        // Definir la fuente y el tamaño del texto en negrita
        if let buttonFont = UIFont(name: "Poppins-Bold", size: fontSize) {
            let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .font: buttonFont]

            // Crear el texto combinado con "S/" y el valor del precio
            let combinedText = "S/\n\(String(format: "%.2f", precioGalon))"

            // Crear el atributo de texto con el estilo y el texto combinado
            let attributedString = NSAttributedString(string: combinedText, attributes: attributes)

            // Establecer el texto del botón con el atributo de texto personalizado
            btnPrecio.setAttributedTitle(attributedString, for: .normal)
        } else {
            print("Error: No se pudo cargar la fuente 'Poppins-Bold'")
        }
    }
}
