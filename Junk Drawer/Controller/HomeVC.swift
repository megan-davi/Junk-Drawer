//
//  HomeVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class HomeVC: SwipeCellVC {
    
    let realm = try! Realm()
    
    var allCategories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // set navbar title to white
        navigationController?.navigationItem.hidesBackButton = true
        
    }
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of categories or minimum of 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories?.count ?? 1    // if # of categories is nil, return 1
    }
    
    // create a cell from the SwipeCellVC class; if # of cells == 1, show no category text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = allCategories?[indexPath.row].title ?? "No categories added yet"
        
        return cell
    }
    
    // MARK: - ⎡ ☑️ TABLEVIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when a user selects a row, go to that drawer
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDrawer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // add an if statment for multiple VCs
        let destinationVC = segue.destination as! DrawerVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = allCategories?[indexPath.row]
            // go create selected category in drawerVC
        }
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ⭐️ CREATE :: generate alert with a text field, save category to realm, and refresh table view
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.title = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    // 👀 READ :: retrieve categories from realm
    func loadCategories() {
        allCategories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // ❌ DELETE :: user swipes left to reveal the swipe cell and when the delete button is pressed, the realm category is deleted and table view refreshed
    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: indexPath)  // include this code if you want to code that is in the overridden class to run as well
        
        if let categoryForDeletion = self.allCategories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }

}
