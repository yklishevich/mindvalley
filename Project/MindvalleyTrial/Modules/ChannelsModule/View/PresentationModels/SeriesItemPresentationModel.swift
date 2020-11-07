//
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 25.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

struct SeriesItemPresentationModel: MediaPresentationModel {
    let title: String
    let imageURL: String
    
    var channelTitle: String? = nil
    
    var design: ChannelViewDesign { .series }
}
