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
    var authController: Auth
    var database: Firestore
    var listingRef: CollectionReference?
    var userRef: CollectionReference?
    var currentUser: User
    
    var currentUserAuth: FirebaseAuth.User?
    
    override init(){
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        listingList = [Listing]()
        currentUser = User()

        currentUserAuth = authController.currentUser
        print(currentUserAuth, "CURRENT USER AUTHHHH")
                
        super.init()

        self.setupListingListener()
        
    }
    
    func addListener(listener: DatabaseListener){
        listeners.addDelegate(listener)
        
        if listener.listenerType == .listing || listener.listenerType == .all {
            listener.onListingChange(change: .update, listings: listingList)
        }
        
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, userLikes: currentUser.likes, userListing: currentUser.listings )
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
    
    func addUser(name: String?, username: String?, email: String?, pfp: String?) -> User {
        let user = User()
        user.name = name
        user.username = username
        user.email = email
        user.pfp = pfp
        
        
        let userID = Auth.auth().currentUser?.uid 
        user.id = userID
        
        
        let userRef = userRef?.document(user.id!).setData(["name": name!, "username": username!, "email": email!, "pfp": pfp!])
        
        return user
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
    
    //addlistingtolikes we skip for now...
    func addListingToLikes(listing: Listing, user: User) -> Bool {
        guard let listingID = listing.id, let userID = user.id else {return false}
        
        //no duplicates
        if user.likes.contains(listing){return false}
                               
        if let likedListingRef = listingRef?.document(listingID) {
            userRef?.document(userID).updateData(["likes": FieldValue.arrayUnion([likedListingRef])])
        }
        return true
    }
    
    
    //removelistingfromlikes we skip for now...
    func removeListingFromLikes(listing: Listing, user: User) {
        if user.likes.contains(listing), let userID = user.id, let listingID = listing.id {
            if let removedLikedRef = listingRef?.document(listingID) {
                userRef?.document(userID).updateData(["likes": FieldValue.arrayRemove([removedLikedRef])])
            }
        }
        
    }
    
    func addListingToUser(listing: Listing, user: User) -> Bool {
        guard let listingID = listing.id, let userID = user.id else {return false}
        
        if let newListingRef = listingRef?.document(listingID) {
            userRef?.document(userID).updateData(["listings": FieldValue.arrayUnion([newListingRef])])
        }
        return true
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
            if self.userRef == nil {
                self.setupUserListener(user: self.currentUser)
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
        //match with email bc firebase will only allow 1 account per email
        userRef?.whereField("username", isEqualTo: self.currentUserAuth?.displayName).addSnapshotListener{
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, let userSnapshot = querySnapshot.documents.first else {
                print("error fetching user")
                return
            }

            self.parseUserSnapshot(snapshot: userSnapshot)
        }
    }
    
    func parseUserSnapshot (snapshot: QueryDocumentSnapshot) {

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
                listener.onUserChange (change: .update, userLikes: currentUser.likes, userListing: currentUser.listings )
            }
        }
    }

}
