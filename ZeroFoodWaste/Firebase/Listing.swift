//
//  Listing.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

//why got error what is your pROBELLENKFJHIDHAI
class Listing: NSObject, Codable {
    
    @DocumentID var id: String?
    var name: String?
    var owner: User?
    var likes: [User] = []
    var desc: String?
    var location: String?
    var category: Int?
    var image: String?
    var dietPref: [String?] = []
    var allergens: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case likes
        case desc = "description"
        case location
        case category
        case image = "photos"
        case dietPref
        case allergens
    }
    
}


extension Listing {
    var listingcategory: Category {
        get {
            return Category(rawValue: self.category!)!
        }
        set {
            self.category = newValue.rawValue
        }
    }
}

//enum CodingKeys: String, CodingKey {
//    case id
//    case name
//    case owner
//    case likes
//    case desc = "description"
//    case location
//    case category
//    case image = "photos"
//    case dietPref
//    case allergens
//}

enum Category: Int {
    case produce = 0
    case dairy = 1
    case protein = 2
    case grains = 3
    case others = 4
}
