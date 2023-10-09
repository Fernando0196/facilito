//
//  electricidadfallasCell.swift
//  facilito
//
//  Created by iMac Mario on 22/02/23.
//

import Foundation
import UIKit

class electricidadfallasCell : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tvSubtitulo: UITextView!

    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    @IBOutlet weak var menuView: UIView!
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
