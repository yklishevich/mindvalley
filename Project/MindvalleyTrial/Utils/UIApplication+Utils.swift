//
//  UIApplication+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 30.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// This property is NON-DEPRECATED alternative to `keyWindow` property (in sence how it was used before iOS 13.0) and only for case when
    /// the app does not support scenes.
    /// As of iOS 13.0 `UIApplication.keyWindow` property was deprecated and using it directly produces compiler warning.
    /// `keyWindow` was deprecated because app starting from iOS 13.0 can support multiple scenes and each scene has it's own key window and
    ///  key window of scene should be retrieved via `UIWindowSceneDelegate.window` property.
    var keyWindowOfAppWithoutScenesSupport: UIWindow? {
        if #available(iOS 13.0, *) {
            precondition(UIApplication.shared.supportsMultipleScenes == false)
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
    
}
