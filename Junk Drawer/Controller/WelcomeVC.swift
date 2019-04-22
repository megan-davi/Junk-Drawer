//
//  WelcomeVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import ChameleonFramework

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }


}
