//
//  Decoder+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 27.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    /// - Parameter limit: max number of elements that should be decoded
    /// - Parameter keypathToSetPosition: position of element in json will be set to the property indicated by this keypath
    func decodeArray<Element: Decodable>(
        _ elementType: Element.Type,
        forKey key: KeyedDecodingContainer<K>.Key,
        keypathToSetPosition: ReferenceWritableKeyPath<Element, Int?>? = nil,
        limit: Int = Int.max        
    ) throws -> [Element] {
        
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var elements: [Element] = []
        var counter = 0
        while !arrayContainer.isAtEnd && counter < limit {
            let element = try arrayContainer.decode(elementType.self)
            if let positionKeypath = keypathToSetPosition {
                element[keyPath: positionKeypath] = counter
            }
            elements.append(element)
            counter += 1
        }
        return elements
    }
}
