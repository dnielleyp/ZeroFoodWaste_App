//
//  ListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 2/6/2023.
//

import UIKit
import Firebase

class ListingViewController: UIViewController {
    
    var listing: Listing?
    
    var userRef = Firestore.firestore().collection("user")
    var listingRef = Firestore.firestore().collection("listings")
    
    var currentUser = Auth.auth().currentUser!.uid

    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descField: UILabel!
    
    @IBOutlet weak var categoryLabel: UIButton!
    @IBOutlet weak var dietPrefLabel: UILabel!
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
//    @IBOutlet weak var descFieldHeight: NSLayoutConstraint!
    
    
    let catArray = ["Produce", "Dairy", "Protein", "Grain", "Others"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        listingImage.image = loadImage(filename: (listing?.image)!)
        nameLabel.text = listing?.name
    
        descField.text = listing?.desc
        
        var likes = listing!.likes!.count ?? 0
        
        self.likeButton.setTitle("\(likes) ", for: .normal)
        
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
        
        setLikesButton()
        
    }
    
    func setLikesButton() {
        let listingID = (listing?.id)!
        let userID = currentUser
        
        self.listingRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(String(describing:error))")
                return
            }
            
            for doc in snapshot.documents {
                if doc.documentID == listingID {
                    var currListingLikes = doc.get("likes") as? Array<String> ?? []
                    
                    
                    if currListingLikes.contains(userID) {
                        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
  
                    }
                    else {
                        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                    
                    self.likeButton.setTitle(String(currListingLikes.count), for: .normal)
                    self.likeButton.configuration?.buttonSize = .medium
                }
            }
        }
    }
    
    //adding the userID into the likes array of the listing
    @IBAction func addLikes(_ sender: Any) {
        
        print("button pressed slayyyyy")
        
        //get the listingid
        let listingID: String = (listing?.id!)!
        
        //get the userid
        let userID = listing!.ownerID
        
        print("listing owner", listing!.ownerID)

        self.userRef.getDocuments { [self](snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(String(describing: error))")
                return
            }
            for doc in snapshot.documents {
                if doc.documentID == userID {
                    var currUserLikesList = doc.get("likes") as? Array<DocumentReference> ?? []

                    let ref = self.listingRef.document("\(listingID)")
                    
                    //check if user has liked this before
                    if let index = currUserLikesList.firstIndex(of: ref) {
                        currUserLikesList.remove(at: index)
                    }
                    else {
                        currUserLikesList.append(ref)
                    }
                    
                    
                    self.userRef.document(currentUser).updateData(["likes":currUserLikesList])
//
                }
            }
        }
        
        self.listingRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(String(describing:error))")
                return
            }
            
            for doc in snapshot.documents {
                if doc.documentID == listingID {
                    var currListingLikes = doc.get("likes") as? Array<String> ?? []
                    
                    let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20)

                    if let index = currListingLikes.firstIndex(of: self.currentUser) {
                        currListingLikes.remove(at: index)
                        
                        
                        self.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: buttonConfig), for: .normal)
                        
                        
                    }
                    else {
                        
                        currListingLikes.append(self.currentUser)
                        
                        self.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: buttonConfig), for: .normal)
                    }
                    
                    self.listingRef.document(listingID).updateData(["likes": currListingLikes])
                    self.likeButton.setTitle(String(currListingLikes.count), for: .normal)
                    self.likeButton.configuration?.buttonSize = .medium
                }
            }
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
