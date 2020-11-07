//
//  UIImageView+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithCrossfadeAnimation(_ image:UIImage) {
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = CATransitionType.fade
        layer.add(animation, forKey: "ImageFade")
        self.image = image
    }
    
}
