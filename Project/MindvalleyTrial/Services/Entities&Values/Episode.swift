//
//  NewEpisode.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

class Episode: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case type
        case coverAsset
        case channel
    }
    
    private(set) var id: String!
    let title: String
    let type: EpisodeType
    let coverAsset: CoverAsset
    var lightweightChannel: LightweightChannel! {
        didSet {
            self.calculateAndSetId()
        }
    }

    // Position in channel or in new episodes
    var position: Int!
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(EpisodeType.self, forKey: .type)
        coverAsset = try container.decode(CoverAsset.self, forKey: .coverAsset)
        lightweightChannel = try container.decodeIfPresent(LightweightChannel.self, forKey: .channel)
        if lightweightChannel != nil {
            self.calculateAndSetId()
        }
    }
    
    private func calculateAndSetId() {
        self.id = Utils.calculateHash(combining: [title, lightweightChannel.title])
    }
    
    init(title: String,
         type: EpisodeType,
         coverAsset: CoverAsset,
         lightweightChannel: LightweightChannel) {
        self.title = title
        self.type = type
        self.coverAsset = coverAsset
        self.lightweightChannel = lightweightChannel
    }
    
}

// MARK: - Hashable
extension Episode: Hashable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return (lhs.title == rhs.title && lhs.lightweightChannel.title == rhs.lightweightChannel.title)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(lightweightChannel.title)
    }
    
}



