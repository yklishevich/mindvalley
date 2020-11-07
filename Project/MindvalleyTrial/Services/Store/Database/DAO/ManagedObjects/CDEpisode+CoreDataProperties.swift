//
//  CDEpisode+CoreDataProperties.swift
//  
//
//  Created by Yauheni Klishevich on 27.06.2020.
//
//

import Foundation
import CoreData


extension CDEpisode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEpisode> {
        return NSFetchRequest<CDEpisode>(entityName: "CDEpisode")
    }

    @NSManaged public var coverAssetUrl: String
    @NSManaged public var title: String
    @NSManaged public var type: String
    @NSManaged public var positionInChannel: Int32
    @NSManaged public var channel: CDChannel

}
