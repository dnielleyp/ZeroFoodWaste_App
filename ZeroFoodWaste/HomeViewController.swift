//
//  HomeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 3/5/2023.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController, DatabaseListener {
    
//    var snapshotListener: ListenerRegistration?
    
    var listenerType = ListenerType.listing
    weak var databaseController: DatabaseProtocol?
    
    
    //reference to the user collection to get user's name
    var userRef = Firestore.firestore().collection("user")
    var user: FirebaseAuth.User?
    
    var listingRef = Firestore.firestore().collection("listings")
    var storageReference = Storage.storage()
    
    var allListing: [Listing] = []
    var name: String?
    
//    var imagePaths = [String]()
//    var imageList = [UIImage]()
    
    
    @IBOutlet weak var listingCollectionView: UICollectionView!
    
    let CELL_LISTING = "listingCell"

    var currentSender: Sender?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //only need firebase hehehe
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        listingCollectionView.backgroundColor = .systemBackground
        listingCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readUserInfo()
        
        databaseController?.addListener(listener: self)
        print("RUNNING HERE")
        
        listingCollectionView.reloadSections([0])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            databaseController?.removeListener(listener: self)
//        if let snapshotListener = snapshotListener {
//            snapshotListener.remove()
//        }
    }
    
    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        allListing = listings

    }
    
    func readUserInfo(){
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "Error", message: "User Info can't be read")
            return
        }
        
        userRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            for document in snapshot.documents {
                let documentID = document.documentID
                if documentID == userID {
                    self.name = document.get("name") as? String
                    self.nameLabel.text = self.name
                }
                
            }
        }
    }
    

    
    @IBAction func notificationButton(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "notificationsVC") as? NotificationViewController {
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    var index: Int?
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowListingSegue" {
            let destination = segue.destination as! ListingViewController

            destination.listing = allListing[index!]
        }
    }
    


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //function to load listing image
    func loadImage(filename: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
        
    }
    
    //listing collection view here! :D
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allListing.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_LISTING, for: indexPath) as! ListingCollectionViewCell
        
        cell.backgroundColor = .secondarySystemFill
        
        let listing = allListing[indexPath.row]
        
        var filename = listing.image!
        
        let imageRef = storageReference.reference().child("\(listing.id)/\(filename)")
        
        let paths = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        let downloadTask = imageRef.write(toFile: fileURL)

        downloadTask.observe( .success) { snapshot in
            let image = self.loadImage(filename: filename)
            cell.imageView.image = image

        }

        downloadTask.observe(.failure) { snapshot in
            print("\(String(describing: snapshot.error))")
        }


        
        
        
        


        cell.imageView.image = loadImage(filename: listing.image!)
        cell.listingNameLabel.text = listing.name
        
        
    
        
        return cell
        
    }
    
//    func saveImageData(filename: String){
//        let paths = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        let fileURL = documentsDirectory.appendingPathComponent(filename)
//
//        do {
//            try image
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        self.performSegue(withIdentifier: "ShowListingSegue", sender: self)
        
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let imageItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        imageItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let imageGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
        
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: imageGroupSize, subitems: [imageItem])
        let imageSection = NSCollectionLayoutSection(group: imageGroup)
        
        return UICollectionViewCompositionalLayout(section: imageSection)
    }
    
    
    
}

class ListingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var listingNameLabel: UILabel!
    
}
