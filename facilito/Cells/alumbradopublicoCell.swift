//
//  alumbradopublicoCell.swift
//  facilito
//
//  Created by iMac Mario on 11/05/23.
//

import Foundation
import UIKit

class alumbradopublicoCell : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titulo: UITextView!
    
    @IBOutlet weak var btnSeleccionarMenu: UIButton!
    @IBOutlet weak var menuView: UIView!
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}

