//
//  APIClient.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import Alamofire

final class APIService {

    static func getNewEpisodes(maxNumOfEpisodes: Int = Int.max, completion: @escaping (Result<[Episode], Error>)-> Void) {
        NewEpisodesData.maxNumOfEpisodesToDecode = maxNumOfEpisodes
        
//        let requestUrl = "https://pastebin.com/raw/z5AExTtw"
        let requestUrl = Bundle.main.url(forResource: "newEpisodes", withExtension: "json")!
        
        AF.request(requestUrl).responseDecodable(of: NewEpisodesData.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let newEpisodesData):
                let newEpisodes = newEpisodesData.data.episodes
                completion(.success(newEpisodes))
            }
        }
    }
    
    /// - Parameter maxNumOfLatestItemsOrSeries: if there are series then this is the max number of series that should be decoded, otherwise
    ///     max number of
    static func getChannels(maxNumOfEpisodesOrSeries: Int = Int.max,
                            completion: @escaping (Result<[Channel], Error>)-> Void) {
        ChannelsData.maxNumOfItemsInChannelToDecode = maxNumOfEpisodesOrSeries
        
        //        let requestUrl = "https://pastebin.com/raw/Xt12uVhM"
        let requestUrl = Bundle.main.url(forResource: "channels", withExtension: "json")!
        
        AF.request(requestUrl).responseDecodable(of: ChannelsData.self) { response in
            switch response.result {
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            case .success(let channelsData):
                let channels = channelsData.data.channels
                completion(.success(channels))
            }
        }
    }
    
    static func getCategories(completion: @escaping (Result<[Category], Error>)-> Void) {
        //        let requestUrl = "https://pastebin.com/raw/A0CgArX3"
        let requestUrl = Bundle.main.url(forResource: "categories", withExtension: "json")!
        
        AF.request(requestUrl).responseDecodable(of: CategoriesData.self) { response in
            switch response.result {
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            case .success(let categoriesData):
                let channels = categoriesData.data.categories
                completion(.success(channels))
            }
        }
    }

}
