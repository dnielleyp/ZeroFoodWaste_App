//
//  FirebaseController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 25/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol {

    var listeners = MulticastDelegate<DatabaseListener>()
    var listingList: [Listing]
//    var userList: [User]
    
    var authController: Auth
    var database: Firestore
    var listingRef: CollectionReference?
    var userRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        listingList = [Listing]()
//        userList = [User]()
        currentUser = authController.currentUser
        
        super.init()
        
        self.setupListingListener()
        
    }
    
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == .listing || listener.listenerType == .all {
            listener.onListingChange(change: .update, listings: listingList)
        }

    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    
    func addListing(name: String?, description: String?, location: String?, category: Category?, dietPref: [String?], allergens: [String?], image: String?, owner: String?, ownerID: String?) -> Listing? {

        let listing = Listing()
        listing.name = name
        listing.desc = description
        listing.location = location
        listing.category = category?.rawValue
        listing.dietPref = dietPref
        listing.allergens = allergens
        listing.image = image
        listing.owner = owner
        listing.ownerID = ownerID
        listing.likes = []
        
        //try adding to firestore
        do {
            if let listingRef = try listingRef?.addDocument(from: listing) {
                listing.id = listingRef.documentID
            }
        } catch  {
            print("Failed to add listing ")
        }
        return listing
    }
    
    func deleteListing(listing: Listing) {
        if let listingID = listing.id {
            listingRef?.document(listingID).delete()
        }
    }
    
    func cleanup(){}
    
    
    // MARK: - Firebase Controller Specific Methods
    
    func getListingByID(_ id: String) -> Listing? {
        for listing in listingList {
            if listing.id == id {
                return listing
            }
        }
        return nil
    }
    

    func setupListingListener(){
        listingRef = database.collection("listings")
        listingRef?.addSnapshotListener(){
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseListingSnapshot(snapshot: querySnapshot)
            if self.listingRef == nil {
                self.setupListingListener()
            }
        }
    }
    
    func parseListingSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach{ (change) in

            //decode the document's data as a listing object
            var listing: Listing
            
            do {
                listing = try change.document.data(as: Listing.self)
            } catch {
                fatalError("Unable to decode listing: \(error.localizedDescription)")
            }

            if change.type == .added {
                listingList.insert(listing, at: Int(change.newIndex))
            }
            
            else if change.type == .modified {
                listingList.remove(at: Int(change.oldIndex))
                listingList.insert(listing, at: Int(change.newIndex))
            }
            else if change.type == .removed {
                listingList.remove(at: Int(change.oldIndex))
            }

            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.listing || listener.listenerType == ListenerType.all {
                    listener.onListingChange(change: .update, listings: listingList)
                }
            }


        }
    }
    
    func setupUserListener(user: User) {
        userRef = database.collection("user")
        userRef?.whereField("username", isEqualTo: user.id).addSnapshotListener{
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, let userSnapshot = querySnapshot.documents.first else {
                print("error fetching user")
                return
            }
            
            self.parseUserSnapshot(snapshot: userSnapshot)
        }
    }
    
    func parseUserSnapshot (snapshot: QuerySnapshot) {
        
        currentUser = User()
        currentUser.name = snapshot.data()["name"] as? String
        currentUser.username = snapshot.data()["username"] as? String
        currentUser.email = snapshot.data()["email"] as? String
        currentUser.pfp = snapshot.data()["pfp"] as? String
        currentUser.id = snapshot.documentID
        
        if let listingReferencees = snapshot.data()["likes"] as? [DocumentReference] {
            for reference in listingReferencees {
                if let list = getListingByID(reference.documentID) {
                    currentUser.likes.append(list)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                listener.onLikesChange (change: .update, userLikes: currentUser.likes )
            }
        }
    }
    
}
