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
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userRef = Firestore.firestore().collection("user")
    var listenerType = ListenerType.listingDraft
    
    weak var databaseController: DatabaseProtocol?
    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?

    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //nothing
    }
    
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft]) {
        allDrafts =  listings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        getUsername()
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
        Task{
            do {
                try Auth.auth().signOut()
            } catch {
                print("Log Out Error: \(error.localizedDescription)")
            }

            self.performSegue(withIdentifier: "showLoginSegue", sender: self)
        
        }
        for draft in allDrafts {
            managedObjectContext!.delete(draft)
        }

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
