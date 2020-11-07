//
//  NewEpisodeCollectionCell.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryCollectionCell"
    // UIScreen.main.bounds.size can return size in landscape mode, so we use nativeBounds
    static let cellSize = CGSize(width: cellWidth, height: cellHeight)

    static let cellWidth = (UIScreen.main.nativeBounds.size.width/UIScreen.main.nativeScale - 2*20 - 15) / 2.0
    static let cellHeight = CGFloat(60.0)

    @IBOutlet var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.button.layer.cornerRadius = CategoryCollectionCell.cellSize.height / 2.0
        self.button.clipsToBounds = true
        
        self.button.titleLabel?.textAlignment = .center
        self.button.titleLabel?.numberOfLines = 2

//        contentView.widthAnchor.constraint(equalToConstant: CategoryCollectionCell.cellWidth).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: CategoryCollectionCell.cellHeight).isActive = true
    }
    
}


