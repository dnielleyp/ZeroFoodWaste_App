//
//  HomeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 3/5/2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //reference to the user collection
    //get user's name :D
    
    var userRef = Firestore.firestore().collection("user")
    
    var user: FirebaseAuth.User?
    var listingArray: [Listing]?
    var name: String?
    
    //definitely have a user otherwise they cannot access the home page :D
//    var userID = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func readUserInfo(){
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
                    self.name = document.get("name") as! String
                    self.nameLabel.text = self.name
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readUserInfo()
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

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
