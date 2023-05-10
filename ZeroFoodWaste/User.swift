//
//  User.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
//import FirebaseFirestoreSwift

class User: NSObject{
//    @DocumentID var username: String?
    var name: String?
    var listings: [Listing] = []
    var likes: [Listing] = []
    var pfp: String?
    var drafts: [Listing] = []
    var username: String?
}
