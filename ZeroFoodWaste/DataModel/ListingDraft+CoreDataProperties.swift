//
//  ListingDraft+CoreDataProperties.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 9/5/2023.
//
//

import Foundation
import CoreData


extension ListingDraft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListingDraft> {
        return NSFetchRequest<ListingDraft>(entityName: "ListingDraft")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var location: String?
    @NSManaged public var category: Int32
    @NSManaged public var dietPref: [String]?
    @NSManaged public var allergens: [String]?
    @NSManaged public var photo: String?
    @NSManaged public var draft: Bool

}

extension ListingDraft : Identifiable {
}

enum category: Int32 {
    case produce = 0
    case dairy = 1
    case protein = 2
    case grains = 3
    case others = 4
}
