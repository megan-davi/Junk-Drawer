//
//  ToolDetailVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/26/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class ToolDetailVC: UIViewController {

    // storyboard connections
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var expBoolean: UISwitch!
    @IBOutlet var descriptionField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadToolDetails()
    }
    
    // set large title to current location
    override func viewWillAppear(_ animated: Bool) {  // appears after viewDidLoad()
        title = selectedTool?.title
    }
    
    let realm = try! Realm()
    var selectedTool: Tool? {
        didSet{
            loadToolDetails()
        }
    }
    
    // 👀 READ :: retrieve tool details from realm
    func loadToolDetails() {
        titleLabel.text = selectedTool?.title
        //quantityLabel.text = String(selectedTool?.quantity)
        expBoolean.isOn = selectedTool?.expirationBoolean ?? true
        descriptionField.text = selectedTool?.desc
    }
    

}
