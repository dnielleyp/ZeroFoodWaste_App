//
//  CoreDataController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 9/5/2023.
//

import UIKit
import CoreData
import Foundation

class CoreDataController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    override init() {
        
        persistentContainer = NSPersistentContainer(name: "ZFW-DataModel")
        persistentContainer.loadPersistentStores() {(description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        
        super.init()
    }
    
    func cleanup() {
        if self.persistentContainer.viewContext.hasChanges {
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error \(error)")
            }
        }
    }
    
    
    ///this is the DRAFT listng. only the draft will be added into core data :D
    func addListingDraft(draft: Bool, name: String?, description: String?, location: String?, category: Int32?) -> ListingDraft {
        
        let listing = NSEntityDescription.insertNewObject(forEntityName: "ListingDraft", into: persistentContainer.viewContext) as! ListingDraft
    
        listing.draft = draft
        listing.name = name
        listing.desc = description
        listing.location = location
        listing.category = category!
//        listing.dietPref = dietPref
//        listing.allergens = allergens
//        listing.photo = photo
        
        return listing
    }
    
    func deleteListingDraft(listing: ListingDraft) {
        persistentContainer.viewContext.delete(listing)
    }
    
    func fetchAllListings() -> [ListingDraft] {
        var drafts = [ListingDraft]()
        
        let request: NSFetchRequest<ListingDraft> = ListingDraft.fetchRequest()
        
        do {
            try drafts = persistentContainer.viewContext.fetch(request)
        } catch{
            print("Fetch Request failed with error: \(error)")
        }
        
        return drafts
        
    }
    
    func addListener (listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .listingDraft || listener.listenerType == .all {
            listener.onListingDraftChange(change: .update, listings: fetchAllListings())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    
    
    
}
