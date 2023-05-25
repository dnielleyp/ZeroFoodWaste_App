//
//  CreateListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

import UIKit
import CoreData

class CreateListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    weak var databaseController: DatabaseProtocol?
    weak var firebaseController: DatabaseProtocol?
    
    var draft = false
    var category: Category?
    var saveDraft = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var listingImage: UIImageView!
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dietPrefCheckList: UITableView!
    
    let dietPrefList = ["Gluten Free", "Vegan", "Vegetarian", "Halal"]
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //hide the tab bar hehe
        self.tabBarController?.tabBar.isHidden = true
        
        //get databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        firebaseController = appDelegate?.firebaseController
    }

    @IBAction func closeButton(_ sender: Any) { navigationController?.popViewController(animated: true) }

    
//    checkmark.square
    
    
    @IBAction func selectPhotoButton(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: "Select Option:", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            controller.sourceType = .camera
            
            self.present(controller, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            action in controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in controller.sourceType = .savedPhotosAlbum
            
            self.present(controller, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { actionSheet.addAction(cameraAction)
        }
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
// MARK: - saving as draft
    
    @IBAction func saveAsDraft(_ sender: Any) {
        
        var haveImage = true
        var filename: String?

        saveDraft = true
        //check that at least name field is filled :D
        guard let name = nameField.text else {return}
        guard let desc = descField.text else {return}
        guard let location = locationField.text else {return}
        var category32 = Int32(categorySegmentedControl.selectedSegmentIndex)
        
        var imageExists = checkImage()

        //check if image exists
        if imageExists {
            
            let image = listingImage.image  //cannot be nil since we already checked
            let uuid = UUID().uuidString
            filename = "\(uuid).jpg"
            
            
            guard let data = image!.jpegData(compressionQuality: 0.8) else {
                //            displayMessage(title: "Error", message: "Image data could not be compressed")
                return
            }
            
            //get app's document directory to save the image file
            let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = pathsList[0]
            let imageFile = documentDirectory.appendingPathComponent(filename!)
            
        }
        
        //call separate function
        
        if name.isEmpty {
            displayMessage(title: "Can't Save Draft", message: "Please input a name for your listing")
            return
        }

        else {
            databaseController?.addListingDraft(draft: true, name: name, description: desc, location: location, category: category32, image: filename)
        }

        navigationController?.popViewController(animated: true)

    }
    
    
    
    func checkImage() -> Bool{
        guard let image = listingImage.image else {
            return false
        }
        return true
    }
    
    
// MARK: Creating a listing that will be posted
    //this one is added to firebase :)
    @IBAction func createListing(_ sender: Any) {
        var imageExists = checkImage()
        var haveImage = true
        var filename: String?
        
        
        //check if all fields are there yk
        guard let name = nameField.text else {return}
        guard let desc = descField.text else {return}
        guard let location = locationField.text else {return}
        category = Category(rawValue: Int(categorySegmentedControl.selectedSegmentIndex))
        
        guard let image = listingImage.image else {return}
        
        if !name.isEmpty && !desc.isEmpty && !location.isEmpty {
            displayMessage(title: "Cannot create listing", message: "Please ensure all fields are filled in")
        }
        
        if imageExists {
            
            let image = listingImage.image  //cannot be nil since we already checked
            let uuid = UUID().uuidString
            filename = "\(uuid).jpg"
            
            
            guard let data = image!.jpegData(compressionQuality: 0.8) else {
                return
            }
            
            //get app's document directory to save the image file
            let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = pathsList[0]
            let imageFile = documentDirectory.appendingPathComponent(filename!)
            
        } else {
            displayMessage(title: "Cannot Create Listing", message: "Please include an image")
        }
        
        firebaseController?.addListing(name: name, description: desc, location: location, category: category!, image: filename!)
        
    }
}

extension CreateListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //f5 categories
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath)
        cell.textLabel?.text = dietPrefList[indexPath.row]
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            listingImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


