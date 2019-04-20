//
//  DrawerVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/12/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift
import PMAlertController
import ChameleonFramework

class DrawerVC: SwipeCellVC, UIImagePickerControllerDelegate {
    
    // MARK: - ⎡ 🌎 GLOBAL VARIABLES ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // pull categories from Realm class
    let realm = try! Realm()
    var allDrawers: Results<Drawer>?
    
    // selected category changes ∴ load its drawers
    var selectedCategory: Category? {
        didSet {
            print("The selected category changed from \(oldValue) to \(selectedCategory?.title)")
            loadDrawers()
        }
    }
    
    // storyboard connection
    @IBOutlet var drawerTableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when app starts, load any local storage data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        print("Number of rows is \(allDrawers?.count)")
        // there are no drawers upon start ∴ show an alert

    }
    
     // set large title to current location
    override func viewWillAppear(_ animated: Bool) {  // appears after viewDidLoad()
        title = selectedCategory?.title
        
        guard let colorHex = selectedCategory?.tint else {fatalError()}
        updateNavBar(withHexCode: colorHex)
        
        if allDrawers?.count == 0 {
            noDrawers()
        }
    }
    
    // runs when app is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0) {
            navigationController?.navigationBar.barTintColor = UIColor(named: "customBlack")
        }
    }
    
    // MARK: - ⎡ 🗺 NAV BAR SETUP METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor                                 // background color
    }
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of items OR 1 if number of items is 0 or nil (in order to show "no items added" message)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDrawers?.count ?? 0
    }
    
    // set row equal to item title property and add a checkmark if done property = true, else say there are no items added
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let drawer = allDrawers?[indexPath.row] {
            cell.textLabel?.text = drawer.title
        }
        
        return cell
    }
    
    // MARK: - ⎡ 👆 TABLE VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user selects a drawer ∴ segue to that drawer's associated tools
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)  // allows gray to fade away
        print("goToTool segue")
        performSegue(withIdentifier: "goToTool", sender: self)
    }
    
    // go to ToolVC or camera?? based on user selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue from drawerVC ran")
        if segue.identifier == "goToTool" {
            let destinationVC = segue.destination as! ToolVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedDrawer = allDrawers?[indexPath.row]
                print("Selected drawer set to index path")
            }
        } else if segue.identifier == "goToEditCategory" {
            _ = segue.destination as! EditCategoryVC
        }
    }
    
    // there are no drawers in the selected category ∴ show an alert
    func noDrawers() {
        var textField = UITextField()
        let alertVC = PMAlertController(title: "You haven't added any drawers yet.", description: "Add drawers using the plus sign above or quick add a drawer using just a name below.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (field) in
            textField = field!
            textField.placeholder = "Quick add..."
        }
        
        alertVC.addAction(PMAlertAction(title: "Save Drawer", style: .default, action: { () in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newDrawer = Drawer()
                        newDrawer.title = textField.text ?? ""
                        currentCategory.drawers.append(newDrawer)
                        self.drawerTableView.reloadData()
                    }
                } catch {
                    print("Error saving new drawer \(error)")
                }
            }
        }))
        
        alertVC.addAction(PMAlertAction(title: "No Thanks", style: .cancel, action: { () -> Void in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }

    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ⭐️ CREATE :: show alert for user to enter new item, then save this item to realm in the current category and refresh table view
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alertVC = PMAlertController(title: "Add Drawer", description: "Create a new drawer.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (field) in
            textField = field!
            textField.placeholder = "Drawer title..."
        }
        
        alertVC.addAction(PMAlertAction(title: "Save", style: .default, action: { () in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newDrawer = Drawer()
                        newDrawer.title = textField.text ?? ""
                        currentCategory.drawers.append(newDrawer)
                        self.drawerTableView.reloadData()
                    }
                } catch {
                    print("Error saving new drawer \(error)")
                }
            }
        }))
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func save(drawer: Drawer) {
        do {
            try realm.write {
                realm.add(drawer)
            }
        } catch {
            print("Error saving drawer \(error)")
        }
        drawerTableView.reloadData()
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
