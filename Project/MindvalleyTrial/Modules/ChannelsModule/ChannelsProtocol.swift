//
//  ChannelsProtocol.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import RxRelay

protocol  ChannelsPresenterIntput: InteractorToPresenterChannelsProtocol & ViewToPresenterChannelsProtocol {}

protocol PresenterToInteractorChannelsProtocol {
    var presenter: InteractorToPresenterChannelsProtocol! { get set }
    var channelsDataProvider: ChannelsDataProvider! { get set }
    
    func fetchNewEpisodes(completion: @escaping (LoadingResult<[Episode], Error>)->Void)
    func fetchChannels(completion: @escaping (LoadingResult<[Channel], Error>)->Void)
    func fetchCategories(completion: @escaping (LoadingResult<[Category], Error>)->Void) 
}

protocol InteractorToPresenterChannelsProtocol {
    var interactor: PresenterToInteractorChannelsProtocol! { get set }
}

protocol ViewToPresenterChannelsProtocol {
    var view: PresentorToViewChannelsProtocol! { get set }
    var newEpisodePresentationModels: BehaviorRelay<[EpisodePresentationModel]> { get }
    var channelPresentionModels:BehaviorRelay<[ChannelPresentationModel]> { get }
    var categoryNames:BehaviorRelay<[String]> { get }
    func setupView()
}

protocol PresentorToViewChannelsProtocol: class {}

protocol PresentorToRouterChannelsProtocol {}


