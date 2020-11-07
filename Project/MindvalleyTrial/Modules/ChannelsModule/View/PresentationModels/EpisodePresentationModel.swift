//
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 25.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct EpisodePresentationModel: MediaPresentationModel, CustomStringConvertible {
    let title: String
    let channelTitle: String?
    let imageURL: String
    
    var design: ChannelViewDesign { .course }
    
    var description: String {
        var str = "<\(type(of: self)):"
        str.append(" title = \(title)")
        str.append(">")
        return str
    }
}
