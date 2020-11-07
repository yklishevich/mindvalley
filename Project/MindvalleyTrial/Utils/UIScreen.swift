//
//  UIScreen.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 30.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// Returns width of screen in portrait orientation
    /// UIScreen.main.bounds returns different size depending on UI orientation so it can't be used for calculating width in portrait mode.
    static let portraitWidth: CGFloat = {
        return UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale
    }()
    
}
