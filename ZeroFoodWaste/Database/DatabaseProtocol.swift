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
//    case listing
//    case users
    case listingDraft
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onListingDraftChange(change: DatabaseChange, listings: [ListingDraft])
//    func onLikesChange(change: DatabaseChange, likes:[Listing])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    //into core data only if the listing is a draft
    func addListingDraft(draft: Bool, name: String?, description: String?, location: String?, category: Int32?, image: String?) -> ListingDraft
    
    func deleteListingDraft (listing: ListingDraft)
}
