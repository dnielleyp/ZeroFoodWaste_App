//
//  ProfileViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 10/5/2023.
//

import UIKit
import Firebase
import CoreData

class ProfileViewController: UIViewController, DatabaseListener {

    var username: String?
    var allDrafts: [ListingDraft] = []
    var currUserID = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userRef = Firestore.firestore().collection("user")
    var listingRef = Firestore.firestore().collection("listings")
    
    var listenerType = ListenerType.listingDraft
    
    weak var databaseController: DatabaseProtocol?
    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?
    
    
    var userListing: [Listing] = []

    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //do nothing !!

    }
    
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft]) {
        allDrafts =  listings
    }
    
    var listingIDList: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            allDrafts = try managedObjectContext!.fetch(ListingDraft.fetchRequest()) as [ListingDraft]
        }
        catch {
            print("ERROR")
        }
        
        getUsername()
        
        databaseController?.addListener(listener: self)
        
//        userListing =

        userRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching user listings \(error!)")
                return
            }
            for document in snapshot.documents {
                if document.documentID == self.currUserID {
                    self.userListing = document.get("listings") as! [Listing]
                    
                    print(self.userListing.count, "ran in here ehehehe")

                }
            }

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        managedObjectContext = appDelegate.persistentContainer?.viewContext
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        
        for draft in allDrafts {
            do {
                managedObjectContext!.delete(draft)
                try managedObjectContext!.save()
            } catch {
                displayMessage(title: "Error", message: "Delete Failed!!!")
            }
            
        }
        Task{
            do {
                try Auth.auth().signOut()
            } catch {
                print("Log Out Error: \(error.localizedDescription)")
            }
        }

        self.performSegue(withIdentifier: "showLoginSegue", sender: self)
    }

    @IBAction func draftsButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "draftsVC") as? DraftsViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func getUsername() {
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "eh", message: "errorooror")
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
                    self.username = document.get("username") as? String
                    self.usernameLabel.text = "@" + self.username!
                }
                
            }
        }
        
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func generateLayout() -> UICollectionViewLayout {
        let imageItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        imageItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let imageGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
        
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: imageGroupSize, subitems: [imageItem])
        let imageSection = NSCollectionLayoutSection(group: imageGroup)
        
        return UICollectionViewCompositionalLayout(section: imageSection)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListing.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userListingCell", for: indexPath) as! ProfileListingCollectionViewCell
        
        return cell
    }


}

class ProfileListingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingNameLabel: UILabel!
    
}
