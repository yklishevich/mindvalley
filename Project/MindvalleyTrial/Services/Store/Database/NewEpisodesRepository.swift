//
//  HomeRepository.swift
//  RubetekEvo
//
//  Created by Yauheni Klishevich on 05.02.2020.
//  Copyright © 2020 Eugene Klishevich. All rights reserved.
//

import Foundation
import CoreData

class NewEpisodesRepository {
    
    private let backgroundContext = DaoManager.shared.backgroundContext
    private let mainContext = DaoManager.shared.mainContext
    
    // MARK: -
    
    func readAllNewEpisodes() throws -> [Episode] {
        var retEpisodes = [Episode]()
        var errorToThrowIfAny: Error? = nil
        
        mainContext.performAndWait {
            do {
                let episodesDao = NewEpisodesDao(managedContext: mainContext)
                retEpisodes = try episodesDao.readAllNewEpisodes()
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
    
    func replaceNewEpisodes(with episodes: [Episode], completion: @escaping (Error?) -> ()) {
        backgroundContext.perform {
            var errorOrNil: Error?
            
            do {
                let newEpisodesDao = NewEpisodesDao(managedContext: self.backgroundContext)
                let oldNewEpisodes = try newEpisodesDao.readAllNewEpisodes()
                let oldNewEpisodesSet = Set(oldNewEpisodes)
                
                let episodesSet = Set(episodes)
                
                try oldNewEpisodesSet.forEach { oldNewEpisode in
                    if !episodesSet.contains(oldNewEpisode) {
                        try newEpisodesDao.remove(byEpisodeTitle: oldNewEpisode.title,
                                                  channelTitle: oldNewEpisode.lightweightChannel.title)
                    }
                }
                
                try episodesSet.forEach {
                    try newEpisodesDao.addOrUpdate($0)
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
