//
//  RootRouter.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

class RootRouter {
    
    func setupRouter(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController =
            storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
        
        let channelsNC = tabBarController.viewControllers![0] as! UINavigationController
        let channelsVC = channelsNC.topViewController as! ChannelsViewController
        
        ChannelsBuilder.createModule(with: channelsVC)
        
        window.rootViewController = tabBarController
    }
    
}
