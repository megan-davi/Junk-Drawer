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
    
    // ❌ DELETE :: user swipes left to reveal the swipe cell and when the delete button is pressed, the realm category is deleted and table view refreshed
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("Delete Cell")
            self.updateModel(at: indexPath)
        }
        
        // customize appearance
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // update data model
        // nothing happens! This is overriden by the subclass's updateModel function
    }
}

