//
//  NewEpisodesPresenterModel.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 25.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit


class ChannelPresentationModel {
    
    var title: String
    var mediaCount: Int
    var iconUrl: String?
    var mediaPresentationModels = [MediaPresentationModel]()
    
    var viewDesign: ChannelViewDesign = .course
    
    init(title: String,
         mediaCount: Int,
         iconUrl: String?,
         mediaPresentationModels: [MediaPresentationModel]) {
        
        self.title = title
        self.mediaCount = mediaCount
        self.iconUrl = iconUrl
        self.mediaPresentationModels = mediaPresentationModels
    }
    
}

