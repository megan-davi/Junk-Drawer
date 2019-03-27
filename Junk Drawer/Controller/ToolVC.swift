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

class ToolVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - ⎡ 🌎 GLOBAL VARIABLES ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // pull categories from Realm class
    let realm = try! Realm()
    var allTools: Results<Tool>?
    
    // collection view cell spacing
    let spacing: CGFloat = 16.0
    
    // storyboard connections
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var toolCollectionView: UICollectionView!
    
    var selectedDrawer: Drawer? {
        didSet{
            loadTools()
        }
    }
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate table view with all categories
        loadTools()
        
        // change navigation bar and collection view appearances
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationItem.hidesBackButton = true
        
        doneButton.isHidden = true
        
        // equally space collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.toolCollectionView?.collectionViewLayout = layout
        
        // if there are no tools in the collection, present an alert
        if allTools?.count == 0 {
            noTools()
        }
        
        title = selectedDrawer?.title
        
    }

    // set large title to current location
    override func viewWillAppear(_ animated: Bool) {  // appears after viewDidLoad()
        title = selectedDrawer?.title
    }
    
    // MARK: - ⎡ 📝 COLLECTION VIEW DATASOURCE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // show a single collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // set number of cells in collection equal to number of tools; if number of tools == nil, set to 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTools?.count ?? 0
    }
    
    // create a cell from the CollectionViewCell class; if # of cells == 1, show no category text
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        
        cell.title.text = allTools?[indexPath.row].title ?? "No tools added yet"
        cell.image.image = UIImage(named: (allTools?[indexPath.row].image) ?? "garage")
        cell.deleteButton.isHidden = true
        cell.backgroundColor = UIColor.cyan
        return cell
        
    }
    
    // show an alert for tools using the PMAlertController pod
    func noTools() {
        let alertVC = PMAlertController(title: "You haven't added any tools yet.", description: "Add tools using the plus sign above or quick add a tool using just a name below. You can long-press the tools screen to edit it later.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            print("Capture action OK")
        }))
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Quick add..."
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - ⎡ ☑️ COLLECTION VIEW DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // user has selected a cell ∴ view tool properties
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    // collection view cells are equally spaced
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 12
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.toolCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    // go to ToolDetailVC or ToolAddVC based on user selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destinationVC = segue.destination as! ToolDetailVC
            if let indexPath = toolCollectionView?.indexPathsForSelectedItems?.first {
                destinationVC.selectedTool = allTools?[indexPath.row]
            }
        } else if segue.identifier == "goToAdd" {
            _ = segue.destination as! ToolAddVC
        }
    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ➕ ADD button pressed ∴ go to ToolAddVC
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToToolAdd", sender: self)
    }
    
    // 👀 READ :: retrieve categories from realm
    func loadTools() {
        allTools = realm.objects(Tool.self)
        toolCollectionView.reloadData()
    }
}

