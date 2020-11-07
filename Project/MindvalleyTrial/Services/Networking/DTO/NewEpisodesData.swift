//
//  NewEpisodesData.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 26.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct NewEpisodesData: Decodable {
    /// WARNING: property is static, it you use it, then you should guarantee that only with one instance of this type there is work at a time.
    static var maxNumOfEpisodesToDecode = Int.max
    
    let data: Media
}

struct Media: Decodable {
    
    let episodes: [Episode]
    enum CodingKeys: String, CodingKey {
        case episodes = "media"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        episodes = try container.decodeArray(Episode.self,
                                             forKey: .episodes,
                                             keypathToSetPosition: \.position,
                                             limit: NewEpisodesData.maxNumOfEpisodesToDecode)
    }
}

