//
//  grifosCell.swift
//  facilito
//
//  Created by iMac Mario on 26/04/23.
//


import Foundation
import UIKit
import Cosmos

class grifosCell : UITableViewCell {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblNombreProducto: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var km: UILabel!
    
    @IBOutlet weak var btnLocalizador: UIButton!
    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    
    @IBOutlet weak var cosmosContainerView: CosmosView!
    
    @IBOutlet weak var btnPrecio: UIButton!

    var precioGrifo: String = ""
    var precioMay: String = ""
    var precioMen: String = ""

    var codigoOsinergmin: String = ""
    var nombreEstablecimiento: String = ""
    var valoracionEstablecimiento: String = ""
    var direccionEstablecimiento: String = ""
    var establecimientosKmFiltro: String = ""
    var ratingFiltro: String = ""
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.filledColor = .yellow
        cosmosView.settings.emptyBorderColor = .yellow
        cosmosView.settings.updateOnTouch = true
        
        configurePrecioButton()
        btnPrecio.roundButton()
        btnLocalizador.roundButton()
        btnPrecio.addShadowOnBottom()

    }
    
    func configurePrecioButton() {
        var buttonBackgroundColor: UIColor
        var borderColor: UIColor

        var fontSize: CGFloat

        if self.precioGrifo == self.precioMay {
            buttonBackgroundColor = UIColor(hex: 0xFE3A46)
            borderColor = UIColor(hex: 0xFE3A46)
            fontSize = 18
        } else if precioGrifo == self.precioMen {
            buttonBackgroundColor = UIColor(hex: 0x029F1D)
            borderColor = UIColor(hex: 0x029F1D)
            fontSize = 18
        } else {
            buttonBackgroundColor = UIColor(hex: 0xF8BD02)
            borderColor = UIColor(hex: 0xF8BD02)
            fontSize = 18
        }
        btnPrecio.backgroundColor = buttonBackgroundColor
        btnPrecio.borderColor = borderColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5.0

        if let buttonFont = UIFont(name: "Poppins-Bold", size: fontSize) {
            let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .font: buttonFont]

            if let precioDouble = Double(self.precioGrifo) {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2

                if let formattedPrice = numberFormatter.string(from: NSNumber(value: precioDouble)) {
                    let combinedText = "S/ " + formattedPrice

                    let attributedString = NSAttributedString(string: combinedText, attributes: attributes)
                    btnPrecio.setAttributedTitle(attributedString, for: .normal)
                }
            }
        
        } else {
            print("Error: No se pudo cargar la fuente 'Poppins-Bold'")
        }
    }
    
    
    
}
