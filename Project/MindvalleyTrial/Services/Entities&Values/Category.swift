//
//  Category.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

class Category: Decodable {
    let name: String
    var position: Int!
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(name: String, position: Int) {
        self.name = name
        self.position = position
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        // position will be set by container class when decoding
        position = 0
    }
}
