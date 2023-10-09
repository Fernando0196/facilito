//
//  TabBar.swift
//  facilito
//
//  Created by iMac Mario on 11/10/22.
//
import Foundation
import UIKit


class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.performSegue(withIdentifier: "sgBalonGas", sender: self)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Grifos") as! GrifosViewController
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    



}
