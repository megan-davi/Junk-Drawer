//
//  SwipeCellVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import SwipeCellKit

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
    
    // ✏️ EDIT :: user swipes left to reveal the swipe cell and when the edit button is pressed, user is sent to EditCategoryVC
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            //self.updateModel(at: indexPath)
            self.performSegue(withIdentifier: "goToEditCategory", sender: self)
        }
        
        // customize appearance
        editAction.image = UIImage(named: "pencil")
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

