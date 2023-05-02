//
//  Listing.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
//import FirebaseFirestoreSwift

class Listing: NSObject{
    
//    @DocumentID var id: String?
    var name: String?
    var owner: User?
    var draft: Bool?
    var likes: [User] = []
    var desc: String?
    var category: Category?

    
}

enum CodingKeys: String, CodingKey {
    case id
    case name
    case owner
    case likes
    case desc = "description"
    case location
    case category
    case dietPref
    case allergens
    case photos
}

enum Category: String {
    case vegetable = "Vegetables"
    case fruit = "Fruits"
    case dairy = "Dairy"
    case protein = "Protein"
    case grain = "Grains"
    case other = "Others"
}
