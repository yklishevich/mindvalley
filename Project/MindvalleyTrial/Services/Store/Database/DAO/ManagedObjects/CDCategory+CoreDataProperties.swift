//
//  CDCategory+CoreDataProperties.swift
//  
//
//  Created by Yauheni Klishevich on 28.06.2020.
//
//

import Foundation
import CoreData


extension CDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var name: String
    @NSManaged public var position: Int32

}
