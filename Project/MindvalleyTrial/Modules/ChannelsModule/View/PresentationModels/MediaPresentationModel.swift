//
//  MediaPresentationModel.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

/// Abstraction is intended to serve as simple data model for other view (not view model).
protocol MediaPresentationModel {
    var title: String { get }
    var channelTitle: String? { get }
    var imageURL: String { get }
    var design: ChannelViewDesign { get }
}

enum ChannelViewDesign {
    case course
    case series
}
