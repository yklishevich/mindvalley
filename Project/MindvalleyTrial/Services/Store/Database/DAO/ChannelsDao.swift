//
//  ChannelsDao.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 26.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import CoreData

class ChannelsDao {
    
    private let managedContext: NSManagedObjectContext
    private let episodesDao: EpisodesDao
    private let seriesDao: SeriesDao

    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        self.episodesDao = EpisodesDao(managedContext: self.managedContext)
        self.seriesDao = SeriesDao(managedContext: self.managedContext)
    }
    
    @discardableResult
    func addOrUpdate(_ channel: Channel) throws -> Channel {
        do {
            if let cdChannel = try readCDChannel(byTitle: channel.title) {
                try cdChannel.update(with: channel, episodesDao: episodesDao, seriesDao: seriesDao)
                return Channel(with: cdChannel)
            }
            else {
                let cdChannel = CDChannel(context: managedContext)
                try cdChannel.update(with: channel, episodesDao: episodesDao, seriesDao: seriesDao)
                return Channel(with: cdChannel)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    /// - throws: `DaoError`
    /// - returns: Empty array if there is no channels in DB. Purely `LightweithtChannel`s are not included.
    func readAllChannels() throws -> [Channel] {
        var retChannels = [Channel]()
        
        do {
            let fetchRequest: NSFetchRequest<CDChannel> = CDChannel.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDChannel.position, ascending: true)
            ]
            let cdChannels = try managedContext.fetch(fetchRequest)
            retChannels = cdChannels.map(Channel.init)
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
        
        return retChannels
    }
    
    func remove(byTitle title: String) throws {
        do {
            if let cdChannel = try readCDChannel(byTitle: title) {
                managedContext.delete(cdChannel)
            }
            else {
                throw DaoError.attemptToDeleteNonExistingEntity(entityId: title, type: Channel.self)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    func read(byTitle title: String) throws -> Channel? {
        do {
            if let cdChannel = try readCDChannel(byTitle: title) {
                return Channel(with: cdChannel)
            }
            else {
                return nil
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
}

private extension ChannelsDao {
    
    /// - Returns: `nil` if there is no episode with such id.
    func readCDChannel(byTitle title: String) throws -> CDChannel? {
        let fetchRequest: NSFetchRequest<CDChannel> = CDChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CDEpisode.title), title)
        let cdEpisode = try managedContext.fetch(fetchRequest).first
        return cdEpisode
    }
}

// - Methods friendly to only all other DAO classes
internal extension ChannelsDao {
    
    func readCDChannel(with title: String) -> CDChannel? {
        let fetchRequest: NSFetchRequest<CDChannel> = CDChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CDChannel.title), title)
        if let cdChannel = try! managedContext.fetch(fetchRequest).first {
            return cdChannel
        }
        else {
            return nil
        }
    }
}

// MARK: - Extensions -

internal extension CDChannel {
    func update(with channel: Channel, episodesDao: EpisodesDao, seriesDao: SeriesDao) throws {
        self.title = channel.title
        self.position = Int32(channel.position)
        self.mediaCount = Int32(channel.mediaCount)
        self.iconAssetThumbnailURL = channel.iconAsset.thumbnailUrl
        self.coverAssetUrl = channel.coverAsset.url
        
        // TODO: update in more efficient way
        for cdEpisode in self.episodes {
            self.managedObjectContext?.delete(cdEpisode)
        }
        
        for episode in channel.latestMedia {
            let cdEpisode = try episodesDao.cdAddOrUpdate(episode)
            self.addToEpisodes(cdEpisode)
        }
        
        // TODO: update in more efficient way
        for cdSeriesItem in self.series {
            self.managedObjectContext?.delete(cdSeriesItem)
        }
        
        for sereisItem in channel.series {
            let cdSeriesItem = try seriesDao.cdAddOrUpdate(sereisItem, forChannel: channel)
            self.addToSeries(cdSeriesItem)
        }
    }
}

extension Channel {
    
    convenience init(with cdChannel: CDChannel) {
        let cdEpisodes = Array(cdChannel.episodes).sorted { $0.positionInChannel < $1.positionInChannel }
        let series = Array(cdChannel.series).sorted { $0.positionInChannel < $1.positionInChannel }
        
        self.init(title: cdChannel.title,
                  mediaCount: Int(cdChannel.mediaCount),
                  latestMedia: cdEpisodes.map(Episode.init),
                  series: series.map(SeriesItem.init),
                  iconAsset: IconAsset(thumbnailUrl: cdChannel.iconAssetThumbnailURL),
                  coverAsset: CoverAsset(url: cdChannel.coverAssetUrl),
                  position: Int(cdChannel.position))
    }
    
}

extension SeriesItem {
    convenience init(with cdSeriesItem: CDSeriesItem) {
        self.init(title: cdSeriesItem.title,
                  coverAsset: CoverAsset(url: cdSeriesItem.coverAssetUrl),
                  positionInChannel: Int(cdSeriesItem.positionInChannel))
    }
}

