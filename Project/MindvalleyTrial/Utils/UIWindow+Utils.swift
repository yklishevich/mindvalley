//
//  UIWindow+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 30.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

extension UIWindow {
    
    // Used to avoid compiler warning when using `UIApplication.statusBarOrientation` property
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        }
        else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
