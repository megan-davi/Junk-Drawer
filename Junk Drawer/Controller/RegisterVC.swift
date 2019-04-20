//
//  RegisterVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD   

class RegisterVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // allow VC to see email and password text fields

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // when the register button is pressed, sign user up using Firebase
    @IBAction func registerButtonPressed(_ sender: Any) {
        SVProgressHUD.show()    // show loading symbol
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
                SVProgressHUD.dismiss()   // dismiss loading symbol
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
    
}
