//
//  DrawerVC.swift
//  
//
//  Created by Megan Brown on 3/10/19.
//

import UIKit
import RealmSwift

class DrawerVC: UITableViewController {
    
    let defaults = UserDefaults.standard
    var drawers: Results<Drawer>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadDrawers()
        }
    }
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when app starts, load any local storage data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))  // reveal realm file location
    }
    
    // appears after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.title
    }
    
    // runs when app is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    // MARK: - ⎡ 🗺 NAV BAR SETUP METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
    
    }
    
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of items OR 1 if number of items is 0
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawers?.count ?? 1
    }
    
    // set row equal to item title property and add a checkmark if done property = true, else say there are no items added
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let drawer = drawers?[indexPath.row] {
            cell.textLabel?.text = drawer.title
        } else {
            cell.textLabel?.text = "No Drawers Added"
        }
        
        return cell
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ⭐️ CREATE :: show alert for user to enter new drawer, then save this drawer to realm in the current category and refresh table view
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey drawer", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add drawer", style: .default) { (action) in
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
            alertTextField.placeholder = "Create new drawer"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // 👀 READ :: retrieve drawers from realm
    func loadDrawers() {
        drawers = selectedCategory?.drawers.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let drawer = drawers?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(drawer)
                }
            } catch {
                print("Error deleting drawer: \(error)")
            }
        }
    }
    
    // ☑️ UPDATE :: when a user clicks a row, save updated "done" property to realm and refresh table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let drawer = drawers?[indexPath.row] {
            do {
                try realm.write {
                    // realm.delete(drawer)
                    drawer.done = !drawer.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)    // allows gray to fade away
    }
}

extension DrawerVC: UISearchBarDelegate {
    // MARK: - ⎡ 🔍 SEARCH BAR METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when the search button is pressed, look for all of the data entries where the search bar text matches the data
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        drawers = drawers?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)    // search is case and diacritic insensitive
        tableView.reloadData()
    }
    
    // when the search bar text is cleared, return to original list, dismiss keyboard, and deselect search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDrawers()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
