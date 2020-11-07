//
//  CDNewEpisode+CoreDataProperties.swift
//  
//
//  Created by Yauheni Klishevich on 27.06.2020.
//
//

import Foundation
import CoreData


extension CDNewEpisode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNewEpisode> {
        return NSFetchRequest<CDNewEpisode>(entityName: "CDNewEpisode")
    }

    @NSManaged public var coverAssetUrl: String
    @NSManaged public var position: Int32
    @NSManaged public var title: String
    @NSManaged public var type: String
    @NSManaged public var channelTitle: String

}
