//
//  HomeRepository.swift
//  RubetekEvo
//
//  Created by Yauheni Klishevich on 05.02.2020.
//  Copyright © 2020 Eugene Klishevich. All rights reserved.
//

import Foundation
import CoreData

class ChannelsRepository {
    
    private let backgroundContext = DaoManager.shared.backgroundContext
    private let mainContext = DaoManager.shared.mainContext

    
    // MARK: -

    func readAllChannels() throws -> [Channel] {
        var retEpisodes = [Channel]()
        var errorToThrowIfAny: Error? = nil
        let channelsDao = ChannelsDao(managedContext: mainContext)

        mainContext.performAndWait {
            do {
                retEpisodes = try channelsDao.readAllChannels()
            }
            catch {
                errorToThrowIfAny = error
            }
        }

        if let error = errorToThrowIfAny {
            throw error
        }

        return retEpisodes
    }

    func replaceAllChannels(with channels: [Channel], completion: @escaping (Error?) -> ()) {
        backgroundContext.perform {
            var errorOrNil: Error?

            do {
                let channelsDao = ChannelsDao(managedContext: self.backgroundContext)
                let oldChannels = try channelsDao.readAllChannels()
                for oldChannel in oldChannels {
                    try channelsDao.remove(byTitle: oldChannel.title)
                }
                
                // TODO: replace more efficiently
                try channels.forEach {
                    try channelsDao.addOrUpdate($0)
                }

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
            }
            catch {
                self.backgroundContext.rollback()
                errorOrNil = error
            }

            DispatchQueue.main.async {
                completion(errorOrNil)
            }
        }
    }
    
}
