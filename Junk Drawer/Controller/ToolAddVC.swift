//
//  ToolAddVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/26/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class ToolAddVC: UIViewController {

    let realm = try! Realm()
    
    var selectedDrawer: Drawer?
    var selectedCategory: Category?
    
    // tool property defaults
    var expBoolean = false
    
    // storyboard connections
    @IBOutlet var titleField: UITextField!
    @IBOutlet var quantityField: UILabel!
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var expirationBoolean: UISwitch!
    @IBOutlet var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change navigation bar appearance
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    // quantity stepper value changed ∴ update quantity label
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        quantityField.text = Int(sender.value).description
    }
    
    // expiration boolean tapped ∴ update expiration boolean property
    @IBAction func expBooleanTapped(_ sender: UISwitch) {
        expBoolean = sender.isOn == true ? true : false
    }
    
    // save button pressed ∴ add new Tool object and save to Realm
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let selectedD = self.selectedDrawer {
            do {
                try self.realm.write {
                    let newTool = Tool()
                    newTool.title = titleField.text ?? ""
                    newTool.image = "garage"
                    newTool.quantity = 1
                    newTool.expirationBoolean = expBoolean
                    newTool.desc = descriptionField.text ?? ""
                    selectedD.tools.append(newTool)
                }
            } catch {
                print("Error saving new tool under drawer \(error)")
            }
        }
        if let selectedC = self.selectedCategory {
            do {
                try self.realm.write {
                    let newTool = Tool()
                    newTool.title = titleField.text ?? ""
                    newTool.image = "garage"
                    newTool.quantity = 1
                    newTool.expirationBoolean = expBoolean
                    newTool.desc = descriptionField.text ?? ""
                    selectedC.tools.append(newTool)
                }
            } catch {
                print("Error saving new tool under category \(error)")
            }
            
        }
        // go back to previous view controller
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    

}
