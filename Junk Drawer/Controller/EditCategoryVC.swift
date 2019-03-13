//
//  EditCategoryVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit

class EditCategoryVC: UIViewController {
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationItem.hidesBackButton = true
        saveButton.layer.cornerRadius = 4
    }
    

    @IBAction func saveButton(_ sender: Any) {
        
    }
    
}
