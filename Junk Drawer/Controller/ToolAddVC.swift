//
//  ToolAddVC.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/26/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import UIKit
import RealmSwift
import Vision
import PMAlertController
import ChameleonFramework

class ToolAddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let realm = try! Realm()
    var allDrawers: Results<Drawer>?
    var allCategories: Results<Category>?
    
    var selectedDrawer: Drawer? {
        didSet {
            print("Adding tool to DRAWER \(String(describing: selectedDrawer?.title))")
        }
    }
    var selectedCategory: Category? {
        didSet {
            print("Adding tool to CATEGORY \(String(describing: selectedCategory?.title))")
        }
    }
    
    let cameraPicker = UIImagePickerController()
    let galleryPicker = UIImagePickerController()
    
    
    // tool property defaults
    var expBoolean = false
    
    // storyboard connections
    @IBOutlet var titleField: UITextField!
    @IBOutlet var quantityField: UITextField!
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var expirationBoolean: UISwitch!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var clearImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.alpha = 0.3
        datePicker.isEnabled = false
        
        imageView.image = UIImage(named: "no-image")
        clearImage.layer.cornerRadius = 10
        
        // image picker requirements
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true
        galleryPicker.delegate = self
        galleryPicker.sourceType = .photoLibrary
        galleryPicker.allowsEditing = false
        
        // change navigation bar appearance
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
        
        
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        func textViewDidBeginEditing(_ textView: UITextView) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height + 250
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - ⎡ 👆 DELEGATE METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    // quantity stepper value changed ∴ update quantity label
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        quantityField.text = Int(sender.value).description
    }
    
    // expiration boolean tapped ∴ update expiration boolean property and enable date picker
    @IBAction func expBooleanTapped(_ sender: UISwitch) {
        if expirationBoolean.isOn {
            expBoolean = true
            datePicker.isEnabled = true
            datePicker.alpha = 1
        } else {
            expBoolean = false
            datePicker.isEnabled = false
            datePicker.alpha = 0.3
        }
    }
    
    // clear image button pressed ∴ reset image view to default
    @IBAction func clearButtonPressed(_ sender: Any) {
        imageView.image = UIImage(named: "no-image")
    }
    
    // save button pressed ∴ add new Tool object and save to Realm
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let currentDrawer = self.selectedDrawer {
            do {
                try self.realm.write {
                    let newTool = Tool()
                    guard let number = Int(quantityField.text!) else {
                        fatalError("Cannot convert quantity field to integer")
                    }
                    newTool.title = self.titleField.text ?? ""
                    newTool.image = String(describing: self.imageView.image)
                    newTool.quantity = number
                    newTool.expirationBoolean = expBoolean
                    newTool.desc = descriptionField.text ?? ""
                    newTool.tint = UIColor.randomFlat().hexValue()
                    currentDrawer.tools.append(newTool)
                }
            } catch {
                print("Error saving new tool under drawer \(error)")
            }
        }
        
//        if let currentCategory = self.selectedCategory {
//            do {
//                try self.realm.write {
//                    let newTool = Tool()
//                    newTool.title = titleField.text ?? ""
//                    //newTool.image = "garage"
//                    //newTool.quantity = 1
//                    //newTool.expirationBoolean = expBoolean
//                    //newTool.desc = descriptionField.text ?? ""
//                    currentCategory.tools.append(newTool)
//                }
//            } catch {
//                print("Error saving new tool under category \(error)")
//            }
//
//        }
        
        // go back to previous view controller
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - ⎡ 📸 IMAGE PICKER METHODS ⎦
    // ———————————————————————————————————————————————————————————————————
    
    @IBAction func cameraIconTapped(_ sender: Any) {
        present(cameraPicker, animated: true, completion: nil)
    }
    
    @IBAction func gallerybuttonTapped(_ sender: Any) {
        present(galleryPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            // convert user picked image to CIImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            // pass into detect method
            detect(image: ciImage)
        }
        
        
    }
    
    func detect(image: CIImage) {
        // load the image recognition model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        // ask model to classify image that is passed into it
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            self.cameraPicker.dismiss(animated: true, completion: nil)
            self.galleryPicker.dismiss(animated: true, completion: nil)
            
            if let firstResult = results.first {
                let uiImage = UIImage.init(ciImage: image)
                let alertVC = PMAlertController(title: "Tool Image", description: "This looks like a \(firstResult.identifier). Would you like to change the title of this tool to \(firstResult.identifier)?", image: uiImage, style: .alert)
                
                alertVC.addAction(PMAlertAction(title: "Yes", style: .default, action: { () in
                    self.titleField.text = firstResult.identifier
                }))
                
                alertVC.addAction(PMAlertAction(title: "No", style: .cancel, action: { () -> Void in
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("There was an error - \(error)")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
