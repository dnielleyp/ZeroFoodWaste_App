//
//  CreateListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

import UIKit
import CoreData
import FirebaseFirestore

class CreateListingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var databaseController: DatabaseProtocol?
    
    var draft = false
    var category: Category?
    var saveDraft = false
    var dietPref: [String] = ["","","",""]
    var allergens: [String] = ["","","","",""]

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var gfSquare: UIButton!
    @IBOutlet weak var vgSquare: UIButton!
    @IBOutlet weak var vegeSquare: UIButton!
    @IBOutlet weak var halalSquare: UIButton!
    
    
    
    @IBOutlet weak var peanutSquare: UIButton!
    @IBOutlet weak var soySquare: UIButton!
    @IBOutlet weak var treeNutSquare: UIButton!
    @IBOutlet weak var wheatSquare: UIButton!
    @IBOutlet weak var eggSquare: UIButton!
    
    //for core data
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //hide the tab bar hehe
        self.tabBarController?.tabBar.isHidden = true
        
        //get databaseController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        managedObjectContext = appDelegate.persistentContainer?.viewContext
        
    }

    @IBAction func closeButton(_ sender: Any) { navigationController?.popViewController(animated: true) }

    
//    checkmark.square
    
    var isGF = false
    var isVegan = false
    var isVege = false
    var isHalal = false
    
    @IBAction func gfButton(_ sender: Any) {
        //if gluten free is checked then:
        if isGF {
            self.dietPref[0] = ""
            gfSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isGF = false
        } else {
            dietPref[0] = "Gluten Free"
            gfSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isGF = true
        }
        
        print("DIETPREFFFF", dietPref)
    }
    
    @IBAction func veganButton(_ sender: Any) {
        if isVegan {
            self.dietPref[2] = ""
            vgSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isVegan = false
        } else {
            dietPref[2] = "Vegan"
            vgSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVegan = true
        }
        
        print("DIETPREFFFF", dietPref)
    }
    
    @IBAction func vegeButton(_ sender: Any) {
        
        if isVege {
            self.dietPref[3] = ""
            vegeSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isVege = false
        } else {
            dietPref[3] = "Vegetarian"
            vegeSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVege = true
        }
        
        print("DIETPREFFFF", dietPref)
    }
    
    @IBAction func halalButton(_ sender: Any) {
        if isHalal {
            self.dietPref[1] = ""
            halalSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isHalal = false
        } else {
            dietPref[1] = "Halal"
            halalSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isHalal = true
        }
    }
    
    var isPeanut = false
    var isSoy = false
    var isTreenut = false
    var isWheat = false
    var isEgg = false
    
    @IBAction func peanutButton(_ sender: Any) {
            if isPeanut{
                self.allergens[1] = ""
                peanutSquare.setImage(UIImage(systemName: "square"), for: .normal)
                isPeanut = false
            } else {
                allergens[1] = "Peanut"
                peanutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                isPeanut = true
            }
    }
    
    @IBAction func soyButton(_ sender: Any) {
        if isSoy{
            self.allergens[2] = ""
            soySquare.setImage(UIImage(systemName: "square"), for: .normal)
            isSoy = false
        } else {
            allergens[2] = "Soy"
            soySquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isSoy = true
        }
    }
    
    @IBAction func treenutButton(_ sender: Any) {
        if isTreenut{
            self.allergens[3] = ""
            treeNutSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isTreenut = false
        } else {
            allergens[3] = "Treenut"
            treeNutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isTreenut = true
        }
    }
    
    @IBAction func wheatButton(_ sender: Any) {
        if isWheat{
            self.allergens[4] = ""
            wheatSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isWheat = false
        } else {
            allergens[4] = "Wheat"
            wheatSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isWheat = true
        }
    }
    
    @IBAction func eggButton(_ sender: Any) {
        if isEgg {
            self.allergens[0] = ""
            eggSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isEgg = false
        } else {
            allergens[0] = "Egg"
            eggSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isEgg = true
        }

    }
    
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
        var category = categorySegmentedControl.titleForSegment(at: Int(category32))
        
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
            
            do {
                let draftEntity = NSEntityDescription.insertNewObject(forEntityName: "ListingDraft", into: managedObjectContext!) as! ListingDraft
                
                draftEntity.draft = true
                draftEntity.name = name
                draftEntity.desc = desc
                draftEntity.location = location
                draftEntity.category = category32
                draftEntity.photo = filename
                draftEntity.allergens = allergens
                draftEntity.dietPref = dietPref
                
                try managedObjectContext?.save()
                navigationController?.popViewController(animated: true)
            }
            
            catch {
                displayMessage(title: "Error", message: "\(error)")
            }
        }
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
        var filename: String?


        //check if all fields are there yk
        guard let name = nameField.text else {return}
        guard let desc = descField.text else {return}
        guard let location = locationField.text else {return}
        category = Category(rawValue: Int(categorySegmentedControl.selectedSegmentIndex))

        guard let image = listingImage.image else {return}

        if name.isEmpty || desc.isEmpty || location.isEmpty {
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
        
        databaseController!.addListing(name: name, description: desc, location: location, category: category!, dietPref: dietPref, allergens: allergens, image: filename!)
        
        print("BUTTON PRESSED")
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension CreateListingViewController {
    
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


