//
//  HomeVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/5/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift
import PMAlertController
import ChameleonFramework

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UINavigationControllerDelegate {
    
    // MARK: - ⎡ 🌎 GLOBAL VARIABLES ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // pull categories from Realm class and tools for search bar
    let realm = try! Realm()
    var allCategories: Results<Category>?
    var allTools: Results<Tool>?
    
    // collection view cell spacing
    let spacing: CGFloat = 16.0
    
    // storyboard connections
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate table view with all categories
        loadCategories()
        
        // print Realm file location
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // change navigation bar and collection view appearances
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.setHidesBackButton(true, animated: false)
    
        // there are no categories upon start ∴ show an alert
        if allCategories?.count == 0 {
            noCategories()
        }
        
        // collection view spacing
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.categoryCollectionView.collectionViewLayout = layout
    }
    
    // MARK: - ⎡ 📝 COLLECTION VIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // show a single collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // set number of cells in collection equal to number of categories or minimum of 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories?.count ?? 0    // if # of categories is nil, return 0
    }

    // create a cell from the CollectionViewCell class
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        
        cell.title.text = allCategories?[indexPath.row].title
        cell.image.backgroundColor = UIColor(hexString: (allCategories?[indexPath.row].tint))
        
        // cell border
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(hexString: allCategories?[indexPath.row].tint)?.cgColor
        
        return cell
        
    }
    
    // collection view cells are equally spaced
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 20
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.categoryCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    // MARK: - ⎡ 👆 COLLECTION VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user selects a category ∴ segue to that category's associated drawers
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDrawer", sender: self)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    // go to DrawerVC or EditCategoryVC based on user selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDrawer" {
            let destinationVC = segue.destination as! DrawerVC
            if let indexPath = categoryCollectionView?.indexPathsForSelectedItems?.first {
                destinationVC.selectedCategory = allCategories?[indexPath.row]
            }
        } else if segue.identifier == "goToEditCategory" {
            _ = segue.destination as! EditCategoryVC
        } else if segue.identifier == "goToSearch" {
            _ = segue.destination as! SearchVC
        }
    }
    
    // the user has not created any categories ∴ show an alert
    func noCategories() {
        var textField = UITextField()
        let alertVC = PMAlertController(title: "You haven't added any categories yet.", description: "Add categories using the plus sign above or quick add a category using just a name below.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (field) in
            textField = field!
            textField.placeholder = "Quick add..."
        }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            let newCategory = Category()
            newCategory.title = textField.text ?? ""
            newCategory.tint = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }))
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ➕ ADD button pressed ∴ generate an alert and save new category with title to realm
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alertVC = PMAlertController(title: "Add Category", description: "Categories may contain multiple drawers or just tools.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (field) in
            textField = field!
            textField.placeholder = "Category title..."
        }
        
        alertVC.addAction(PMAlertAction(title: "Save", style: .default, action: { () in
            let newCategory = Category()
            newCategory.title = textField.text ?? ""
            newCategory.tint = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }))
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
            try self.realm.write {
                self.realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        categoryCollectionView.reloadData()
    }
    
    

    // 👀 READ :: retrieve categories from realm
    func loadCategories() {
        allCategories = realm.objects(Category.self)
        categoryCollectionView.reloadData()
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


