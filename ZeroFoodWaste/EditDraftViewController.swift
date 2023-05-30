//
//  EditDraftViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 11/5/2023.
//

import UIKit
import CoreData
import FirebaseFirestore

class EditDraftViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var databaseController: DatabaseProtocol?
    
    var listing: ListingDraft?
    var dietPrefList:[String]?
    var allergens: [String]?
    var category: Category?
    
    @IBOutlet weak var listingName: UITextField!
    @IBOutlet weak var listingDesc: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var draftImage: UIImageView!
    
    
    @IBOutlet weak var gfSquare: UIButton!
    @IBOutlet weak var vgSquare: UIButton!
    @IBOutlet weak var vegeSquare: UIButton!
    @IBOutlet weak var halalSquare: UIButton!
    
    
    @IBOutlet weak var peanutSquare: UIButton!
    @IBOutlet weak var soySquare: UIButton!
    @IBOutlet weak var treeNutSquare: UIButton!
    @IBOutlet weak var wheatSquare: UIButton!
    @IBOutlet weak var eggSquare: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        let tempCategory = Int(listing!.category)

        self.listingName.text = listing?.name
        self.listingDesc.text = listing?.desc
        self.locationField.text = listing?.location
        self.category = Category(rawValue: Int(listing!.category))
        self.categorySegmentControl.selectedSegmentIndex = tempCategory

        self.dietPrefList = listing?.dietPref ?? ["","","",""]
        self.allergens = listing?.allergens ?? ["","","","",""]
        checkList_init()
        print("ALLERGENS", allergens)


        guard let filename = listing?.photo else {return}
        //filename is the path of the photo
        self.draftImage.image = loadImage(filename: filename ) //hmm


    }
    
    var isGF = false
    var isVegan = false
    var isVege = false
    var isHalal = false
    
    func checkList_init(){
        //checking dietPrefList
        if dietPrefList![0] == "Gluten Free" {
            print(dietPrefList!, "GF")
            gfSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isGF = true
        }
        if dietPrefList![1] == "Halal" {
            halalSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isHalal = true
        }
        if dietPrefList![2] == "Vegan" {
            print(dietPrefList!)
            vgSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVegan = true
        }
        if dietPrefList![3] == "Vegetarian" {
            vegeSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVege = true
        }
        
        //checking allergens list
        if dietPrefList![0] == "Egg" {
            print(dietPrefList!, "GF")
            eggSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isEgg = true
        }
        if allergens![1] == "Peanut" {
            peanutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isPeanut = true
        }
        if allergens![2] == "Soy" {
            soySquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isSoy = true
        }
        if allergens?[3] == "Treenut" {
            treeNutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isTreenut = true
        }
        if allergens![4] == "Wheat" {
            wheatSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isWheat = true
        }
        
    }
    
    @IBAction func gfButton(_ sender: Any) {
        //if gluten free is checked then:
        if isGF {
            dietPrefList![0] = ""
            gfSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isGF = false
        } else {
            dietPrefList![0] = "Gluten Free"
            gfSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isGF = true
        }
    }
    
    @IBAction func veganButton(_ sender: Any) {
        if isVegan {
            dietPrefList![2] = ""
            vgSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isVegan = false
        } else {
            dietPrefList![2] = "Vegan"
            vgSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVegan = true
        }
    }
    
    @IBAction func vegeButton(_ sender: Any) {
        
        if isVege {
            dietPrefList![3] = ""
            vegeSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isVege = false
        } else {
            dietPrefList![3] = "Vegetarian"
            vegeSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isVege = true
        }
    }
    
    @IBAction func halalButton(_ sender: Any) {
        if isHalal {
            dietPrefList![1] = ""
            halalSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isHalal = false
        } else {
            dietPrefList![1] = "Halal"
            halalSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isHalal = true
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Update Draft
    @IBAction func updateDraft(_ sender: Any) {
        var category32 = Int32(categorySegmentControl.selectedSegmentIndex)
        
        guard let lname = listingName.text else {return}
        guard let ldesc = listingDesc.text else {return}
        guard let llocation = locationField.text else {return}
//        guard let limage = draftImage.image else {return}
        
        listing?.name = lname
        listing?.desc = ldesc
        listing?.location = llocation
        listing?.category = category32
        listing?.dietPref = dietPrefList!
        listing?.allergens = allergens!
        
        navigationController?.popViewController(animated: true)
   
    }
    
    var isPeanut = false
    var isSoy = false
    var isTreenut = false
    var isWheat = false
    var isEgg = false
    
    @IBAction func peanutButton(_ sender: Any) {
            if isPeanut{
                self.allergens![1] = ""
                peanutSquare.setImage(UIImage(systemName: "square"), for: .normal)
                isPeanut = false
            } else {
                allergens![1] = "Peanut"
                peanutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                isPeanut = true
            }
    }
    
    @IBAction func soyButton(_ sender: Any) {
        if isSoy{
            self.allergens![2] = ""
            soySquare.setImage(UIImage(systemName: "square"), for: .normal)
            isSoy = false
        } else {
            allergens![2] = "Soy"
            soySquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isSoy = true
        }
    }
    
    @IBAction func treenutButton(_ sender: Any) {
        if isTreenut{
            self.allergens![3] = ""
            treeNutSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isTreenut = false
        } else {
            allergens![3] = "Treenut"
            treeNutSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isTreenut = true
        }
    }
    
    @IBAction func wheatButton(_ sender: Any) {
        if isWheat{
            self.allergens![4] = ""
            wheatSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isWheat = false
        } else {
            allergens![4] = "Wheat"
            wheatSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isWheat = true
        }
    }
    
    @IBAction func eggButton(_ sender: Any) {
        if isEgg {
            self.allergens![0] = ""
            eggSquare.setImage(UIImage(systemName: "square"), for: .normal)
            isEgg = false
        } else {
            allergens![0] = "Egg"
            eggSquare.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isEgg = true
        }

    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: "Select Option", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {action in
            controller.sourceType = .camera
            
            self.present(controller, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            action in controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in
            controller.sourceType = .savedPhotosAlbum
            
            self.present(controller, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { actionSheet.addAction(cameraAction)}
            		
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func checkImage() -> Bool{
        guard let image = draftImage.image else {
            return false
        }
        return true
    }
    
    // MARK: Posting listing :)
    @IBAction func createListingButton(_ sender: Any) {
        
        var imageExists = checkImage()
        var filename: String?
        
        
        guard let name = listingName.text else {return}
        guard let desc = listingDesc.text else {return}
        guard let location = locationField.text else {return}
        guard let image = draftImage.image else {return}
        
        if name.isEmpty || desc.isEmpty || location.isEmpty {
            displayMessage(title: "Cannot create listing", message: "Please ensure all fields are filled in")
        }
        
        if imageExists {

            let image = draftImage.image  //cannot be nil since we already checked
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
        
        databaseController?.addListing(name: name, description: desc, location: location, category: category, dietPref: dietPrefList!, allergens: allergens!, image: filename)
        
        navigationController?.popViewController(animated: true)
        
        
    }
    

}

extension EditDraftViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            draftImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadImage(filename: String)-> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        let image = UIImage(contentsOfFile: imageURL.path)
        
        //it gets the correct filename and returns the correct image
        return image

    }
}

