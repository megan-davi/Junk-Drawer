//
//  DrawerVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class DrawerVC: SwipeCellVC {
    
    var allDrawers: Results<Drawer>?
    let realm = try! Realm()
    
    
    var selectedCategory: Category? {
        didSet{
            loadDrawers()
        }
    }
    
    let defaults = UserDefaults.standard
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when app starts, load any local storage data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        // reveal realm file location
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
     // set large title to current location
    override func viewWillAppear(_ animated: Bool) {  // appears after viewDidLoad()
        title = selectedCategory?.title
    }
    
    // runs when app is dismissed
    override func viewWillDisappear(_ animated: Bool) {
    }
    // MARK: - ⎡ 🗺 NAV BAR SETUP METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
//    func updateNavBar(withHexCode colorHexCode: String) {
//        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
//        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
//        navBar.barTintColor = navBarColor                                 // background color
//        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)  // navigation buttons color
//        searchBar.barTintColor = navBarColor                               // search bar color
//        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
//    }
    
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of items OR 1 if number of items is 0
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDrawers?.count ?? 1
    }
    
    // set row equal to item title property and add a checkmark if done property = true, else say there are no items added
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let drawer = allDrawers?[indexPath.row] {
            cell.textLabel?.text = drawer.title
            
//            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {  // gradient cells
//                cell.backgroundColor = color
//                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
//            }
            
        } else {
            cell.textLabel?.text = "No Drawers Added"
        }
        
        return cell
    }
    
    // MARK: - ⎡ 👆 TABLE VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user selects a row ∴ they see the associated tool's detail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTool", sender: self)
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ⭐️ CREATE :: show alert for user to enter new item, then save this item to realm in the current category and refresh table view
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Drawer", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Drawer", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newDrawer = Drawer()
                        newDrawer.title = textField.text!
                    currentCategory.drawers.append(newDrawer)
                    }
                } catch {
                    print("Error saving new drawers \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // 👀 READ :: retrieve drawers from realm
    func loadDrawers() {
        allDrawers = selectedCategory?.drawers.sorted(byKeyPath: "title", ascending: false)
        tableView.reloadData()
    }
}
    
//    override func updateModel(at indexPath: IndexPath) {
//        if let drawer = allDrawers?[indexPath.row] {
//            do {
//                try realm.write {
//                    realm.delete(drawer)
//                }
//            } catch {
//                print("Error deleting drawer: \(error)")
//            }
//        }
//    }


//extension DrawerVC: UISearchBarDelegate {
//    // MARK: - ⎡ 🔍 SEARCH BAR METHODS ⎦
//    // ———————————————————————————————————————————————————————————————————
//    
//    // when the search button is pressed, look for all of the data entries where the search bar text matches the data
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        allDrawers = allDrawers?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)    // search is case and diacritic insensitive
//        tableView.reloadData()
//    }
//    
//    // when the search bar text is cleared, return to original list, dismiss keyboard, and deselect search bar
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadDrawers()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
