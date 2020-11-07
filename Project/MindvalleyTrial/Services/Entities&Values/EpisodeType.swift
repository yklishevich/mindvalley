//
//  EpisodeType.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 26.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

enum EpisodeType: String, Decodable {
    case course
    case unknown
    
    init?(_ value: String) {
        switch value {
        case "course": self = .course
        default: self = .unknown
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(value)!
    }
}
