//
//  CDSeriesItem+CoreDataProperties.swift
//  
//
//  Created by Yauheni Klishevich on 27.06.2020.
//
//

import Foundation
import CoreData


extension CDSeriesItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSeriesItem> {
        return NSFetchRequest<CDSeriesItem>(entityName: "CDSeriesItem")
    }

    @NSManaged public var title: String
    @NSManaged public var coverAssetUrl: String
    @NSManaged public var channel: CDChannel
    @NSManaged public var positionInChannel: Int32

}
