//
//  MindvalleyStyleImageView.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 25.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import SGImageCache

@objc class MindvalleyStyledImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
    }
    
}
