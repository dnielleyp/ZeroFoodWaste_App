//
//  SetupProfilePicViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 11/5/2023.
//

import UIKit

class SetupProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    var managedObjectContext: NSManagedObjectContext?
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profilePictureImage.backgroundColor = UIColor(red: 255, green: 247, blue: 235, alpha: 0)
        profilePictureImage.image = UIImage(systemName: "person.circle")
    }
    
    @IBAction func finishSetupButton(_ sender: Any) {
        //if it's successfully added into the firestore then we will performsegue("setup
        guard let image = profilePictureImage.image else {
            displayMessage(title: "ERROr", message: "Cannot save until an image has been selected")
            return
        }
        
        //get a unique id for this picture slayyyy
        let uuid = UUID().uuidString
        let filename = "\(uuid).jpg"
        
        print("\(filename)")
        
        //else displayMsg and not allow segue
        self.performSegue(withIdentifier: "showHomeSegue", sender: self)
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
    
    
    
    // MARK: UIImagePicker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage  {
            profilePictureImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
