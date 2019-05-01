//
//  SearchVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 4/27/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class SearchVC: UITableViewController {
    
    // pull tools from Realm class
    let realm = try! Realm()
    var allTools: Results<Tool>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of items OR 1 if number of items is 0 or nil (in order to show "no items added" message)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTools?.count ?? 0
    }
    
    // set row equal to item title property and add a checkmark if done property = true, else say there are no items added
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel!.text = allTools?[indexPath.row].title
        //cell.detailTextLabel!.text = candy.category
        return cell
    }
    
    // MARK: - ⎡ 👆 TABLE VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user selects a drawer ∴ segue to that drawer's associated tools
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTool", sender: self)
    }
    
    // go to ToolVC or EditCategoryVC based on user selection
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToTool" {
//            let destinationVC = segue.destination as! ToolVC
//            if let indexPath = tableView.indexPathForSelectedRow {
//                destinationVC.selectedDrawer = allDrawers?[indexPath.row]
//                destinationVC.selectedCategory = allCategories?[indexPath.row]
//            }
//        } else if segue.identifier == "goToEditCategory" {
//            _ = segue.destination as! EditCategoryVC
//        }
//    }
    
    


}
