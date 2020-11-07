//
//  ChannelsInteractor.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

class ChannelsInteractor: PresenterToInteractorChannelsProtocol {
    var presenter: InteractorToPresenterChannelsProtocol!
    var channelsDataProvider: ChannelsDataProvider!
    
    func fetchNewEpisodes(completion: @escaping (LoadingResult<[Episode], Error>)->Void) {
        channelsDataProvider.fetchNewEpisodes() {
            (loadingResult) in
            completion(loadingResult)
        }
    }
    
    func fetchChannels(completion: @escaping (LoadingResult<[Channel], Error>)->Void) {
        channelsDataProvider.fetchChannels {
            (loadingResult) in
            completion(loadingResult)
        }
    }
    
    func fetchCategories(completion: @escaping (LoadingResult<[Category], Error>)->Void) {
        channelsDataProvider.fetchCategories() {
            (loadingResult) in
            completion(loadingResult)
        }
    }

}
