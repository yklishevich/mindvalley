//
//  LightweightChannel.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct LightweightChannel: Decodable {
    
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(_ channel: Channel) {
        self.title = channel.title
    }
}
