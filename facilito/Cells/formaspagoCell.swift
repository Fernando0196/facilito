//
//  formaspagoCell.swift
//  facilito
//
//  Created by iMac Mario on 29/08/23.
//

import Foundation
import UIKit

class formaspagoCell : UITableViewCell {
    

    @IBOutlet weak var tvFormaPago: UITextView!
    @IBOutlet weak var btnTarjeta: UIButton!
    @IBOutlet weak var btnTarjeta2: UIButton!
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
