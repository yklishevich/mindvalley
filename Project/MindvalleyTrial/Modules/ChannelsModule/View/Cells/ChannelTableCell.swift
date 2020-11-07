//
//  NewEpisodeTableCell.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import SGImageCache

class ChannelTableCell: UITableViewCell {
    
    static var contentOffsetDict = [Int : CGFloat]()
    
    var channelPresentationModel: ChannelPresentationModel! {
        didSet {
            reloadData()
        }
    }
    
    let episodeCollectionCellId = "MediaCollectionCell"
    
    override var tag: Int {
        didSet {
            if let offset = ChannelTableCell.contentOffsetDict[tag] {
                self.collectionView.contentOffset.x = offset
            }
        }
    }

    @IBOutlet weak var iconView: SGImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mediaCountLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newEpisodesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageToCountBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = iconView.bounds.size.height / 2.0
        
        titleLabel.text = NSLocalizedString("newEpisodesCell_title", comment: "")
        
        let newEpisodeCellNib = UINib(nibName: "MediaCollectionCell", bundle: nil)
        collectionView.register(newEpisodeCellNib, forCellWithReuseIdentifier: episodeCollectionCellId)
    }
    
    func reloadData() {
        ChannelTableCell.contentOffsetDict.removeAll()
        
        titleLabel.text = channelPresentationModel.title
        mediaCountLabel.text = String(describing: channelPresentationModel.mediaCount)
        
        collectionViewHeightConstraint.constant = MediaCollectionCell.calculateHeightOfCollectionView(
            presentationModels: channelPresentationModel.mediaPresentationModels
        )
        
        collectionView.reloadData()
        calculateImageToCountBottomConstraint()
    }
    
    // TODO: improve readability of code by removing magic constants
    private func calculateImageToCountBottomConstraint() {
        // Eugene Klishevich: Excuse me for complexity. Calculations are based on "center of mass" formula
        let titleWeightByCountWeight = CGFloat(2)
        let w = titleWeightByCountWeight
        let h1 = titleLabel.height(for: UIScreen.main.bounds.width - 104)
        let h2 = mediaCountLabel.height(for: UIScreen.main.bounds.width - 104)
        
        // Because of compiler complaings expression has been broken up
        var sumOfMassesMultipliedByDistances = CGFloat(0)
        sumOfMassesMultipliedByDistances += (21 + h1/2) * w * h1
        sumOfMassesMultipliedByDistances += h2 * 10
        
        imageToCountBottomConstraint.constant = sumOfMassesMultipliedByDistances / (w * h1 + h2) - 25
    }
    
    override func prepareForReuse() {
        ChannelTableCell.contentOffsetDict[self.tag] = self.collectionView.contentOffset.x
    }
    
}

// MARK: - UICollectionViewDataSource
extension ChannelTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        channelPresentationModel.mediaPresentationModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: episodeCollectionCellId,
                                                      for: indexPath) as! MediaCollectionCell
        
        let episodePresentationModel = channelPresentationModel.mediaPresentationModels[indexPath.row]
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
extension ChannelTableCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = collectionViewHeightConstraint.constant
        let width = MediaCollectionCell.LayoutInfo.cellWidth(for: channelPresentationModel.viewDesign)
        return CGSize(width: width, height: height)
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
            let mediaPresentationModels = channelPresentationModel.mediaPresentationModels[indexPath.row]
            SGImageCache.moveTaskToSlowQueue(forURL: mediaPresentationModels.imageURL)
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ChannelTableCell: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let iconUrl = channelPresentationModel.mediaPresentationModels[indexPath.row].imageURL
            SGImageCache.slowGetFile(forURL: iconUrl)
        }
    }

}


