//
//  EpisodeType.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct IconAsset: Decodable {
    private(set) var  thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
           case thumbnailUrl
           case url
       }
       
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            thumbnailUrl = nil
            
            if let thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl) {
                self.thumbnailUrl = thumbnailUrl
            }
            else {
                for key in container.allKeys {
                    let value = try container.decode(String.self, forKey: key)
                    if value.isValidURL {
                        thumbnailUrl = value
                    }
                }
            }
        }
    }
    
    init(thumbnailUrl: String?) {
        self.thumbnailUrl = thumbnailUrl
    }
}
