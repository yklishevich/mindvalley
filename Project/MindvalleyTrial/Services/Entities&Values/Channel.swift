//
//  LightweightChannel.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

/// Inheriting `Decodable` class, so manual implementation of `Decodable`
/// See https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
final class Channel: Decodable {

    let title: String
    let mediaCount: Int
    let latestMedia: [Episode]
    let series: [SeriesItem]
    let iconAsset: IconAsset
    let coverAsset: CoverAsset
    var position: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case mediaCount
        case latestMedia
        case series
        case iconAsset
        case coverAsset
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        mediaCount = try container.decode(Int.self, forKey: .mediaCount)
        series = try container.decode([SeriesItem].self, forKey: .series)
        latestMedia = try container.decode([Episode].self, forKey: .latestMedia)
        iconAsset = try container.decode(IconAsset.self, forKey: .iconAsset)
        coverAsset = try container.decode(CoverAsset.self, forKey: .coverAsset)
        position = 0
        latestMedia.forEach { $0.lightweightChannel = LightweightChannel(self) }
    }
    
    /// - Parameter maxNumOfItems: max number of episodes or series (if exist) to decode
    init(from decoder: Decoder, position: Int, maxNumOfItems: Int) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        mediaCount = try container.decode(Int.self, forKey: .mediaCount)
        
        series = try container.decodeArray(SeriesItem.self, forKey: .series, limit:maxNumOfItems)
        if series.isEmpty {
            latestMedia = try container.decodeArray(Episode.self,
                                                    forKey: .latestMedia,
                                                    keypathToSetPosition: \.position,
                                                    limit: maxNumOfItems)
        }
        else {
            latestMedia = []
        }
        
        iconAsset = try container.decode(IconAsset.self, forKey: .iconAsset)
        coverAsset = try container.decode(CoverAsset.self, forKey: .coverAsset)
        self.position = position
        
        latestMedia.forEach { $0.lightweightChannel = LightweightChannel(self) }
    }
    
    init(title: String,
         mediaCount: Int,
         latestMedia: [Episode],
         series: [SeriesItem],
         iconAsset: IconAsset,
         coverAsset: CoverAsset,
         position: Int) {
        self.title = title
        self.mediaCount = mediaCount
        self.latestMedia = latestMedia
        self.series = series
        self.iconAsset = iconAsset
        self.coverAsset = coverAsset
        self.position = position
        latestMedia.forEach { $0.lightweightChannel = LightweightChannel(self) }
    }
}
