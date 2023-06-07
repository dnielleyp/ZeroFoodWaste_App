//
//  HomeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 3/5/2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class HomeViewController: UIViewController, DatabaseListener, UITabBarControllerDelegate {
    
//    var snapshotListener: ListenerRegistration?
    
    var userRef = Firestore.firestore().collection("user")
    var listingRef = Firestore.firestore().collection("listings")
    
    var listenerType = ListenerType.listing
    weak var databaseController: DatabaseProtocol?
    
    
    //reference to the user collection to get user's name
    var user: FirebaseAuth.User?
    
    var storageReference = Storage.storage()
    
    var allListing: [Listing] = []
    var name: String?
    
    var imagePathList = [String]()
    var imageList = [UIImage]()
    
    
    @IBOutlet weak var listingCollectionView: UICollectionView!

    let CELL_LISTING = "listingCell"

    
    
    
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
        
//        self.tabBarController?.delegate = self
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            databaseController?.removeListener(listener: self)

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
        
        imagePathList.append(filename)
        
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
        
        //uuid of the image
        var imageName = listing.image!
        
        //get jpg file
        let filename = "\(imageName).jpg"
        
        cell.listingNameLabel.text = "woi"
        
        
        //image is not yet loaded?
        if !self.imagePathList.contains(filename) {

            //MARK: you want to load this image
            if let image = self.loadImage(filename: imageName) {
                
                self.imageList.append(image)
                self.imagePathList.append(imageName)
                
                cell.imageView.image = image
                
                self.listingCollectionView.reloadSections([0])
                
            }
            
            //we need to download from storage if the image not loaded
            else {
                
                let paths = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let fileURL = documentsDirectory.appendingPathComponent(imageName)

                let imageRef = storageReference.reference().child("\(listing.id)/\(imageName)")

                let downloadTask = imageRef.write(toFile: fileURL)

                downloadTask.observe( .success) { snapshot in
                    let image = self.loadImage(filename: imageName)!
                    self.imageList.append(image)
                    self.imagePathList.append(imageName)
                    
                    
                    cell.imageView.image = image

                    self.listingCollectionView.reloadSections([0])
                }

                downloadTask.observe(.failure) { snapshot in
                    print("\(String(describing: snapshot.error))")
                }
            }
        }

        cell.listingNameLabel.text = listing.name

        return cell
        
    }
    
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
