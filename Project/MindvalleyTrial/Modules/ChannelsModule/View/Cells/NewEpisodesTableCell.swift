//
//  NewEpisodeTableCell.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import SGImageCache

// TODO: use diffable datasource for collection view for reloading with animation
class NewEpisodesTableCell: UITableViewCell {
    
    var newEpisodePresentationModels: [EpisodePresentationModel]! {
        didSet {
            reloadData()
        }
    }
    
    private let newEpisodeCellReuseIdentifier = "MediaCollectionCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newEpisodesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("newEpisodesCell_title", comment: "")
        
        let newEpisodeCellNib = UINib(nibName: "MediaCollectionCell", bundle: nil)
        collectionView.register(newEpisodeCellNib, forCellWithReuseIdentifier: newEpisodeCellReuseIdentifier)
    }
    
    func reloadData() {
        collectionViewHeightConstraint.constant = MediaCollectionCell.calculateHeightOfCollectionView(
            presentationModels: newEpisodePresentationModels
        )
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource
extension NewEpisodesTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return newEpisodePresentationModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newEpisodeCellReuseIdentifier,
                                                      for: indexPath) as! MediaCollectionCell
        
        let episodePresentationModel = newEpisodePresentationModels[indexPath.row]
        cell.mediaPresentationModel = episodePresentationModel
        
        if let image = SGImageCache.image(forURL: episodePresentationModel.imageURL) {
            cell.imageView.image = image   // image loaded immediately from cache
        }
        else {
            SGImageCache.getImage(url: episodePresentationModel.imageURL) { image in
                cell.imageView.setImageWithCrossfadeAnimation(image!)
            }
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension NewEpisodesTableCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: MediaCollectionCell.LayoutInfo.cellWidth(for: .course),
                      height: collectionViewHeightConstraint.constant)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0,
                            left: MediaCollectionCell.LayoutInfo.leftmostCellMargin,
                            bottom: 0.0,
                            right: MediaCollectionCell.LayoutInfo.rightmostCellMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as! MediaCollectionCell
        if cell.imageView.image == nil {
            let imageUrl = newEpisodePresentationModels[indexPath.row].imageURL
            SGImageCache.moveTaskToSlowQueue(forURL: imageUrl)
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension NewEpisodesTableCell: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let iconUrl = newEpisodePresentationModels[indexPath.row].imageURL
            SGImageCache.slowGetFile(forURL: iconUrl)
        }
    }

}


