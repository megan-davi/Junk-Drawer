//
//  SearchVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 4/27/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // pull tools from Realm class
    let realm = try! Realm()
    var allTools: Results<Tool>?
    
    @IBOutlet var searchTableView: UITableView!
    var filteredTools: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTools()
        
        // setup the search controller
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search by tool or tag..."
        navigationItem.titleView = searchBar
        
        searchTableView.dataSource = self
        searchBar.delegate = self

    }
    
    // MARK: - ⎡ 📝 TABLEVIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // set number of rows in table equal to number of items OR 1 if number of items is 0 or nil (in order to show "no items added" message)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTools?.count ?? 0
    }
    
    // show tools in a table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        // find tool location
        let toolLocation = allTools![indexPath.row].self.parentCategory.first!.title
        let drawerLocation = allTools![indexPath.row].parentCategory.self.first._rlmInferWrappedType().parentCategory.first!.title
        
        // show cell image, title, and location
        cell.imageView?.image = UIImage(named: "no-image")
        cell.textLabel?.text = allTools?[indexPath.row].title
        cell.detailTextLabel?.text =
        "Located in \(String(describing: drawerLocation)) in \(String(describing: toolLocation))"
        
        return cell
    }
    
    // retrieve tools from realm
    func loadTools() {
        allTools = realm.objects(Tool.self)
        searchTableView.reloadData()
    }
    
    // MARK: - ⎡ 👆 TABLE VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user selects a tool ∴ segue to that tool's associated detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    // direct user to ToolDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destinationVC = segue.destination as! ToolDetailVC
            if let indexPath = searchTableView.indexPathForSelectedRow {
                destinationVC.selectedTool = allTools?[indexPath.row]
            }
        }
    }
    
    // MARK: - ⎡ 🔍 SEARCH BAR METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when the search button is pressed, look for all of the data entries where the search bar text matches the data
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        allTools = allTools?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)    // search is case and diacritic insensitive
        searchTableView.reloadData()
    }
    
    // when the search bar text is cleared, return to original list, dismiss keyboard, and deselect search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTools()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
