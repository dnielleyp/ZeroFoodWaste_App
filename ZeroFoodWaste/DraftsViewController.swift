//
//  DraftsViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 11/5/2023.
//

import UIKit
import CoreData

class DraftsViewController: UIViewController, DatabaseListener, UITableViewDelegate, UITableViewDataSource {
    
    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //nothing
    }
    
    var allDrafts: [ListingDraft] = []
    var listenerType = ListenerType.listingDraft
    weak var databaseController: DatabaseProtocol?
    
    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?
    
    var index: Int?
    
    
    @IBOutlet weak var draftTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        databaseController?.addListener(listener: self)
        
        do {
            allDrafts = try managedObjectContext!.fetch(ListingDraft.fetchRequest()) as [ListingDraft]
            print("ALLLLLLL DRAAAAAAAAAAAFTSSSSSSSSSSSS", allDrafts.count)
        }
        
        catch {
            print("FAIL FAIL WOWO")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer?.viewContext
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        databaseController?.removeListener(listener: self)
    }
    
    // MARK: Listener method for draftListings
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft]) {
        allDrafts = listings
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: TableView func
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                
                let listing = allDrafts[indexPath.row]
                
                managedObjectContext!.delete(listing)
                
                self.allDrafts.remove(at: indexPath.row)
                self.draftTableView.deleteRows(at: [indexPath], with: .fade)
                self.draftTableView.reloadSections([0], with: .automatic)
            }, completion: nil)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftCell", for: indexPath)
        let listing = allDrafts[indexPath.row]
        cell.textLabel?.text = listing.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "EditDraftSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "EditDraftSegue" {
            let destination = segue.destination as! EditDraftViewController
            
            destination.listing = allDrafts[index!]
        }
        
        
    }
    
}
