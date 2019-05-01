//
//  ToolVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/26/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift
import PMAlertController

class ToolVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate {
    
    // MARK: - ⎡ 🌎 GLOBAL VARIABLES ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // pull tools from Realm class
    let realm = try! Realm()
    var allTools: Results<Tool>?
    var allDrawers: Results<Drawer>?
    var allCategories: Results<Category>?
    
    // load tools from selected drawer
    var selectedDrawer: Drawer? {
        didSet {
            print("Tools loaded from DRAWER \(String(describing: selectedDrawer?.title))")
            loadTools()
        }
    }
    
    // load tools from selected category
    var selectedCategory: Category? {
        didSet {
            print("Tools loaded from CATEGORY \(String(describing: selectedCategory?.title))")
            loadTools()
        }
    }
    
    // collection view cell spacing
    let spacing: CGFloat = 1
    
    // storyboard connections
    @IBOutlet var doneButton: UIButton?
    @IBOutlet var toolCollectionView: UICollectionView!
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolCollectionView.reloadData()
        
        // change navigation bar and collection view appearances
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationItem.hidesBackButton = true
        
        doneButton?.isHidden = true
        
        // equally space collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.toolCollectionView?.collectionViewLayout = layout
        
        // there are no tools upon start ∴ show an alert
        if toolCollectionView?.numberOfItems(inSection: 0) == 0 {
            noTools()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedDrawer?.title
        
    }
    
    // MARK: - ⎡ 📝 COLLECTION VIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // show a single collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // set number of cells in collection equal to number of tools or 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTools?.count ?? 0
    }
    
    // create a cell from the CollectionViewCell class
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        
        cell.title.text = allTools?[indexPath.row].title ?? ""
        cell.image.image = UIImage(named: (allTools?[indexPath.row].image ?? "garage") )
        cell.deleteButton.isHidden = true
        cell.backgroundColor = UIColor.cyan
        
        return cell
    }
    
    // there are no tools in the selected drawer ∴ show an alert
    func noTools() {
        var textField = UITextField()
        let alertVC = PMAlertController(title: "You haven't added any tools yet.", description: "Add a tool using the plus sign above or quick add a tool using just a name below.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (field) in
            textField = field!
            textField.placeholder = "Quick add..."
        }
        
        alertVC.addAction(PMAlertAction(title: "Save Tool", style: .default, action: { () in
            
            // parent is of type category ∴ add tool to current category
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTool = Tool()
                        newTool.title = textField.text ?? ""
                        currentCategory.tools.append(newTool)
                        self.realm.add(newTool)
                    }
                } catch {
                    print("Error saving new tool \(error)")
                }
            }
            
            // parent is of type drawer ∴ add tool to current drawer
            if let currentDrawer = self.selectedDrawer {
                do {
                    try self.realm.write {
                        let newTool = Tool()
                        newTool.title = textField.text ?? ""
                        currentDrawer.tools.append(newTool)
                        self.realm.add(newTool)
                    }
                } catch {
                    print("Error saving new tool \(error)")
                }
            }
            
            self.loadTools()
            
        }))
        
        alertVC.addAction(PMAlertAction(title: "No Thanks", style: .cancel, action: { () -> Void in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // collection view cells are equally spaced
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 1
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.toolCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    // MARK: - ⎡ 👆 COLLECTION VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user has selected a cell ∴ view tool properties
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    // go to ToolDetailVC or ToolAddVC based on user selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destinationVC = segue.destination as! ToolDetailVC
            if let indexPath = toolCollectionView?.indexPathsForSelectedItems?.first {
                destinationVC.selectedTool = allTools?[indexPath.row]
            }
        } else if segue.identifier == "goToAdd" {
            let destinationVC = segue.destination as! ToolAddVC
            if let indexPath = toolCollectionView?.indexPathsForSelectedItems?.first {
                destinationVC.selectedDrawer = allDrawers?[indexPath.row]
                destinationVC.selectedCategory = allCategories?[indexPath.row]
            }
        }
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ➕ ADD button pressed ∴ go to ToolAddVC
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToToolAdd", sender: self)
    }
    
    // 👀 READ :: retrieve tools from realm
    func loadTools() {
        // load tools from drawer or category based on drawer boolean
        if let currentCategory = selectedCategory {
            if currentCategory.drawerBoolean == true {
                allTools = selectedDrawer?.tools.sorted(byKeyPath: "title", ascending: false)
            } else {
                allTools = selectedCategory?.tools.sorted(byKeyPath: "title", ascending: false)
            }
        } else {
            allTools = selectedDrawer?.tools.sorted(byKeyPath: "title", ascending: false)
        }
        
        toolCollectionView?.reloadData()
    }
}

