//
//  SeriesItem.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 27.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

class SeriesItem: Decodable {
    let title: String
    let coverAsset: CoverAsset
    var positionInChannel: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case coverAsset
    }
    
    init(title: String,
         coverAsset: CoverAsset,
         positionInChannel: Int) {
        self.title = title
        self.coverAsset = coverAsset
        self.positionInChannel = positionInChannel
    }
}
