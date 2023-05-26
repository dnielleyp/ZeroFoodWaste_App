//
//  CoreDataController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 9/5/2023.
//

import UIKit
import CoreData
import Foundation

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    func addListing(name: String?, description: String?, location: String?, category: Category?, image: String?) -> Listing? {
        //nothing ?
        
        //bro idk sia
        return nil
    }
    
    func deleteListing(listing: Listing){
        //nothing ?? whehfaiha
    }
    

    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var allDraftsFetchedResultsController: NSFetchedResultsController<ListingDraft>?
    
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
    func addListingDraft(draft: Bool, name: String?, description: String?, location: String?, category: Int32, image: String?)-> ListingDraft? {
        
        let listing = NSEntityDescription.insertNewObject(forEntityName: "ListingDraft", into: persistentContainer.viewContext) as! ListingDraft
    
        listing.draft = draft
        listing.name = name
        listing.desc = description
        listing.location = location
        listing.category = category
//        listing.dietPref = dietPref
//        listing.allergens = allergens
        listing.photo = image
        
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
        
//                if allDraftsFetchedResultsController == nil {
//                    let request: NSFetchRequest<ListingDraft> = ListingDraft.fetchRequest()
//                    let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//                    request.sortDescriptors = [nameSortDescriptor]
//
//
//                    // Initialise Fetched Results Controller
//                    allDraftsFetchedResultsController = NSFetchedResultsController<ListingDraft>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//                    // Set this class to be the results delegate
//                    allDraftsFetchedResultsController?.delegate = self
//
//                    do {
//                        try allDraftsFetchedResultsController?.performFetch()
//                    } catch {
//                        print("Fetch Request Failed: \(error)")
//                    }
//                }
//
//                if let drafts = allDraftsFetchedResultsController?.fetchedObjects {
//                    return drafts
//                }
//
//                return [ListingDraft]()
//
//
//
//            }
        
        
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
