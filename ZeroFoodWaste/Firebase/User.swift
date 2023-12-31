//
//  User.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class User: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var listings: [Listing] = []
    var likes: [Listing] = []
    var pfp: String?
    var username: String?
    var email: String?
}
