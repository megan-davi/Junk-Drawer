//
//  SwipeCellVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import SwipeCellKit
import PMAlertController

class SwipeCellVC: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self // necessary for SwipeCellKit
        return cell
    }
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ✏️ EDIT :: user swipes right and presses the pencil icon ∴ an alert to edit the drawer's title appears and updates in realm
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            //self.updateModel(at: indexPath)
            let alertVC = PMAlertController(title: "Edit Drawer Title", description: "Enter a new name for this drawer.", image: UIImage(named: ""), style: .alert)
            var newTitle = ""
            
            alertVC.addTextField { (textField) in
                textField?.placeholder = "Drawer title..."
                newTitle = textField!.text ?? ""
            }
            
            alertVC.addAction(PMAlertAction(title: "Save", style: .default, action: { () in
                // UPDATE REALM CODE HERE
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
        // customize appearance
        editAction.image = UIImage(named: "whitepencil")
        editAction.backgroundColor = UIColor(named: "customBlue")
        editAction.textColor = UIColor(named: "customBlack")
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // update data model
        // nothing happens! This is overriden by the subclass's updateModel function
    }
}

