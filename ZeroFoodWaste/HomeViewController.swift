//
//  HomeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 3/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    
    //reference to the user collection
    //get user's name :D
    
    var userRef = Firestore.firestore().collection("user")
    
    var user: FirebaseAuth.User?
    var listingArray: [Listing]?
    var name: String?
    
    var firebaseController: FirebaseController?
    
    let CELL_LISTING = "listingCell"
    var imageList = [UIImage]()
    var imagePathList = [String]()
    
    //definitely have a user otherwise they cannot access the home page :D
//    var userID = Auth.auth().currentUser?.uid
    
    var currentSender: Sender?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //only need firebase hehehe
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        firebaseController = appDelegate?.firebaseController
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
                    self.name = document.get("name") as? String
                    self.nameLabel.text = self.name
                }
                
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        readUserInfo()

    }
    
    
    @IBAction func notificationButton(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "notificationsVC") as? NotificationViewController {
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: true, completion: nil)
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

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    //listing collection view here! :D
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//}
