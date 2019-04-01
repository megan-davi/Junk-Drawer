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
    
    // pull tools from Realm class
    let realm = try! Realm()
    var allTools: Results<Tool>?
    
    // load tools from selected drawer
    var selectedDrawer: Drawer? {
        didSet{
            print("The selected drawer changed from \(oldValue) to \(selectedDrawer?.title)")
            loadTools()
        }
    }
    
    // collection view cell spacing
    let spacing: CGFloat = 10
    
    // storyboard connections
    @IBOutlet var doneButton: UIButton?
    @IBOutlet var toolCollectionView: UICollectionView?
    
    let defaults = UserDefaults.standard
    
    // MARK: - ⎡ 🎂 APP LIFECYCLE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolCollectionView?.reloadData()
        
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
        if allTools?.count == 0 {
            noTools()
        }
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
        return allTools?.count ?? 1
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
        let alertVC = PMAlertController(title: "You haven't added any tools yet.", description: "Add tools using the plus sign above or quick add a tool using just a name below.", image: UIImage(named: ""), style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Quick add..."
        }
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            print("Capture action OK")
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // collection view cells are equally spaced
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 10
        
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToDetail" {
//            let destinationVC = segue.destination as! ToolDetailVC
//            if let indexPath = toolCollectionView?.indexPathsForSelectedItems?.first {
//                destinationVC.selectedTool = allTools?[indexPath.row]
//            }
//        } else if segue.identifier == "goToAdd" {
//            _ = segue.destination as! ToolAddVC
//        }
//    }
    
    // MARK: - ⎡ ⭐️ CRUD OPERATIONS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // ➕ ADD button pressed ∴ go to ToolAddVC
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToToolAdd", sender: self)
    }
    
    // 👀 READ :: retrieve tools from realm
    func loadTools() {
        // allTools = selectedDrawer?.tools.sorted(byKeyPath: "title", ascending: false)
        allTools = selectedDrawer?.tools.sorted(byKeyPath: "title", ascending: false)
        toolCollectionView?.reloadData()
    }
}

