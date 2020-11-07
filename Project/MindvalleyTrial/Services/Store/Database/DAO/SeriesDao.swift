//
//  SeriesDao.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 27.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

import Foundation
import CoreData

/// Class is thread safe and can be used from any thread.
class SeriesDao {
    
    let managedContext: NSManagedObjectContext
    lazy var channelsDao = ChannelsDao(managedContext: managedContext)
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    @discardableResult
    func addOrUpdate(_ seriesItem: SeriesItem, forChannel channel: Channel) throws -> SeriesItem {
        let cdSeriesItem = try cdAddOrUpdate(seriesItem, forChannel: channel)
        return SeriesItem(with: cdSeriesItem)
    }
}

extension SeriesDao {
    func cdAddOrUpdate(_ seriesItem: SeriesItem, forChannel channel: Channel) throws -> CDSeriesItem {
            do {
               if let cdSeriesItem = try readCDSeriesItem(byTitle: seriesItem.title,
                                                          channelTitle: channel.title) {
                   cdSeriesItem.update(with: seriesItem)
                          return cdSeriesItem
                      }
                      else {
                          let cdSeriesItem = CDSeriesItem(context: managedContext)
                          cdSeriesItem.update(with: seriesItem)
                          return cdSeriesItem
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

private extension SeriesDao {
    
    /// - Returns: `nil` if there is no episode with such id.
    func readCDSeriesItem(byTitle title: String, channelTitle: String) throws -> CDSeriesItem? {
        let fetchRequest: NSFetchRequest<CDSeriesItem> = CDSeriesItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ && %K == %@",
                                             #keyPath(CDSeriesItem.title), title,
                                             #keyPath(CDSeriesItem.channel.title), channelTitle)
        let cdEpisode = try managedContext.fetch(fetchRequest).first
        return cdEpisode
    }
    
}

private extension CDSeriesItem {
    
    func update(with seriesItem: SeriesItem) {
        self.title = seriesItem.title
        self.coverAssetUrl = seriesItem.coverAsset.url
    }
}
