//
//  UILabel+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 30.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

extension UILabel {
    func copyLayoutRelatedAttributes(from label: UILabel) {
        self.numberOfLines = label.numberOfLines
        self.font = label.font
        self.lineBreakMode = label.lineBreakMode
    }
    
    static let sizingLabel = UILabel()
    
    func height(for width: CGFloat) -> CGFloat {
        let label = UILabel.sizingLabel
        label.text = self.text
        label.copyLayoutRelatedAttributes(from: self)
        let size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        return label.systemLayoutSizeFitting(size).height
    }
}
