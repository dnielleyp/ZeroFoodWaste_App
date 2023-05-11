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
//    var managedObjectContext: NSManagedObjectContext?
    
    var draft = false
    var category: Int?
    var saveDraft = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
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
    }

    @IBAction func closeButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }

    
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
        saveDraft = true
        //check that at least name field is filled :D
        guard let name = nameField.text else {return}
        guard let desc = descField.text else {return}
        guard let location = locationField.text else {return}
        category = categorySegmentedControl.selectedSegmentIndex
        guard let image = listingImage.image else {
            return
        }
        
        var category32 = Int32(category!)
        
        let uuid = UUID().uuidString
        let filename = "\(uuid).jpg"


        guard let data = image.jpegData(compressionQuality: 0.8) else {
            displayMessage(title: "Error", message: "Image data could not be compressed")
            return
        }

        
        
        //get app's document directory to save the image file
        let pathsList = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = pathsList[0]
        let imageFile = documentDirectory.appendingPathComponent(filename)

        if name.isEmpty {
            displayMessage(title: "Can't Save Draft", message: "Please input a name for your listing")
            return
        }

        else {
            databaseController?.addListingDraft(draft: true, name: name, description: desc, location: location, category: category32, image: filename)
        }

        //then leaves create listing view
        navigationController?.popViewController(animated: true)


    }
    
    
    
    
// MARK: Creating a listing that will be posted
    
    @IBAction func createListing(_ sender: Any) {
        //check if all fields are there yk
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


