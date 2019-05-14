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
    @IBOutlet var imageView: UIImageView!
    
    let realm = try! Realm()
    var selectedTool: Tool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "no-image")
    }
    
    // set large title to current location
    override func viewWillAppear(_ animated: Bool) {  // appears after viewDidLoad()
        title = selectedTool?.title
        loadToolDetails()
    }
    
    // 👀 READ :: retrieve tool details from realm
    func loadToolDetails() {
        if let thisTool = selectedTool {
            titleLabel.text = thisTool.title
            quantityLabel.text = String(thisTool.quantity)
            expBoolean.isOn = thisTool.expirationBoolean
            descriptionField.text = thisTool.desc
            imageView.image = UIImage(named: thisTool.image)

        }
    }
    

}
