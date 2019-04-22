//
//  EditCategoryVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import ColorPicker

class EditCategoryVC: UIViewController, ColorPickerDelegate {
    
    @IBOutlet var colorPickerView: ColorPickerListView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var drawerSwitch: UISwitch!

    var selectedCategory: Category?
    
    func colorPicker(_ colorPicker: ColorPickerListView, selectedColor: String) {
        colorView.backgroundColor = UIColor.colorWithHexString(selectedColor)
    }
    
    func colorPicker(_ colorPicker: ColorPickerListView, deselectedColor: String) {
        colorView.backgroundColor = UIColor.white
    }
    
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationItem.hidesBackButton = true
        saveButton.layer.cornerRadius = 4
        
     
        
    }

    @IBAction func saveButton(_ sender: Any) {
        // drawer switch is off ∴ set drawer boolean to false
        if drawerSwitch.isOn {} else {selectedCategory?.drawerBoolean = false}
    }
    
}
