//
//  DraftsViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 11/5/2023.
//

import UIKit

class DraftsViewController: UIViewController, DatabaseListener, UITableViewDelegate, UITableViewDataSource {
    
    var allDrafts: [ListingDraft] = []
    var listenerType = ListenerType.listingDraft
    weak var databaseController: DatabaseProtocol?
    
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
    
// MARK: Listener method for draftListings
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft]) {
        allDrafts = listings
        print("ALLDRAFTS",allDrafts)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        print("ehrehrehjkhejfaHERJAHDFHFUEUFAH")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let listing = allDrafts[indexPath.row]
                databaseController?.deleteListingDraft(listing: listing)
            }
        }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //get the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allDrafts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftCell", for: indexPath)
        let listing = allDrafts[indexPath.row]
        cell.textLabel?.text = listing.name
        
        return cell
    }
}

