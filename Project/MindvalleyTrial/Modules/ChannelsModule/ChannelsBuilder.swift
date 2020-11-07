//
//  ChannelsAssembly.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

class ChannelsBuilder {
        
    @discardableResult
    static func createModule(with viewController: ChannelsViewController) -> ChannelsPresenterIntput {
        let presenter = ChannelsPresenter()
        let interactor = ChannelsInteractor()
        interactor.channelsDataProvider = ChannelsManager.shared
        let router = ChannelsRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return presenter
    }
}
