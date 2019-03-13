//
//  HomeVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "categoryCell"

class HomeVC: UICollectionViewController {
    
    let realm = try! Realm()
    
    // pull categories from Realm class
    var allCategories: Results<Category>?
    
    //@IBOutlet var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate table view with all categories
        loadCategories()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // change navigation bar and collection view appearances
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationItem.hidesBackButton = true
        
        //let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
        
    }
    
    // MARK: - ⎡ 📝 COLLECTION VIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // show a single collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // set number of cells in collection equal to number of categories or minimum of 1
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories?.count ?? 1    // if # of categories is nil, return 1
    }
    
    // create a cell from the SwipeCellVC class; if # of cells == 1, show no category text
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        _ = allCategories?[indexPath.row].title ?? "No categories added yet"
        //cell.?.text = allCategories?[indexPath.item].title ?? "No categories added yet"
        
        
        func loadImageFromPath(_ path: NSString) -> UIImage? {
            
            let image = UIImage(contentsOfFile: path as String)
            
            if image == nil {
                return UIImage()
            } else{
                return image
            }
        }
        // add image here later
        cell.displayContent(title: allCategories?[indexPath.row].title ?? "Unnamed category")
        
        return cell
    }
    
    // MARK: - ⎡ ☑️ COLLECTION VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // when a user selects a cell, go to that drawer
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDrawer", sender: self)
    }

    // go to DrawerVC or EditCategoryVC based on user selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDrawer" {
            let destinationVC = segue.destination as! DrawerVC    // go to DrawerVC
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                destinationVC.selectedCategory = allCategories?[indexPath.row]
            }
        } else if segue.identifier == "goToEditCategory" {
            _ = segue.destination as! EditCategoryVC            // go to EditCategoryVC
        }
    }
    
    
//     // the specified item should be selected
//     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//     }
    
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
        collectionView.reloadData()
    }
    
    // 👀 READ :: retrieve categories from realm
    func loadCategories() {
        allCategories = realm.objects(Category.self)
        collectionView.reloadData()
    }
    
    // ❌ DELETE :: user swipes left to reveal the swipe cell and when the delete button is pressed, the realm category is deleted and table view refreshed
    func updateModel(at indexPath: IndexPath) {
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
