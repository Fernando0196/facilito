//
//  telefonosCell.swift
//  facilito
//
//  Created by iMac Mario on 29/08/23.
//

import Foundation
import UIKit

class telefonosCell : UITableViewCell {
    
    @IBOutlet weak var telefono: UITextView!

    @IBOutlet weak var btnLlamar: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
    }
}
