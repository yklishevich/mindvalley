//
//  CategoriesData.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct CategoriesData: Decodable {
    let data: Categories
}

struct Categories: Decodable {
    let categories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categories = try container.decodeArray(Category.self,
                                               forKey: .categories,
                                               keypathToSetPosition: \Category.position)
        
    }
}
