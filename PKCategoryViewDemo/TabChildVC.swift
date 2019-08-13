//
//  TabChildVC.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TabChildVC: UIViewController {

    @IBOutlet weak var msgLabel: UILabel!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.msgLabel.text = message.isEmpty ? "It's child" : message
    }
}
