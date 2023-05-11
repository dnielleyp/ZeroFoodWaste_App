//
//  ProfileViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 10/5/2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, DatabaseListener {

    
    var allDrafts: [ListingDraft] = []
    
    var listenerType = ListenerType.listingDraft
    weak var databaseController: DatabaseProtocol?
    
    
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft]) {
        allDrafts =  listings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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
            databaseController?.deleteListingDraft(listing: draft)
        }
        
        
    }

    @IBAction func draftsButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "draftsVC") as? DraftsViewController {
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
