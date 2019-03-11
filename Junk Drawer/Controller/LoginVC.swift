//
//  LoginVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // allow VC to see email and password text fields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    // when the login button is pressed, log user in using Firebase
    @IBAction func loginButtonPressed(_ sender: Any) {
        SVProgressHUD.show()    // show loading symbol
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Log in successful!")
                SVProgressHUD.dismiss()   // dismiss loading symbol
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }


}
