//
//  SecondVC.swift
//  LocalNotification1H
//
//  Created by shrikant on 15/12/21.
//

import UIKit

class SecondVC: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    var customTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = customTitle
    }
}
