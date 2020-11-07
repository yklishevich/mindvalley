//
//  ChannelsManager.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

protocol ChannelsDataProvider {
    func fetchNewEpisodes(completion: @escaping (LoadingResult<[Episode], Error>)->Void)
    func fetchChannels(completion: @escaping (LoadingResult<[Channel], Error>)->Void)
    func fetchCategories(completion: @escaping (LoadingResult<[Category], Error>)->Void)
}

// TODO: think about factoring common code out
class ChannelsManager: ChannelsDataProvider {
    
    static let shared = ChannelsManager()
    
    /// Completion is invoked several times until success or failure is returned.
    /// - Parameter limit: max allowed number of new episodes
    func fetchNewEpisodes(completion: @escaping (LoadingResult<[Episode], Error>)->Void) {
        let repo = NewEpisodesRepository()
        var newEpisodes: [Episode]?
        
        completion(.loading(nil, nil))
        do {
            newEpisodes = try repo.readAllNewEpisodes()
            completion(.loading(newEpisodes, nil))
        }
        catch {
            completion(.loading(nil, error))
        }
        
        APIService.getNewEpisodes() { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(newEpisodes, error))
            case .success(let newEpisodes):
                
                // Comment From Eugene Klishevich: we return data before saving it into DB
                // it's not cricial and allows to render data a little bit earlier which impove UX
                completion(.success(newEpisodes))
                
                repo.replaceNewEpisodes(with: newEpisodes) { (error) in
                    if let error = error {
                        log.error(error)
                    }
                }
            }
        }
    }
    
    /// Completion is invoked several times until success or failure is returned.
    /// - Parameter limit: max allowed number of  episodes or series
    func fetchChannels(completion: @escaping (LoadingResult<[Channel], Error>)->Void) {
        let repo = ChannelsRepository()
        var channels: [Channel]?
        
        completion(.loading(nil, nil))
        do {
            channels = try repo.readAllChannels()
            completion(.loading(channels, nil))
        }
        catch {
            completion(.loading(nil, error))
        }
        
        APIService.getChannels() { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(channels, error))
            case .success(let channels):
                completion(.success(channels))
                
                repo.replaceAllChannels(with: channels) { (error) in
                    if let error = error {
                        log.error(error)
                    }
                }
            }
        }
    }
    
    /// Completion is invoked several times until success or failure is returned.
    func fetchCategories(completion: @escaping (LoadingResult<[Category], Error>)->Void) {
        let repo = CategoryRepository()
        var categories: [Category]?
        
        completion(.loading(nil, nil))
        do {
            categories = try repo.readAllCategories()
            completion(.loading(categories, nil))
        }
        catch {
            completion(.loading(nil, error))
        }

        APIService.getCategories() { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(categories, error))
            case .success(let categories):
                completion(.success(categories))
                
                repo.replaceAllCategories(with: categories) { (error) in
                    if let error = error {
                        log.error(error)
                    }
                }
            }
        }
    }
}



