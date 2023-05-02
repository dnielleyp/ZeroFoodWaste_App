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
    case users
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onListingChange(change: DatabaseChange, listings: [Listing])
    func onLikesChange(change: DatabaseChange, likes:[Listing])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addListing(draft: Bool, owner: User, likes: [Listing], name: String, description: String, category: String) -> Listing
}
