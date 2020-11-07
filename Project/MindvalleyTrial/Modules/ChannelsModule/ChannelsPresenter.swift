//
//  ChannelsPresenter.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ChannelsPresenter: ChannelsPresenterIntput {
    weak var view: PresentorToViewChannelsProtocol!
    var interactor: PresenterToInteractorChannelsProtocol!
    var router: PresentorToRouterChannelsProtocol!
    
    static let maxAllowedNumberOfItems = 6
    
    // TODO: migrate newEpisodesPresentationModel to using reactive approach
    var newEpisodePresentationModels = BehaviorRelay<[EpisodePresentationModel]>(value: [])
    var channelPresentionModels = BehaviorRelay<[ChannelPresentationModel]>(value: [])
    var categoryNames = BehaviorRelay<[String]>(value: [])
    
    func setupView() {
        interactor.fetchNewEpisodes()  {
            [weak self] (loadingResult) in
            guard let self = self else { return }
            
            if let newEpisodes = loadingResult.data {
                let newEpisodePresentationModels =
                    newEpisodes.prefix(ChannelsPresenter.maxAllowedNumberOfItems)
                        .map(EpisodePresentationModel.init)
                
                self.newEpisodePresentationModels.accept(newEpisodePresentationModels)
            }
            if let error = loadingResult.error {
                log.error(error)
            }
        }
        
        interactor.fetchChannels() {
            [weak self] (loadingResult) in
            guard let self = self else { return }
            
            if let channels = loadingResult.data {
                DispatchQueue.global().async {
                    let channelPresentionModels = channels.map {
                        ChannelPresentationModel(from: $0, withMaxNumOfItems: ChannelsPresenter.maxAllowedNumberOfItems)
                    }
                    
                    DispatchQueue.main.sync {
                        self.channelPresentionModels.accept(channelPresentionModels)
                    }
                }
            }
            if let error = loadingResult.error {
                log.error(error)
            }
        }
        
        interactor.fetchCategories { [weak self] (loadingResult) in
            guard let self = self else { return }
            
            if let categories = loadingResult.data {
                self.categoryNames.accept(categories.map {$0.name})
            }
            if let error = loadingResult.error {
                log.error(error)
            }
        }
    }

}

// MARK: - InteractorToPresenterChannelsProtocol
extension ChannelsPresenter: InteractorToPresenterChannelsProtocol {
      
}

extension ChannelPresentationModel {
    convenience init(from channel: Channel, withMaxNumOfItems maxNumOfItems: Int) {
        let mediaPresentationModels: [MediaPresentationModel]
        if channel.series.isEmpty {
            mediaPresentationModels = channel.latestMedia.prefix(maxNumOfItems).map {
                EpisodePresentationModel(title: $0.title,
                                         channelTitle: nil,
                                         imageURL: $0.coverAsset.url)
            }
        }
        else {
            mediaPresentationModels = channel.series.prefix(maxNumOfItems).map {
                SeriesItemPresentationModel(title: $0.title,
                                            imageURL: $0.coverAsset.url)
            }
        }
        
        self.init(title: channel.title,
                  mediaCount: channel.mediaCount,
                  iconUrl: channel.iconAsset.thumbnailUrl,
                  mediaPresentationModels: mediaPresentationModels)
        
        self.viewDesign = channel.series.isEmpty ? .course : .series
    }
}

extension EpisodePresentationModel {
    init(episode: Episode) {
        self.init(title: episode.title,
                  channelTitle: episode.lightweightChannel.title,
                  imageURL: episode.coverAsset.url)
    }
}
