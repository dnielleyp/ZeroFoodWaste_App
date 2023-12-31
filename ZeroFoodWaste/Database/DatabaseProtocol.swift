//
//  DatabaseProtocol.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 28/4/2023.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case listing
    case listingDraft
    case user
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
//    func onLikesChange(change: DatabaseChange, likes:[Listing])
    func onUserChange(change: DatabaseChange, userLikes: [Listing], userListing: [Listing])
    func onListingChange(change: DatabaseChange, listings: [Listing])
}

protocol DatabaseProtocol: AnyObject {
    
    var currentUser: User {get}
    
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

//    for published listings :>
    func addListing (name: String?, description: String?, location: String?, category: Category?, dietPref: [String?], allergens: [String?], image: String?, owner: String?, ownerID: String?) -> Listing?
    func deleteListing(listing: Listing)
    
    func addUser (name: String?, username: String?, email: String?, pfp: String?) -> User
    func addListingToLikes (listing: Listing, user: User) -> Bool
    func removeListingFromLikes (listing: Listing, user: User)
    
    func addListingToUser (listing: Listing, user: User) -> Bool
}



