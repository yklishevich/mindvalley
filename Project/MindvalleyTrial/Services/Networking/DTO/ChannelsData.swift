//
//  NewEpisodesData.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 26.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct ChannelsData: Decodable {
    /// WARNING: property is static, it you use it, then you should guarantee that only with one instance of this type there is work at a time.
    static var maxNumOfItemsInChannelToDecode = Int.max
    
    let data: Channels
}

struct Channels: Decodable {
    
    let channels: [Channel]
    
    enum CodingKeys: String, CodingKey {
        case channels
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var channelsContainer = try container.nestedUnkeyedContainer(forKey: .channels)
        var aChannels = [Channel]()
        var counter = 0
        while !channelsContainer.isAtEnd {
            let channelContainer = try channelsContainer.nestedContainer(keyedBy: Channel.CodingKeys.self)
            let channelDecoder = ChannelDecoder(container: channelContainer)
            
            let channel = try Channel(from: channelDecoder,
                                      position: counter,
                                      maxNumOfItems: ChannelsData.maxNumOfItemsInChannelToDecode)

            counter += 1
            aChannels.append(channel)
        }
        
        channels = aChannels
    }
}


class ChannelDecoder: Decoder {
    
    let container: KeyedDecodingContainer<Channel.CodingKeys>
    
    init(container: KeyedDecodingContainer<Channel.CodingKeys>) {
        self.container = container
    }
    
    var userInfo = [CodingUserInfoKey : Any]()
    
    var codingPath: [CodingKey] {
        return container.codingPath
    }
    
    // TODO: fix strange warning
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return (self.container as! KeyedDecodingContainer<Key>)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw NSError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw NSError()
    }
}

