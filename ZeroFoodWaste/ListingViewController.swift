//
//  ListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 2/6/2023.
//

import UIKit
import Firebase

class ListingViewController: UIViewController, DatabaseListener {
    
    
    func onUserChange(change: DatabaseChange, userLikes: [Listing], userListing: [Listing]) {
        //nothing
    }
    
    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //nothing
    }
    
    
    
    var listing: Listing?
    
    var userRef = Firestore.firestore().collection("user")
    var listingRef = Firestore.firestore().collection("listings")
    
    var currentUser = Auth.auth().currentUser!.uid
    
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.user
    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descField: UILabel!
    
    @IBOutlet weak var categoryLabel: UIButton!
    @IBOutlet weak var dietPrefLabel: UILabel!
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

        
    let catArray = ["Produce", "Dairy", "Protein", "Grain", "Others"]
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
 
        listingImage.image = loadImage(filename: (listing?.image)!)
        nameLabel.text = listing?.name
    
        descField.text = listing?.desc

        var category = catArray[(listing?.category)!]
        categoryLabel.setTitle((category), for: .normal)
        
        switch category {
        case "Produce":
            categoryLabel.tintColor = UIColor(red: 137/255, green: 180/255, blue: 136/255, alpha: 1.0)
        case "Protein":
            categoryLabel.tintColor = UIColor(red: 219/255, green: 143/255, blue: 181/255, alpha: 1.0)
        case "Dairy":
            categoryLabel.tintColor = UIColor(red: 247/255, green: 225/255, blue: 111/255, alpha: 1.0)
        case "Grains":
            categoryLabel.tintColor = UIColor(red: 145/255, green: 129/255, blue: 106/255, alpha: 1.0)
        default:
            categoryLabel.tintColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1.0)
        }
        locationLabel.text = listing?.location
        ownerLabel.setTitle(listing?.owner, for: .normal)
        

        var allerg = listing?.allergens ?? ["","","","",""]
        if allerg == ["","","","",""] {
            let allerge = allerg.compactMap {$0}.joined(separator: ", ")
            
            allergensLabel.text = allerge
        }
        else {
            allergensLabel.text = ""
        }
    }

    
    //adding the userID into the likes array of the listing
    @IBAction func addLikes(_ sender: Any) {
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20)
        
        var liked = databaseController?.addListingToLikes(listing: self.listing!, user: databaseController!.currentUser)
        
        //user already liked it and they pressed it so they unlike it
        if liked == false {
            self.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: buttonConfig), for: .normal)
            
            databaseController?.removeListingFromLikes(listing: self.listing!, user: databaseController!.currentUser)
        }
        
        else {
            self.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: buttonConfig), for: .normal)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadImage(filename: String) -> UIImage? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        
        let image = UIImage(contentsOfFile: imageURL.path)
        
        return image
        
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

//extension ListingViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        descFieldHeight.constant = descField.contentSize.height
//    }
//}
