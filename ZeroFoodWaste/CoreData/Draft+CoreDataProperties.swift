//
//  Draft+CoreDataProperties.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 28/4/2023.
//
//

import Foundation
import CoreData


extension Draft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Draft> {
        return NSFetchRequest<Draft>(entityName: "Draft")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var draft: Bool
    @NSManaged public var category: Int32

}

extension Draft : Identifiable {

}
