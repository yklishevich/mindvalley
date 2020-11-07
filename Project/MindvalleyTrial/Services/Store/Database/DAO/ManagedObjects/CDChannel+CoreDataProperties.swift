//
//  CDChannel+CoreDataProperties.swift
//  
//
//  Created by Yauheni Klishevich on 27.06.2020.
//
//

import Foundation
import CoreData


extension CDChannel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDChannel> {
        return NSFetchRequest<CDChannel>(entityName: "CDChannel")
    }

    @NSManaged public var title: String
    @NSManaged public var position: Int32
    @NSManaged public var coverAssetUrl: String
    @NSManaged public var iconAssetThumbnailURL: String?
    @NSManaged public var mediaCount: Int32
    @NSManaged public var series: Set<CDSeriesItem>
    @NSManaged public var episodes: Set<CDEpisode>

}

// MARK: Generated accessors for series
extension CDChannel {

    @objc(addSeriesObject:)
    @NSManaged public func addToSeries(_ value: CDSeriesItem)
    
    @objc(removeSeriesObject:)
    @NSManaged public func removeFromSeries(_ value: CDSeriesItem)
    
    @objc(addSeries:)
    @NSManaged public func addToSeries(_ values: NSSet)
    
    @objc(removeSeries:)
    @NSManaged public func removeFromSeries(_ values: NSSet)
    
    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: CDEpisode)
    
    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: CDEpisode)
    
    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)
    
    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
