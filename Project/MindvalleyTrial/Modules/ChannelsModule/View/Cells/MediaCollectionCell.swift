//
//  NewEpisodeCollectionCell.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import SGImageCache

// TODO: move out all layout constants into `MediaCollectionCellLayoutInfo`
class MediaCollectionCell: UICollectionViewCell {
    
    var mediaPresentationModel: MediaPresentationModel! {
        didSet {
            titleLabel.text = mediaPresentationModel.title
            channelTitleLabel.text = mediaPresentationModel.channelTitle
            if mediaPresentationModel.channelTitle == nil {
                self.channelTitleLabel.isHidden = true
            }
            design = mediaPresentationModel.design
        }
    }

    var design: ChannelViewDesign = .course {
        didSet {
            if design == .course {
                apply(layoutInfo: LayoutInfo.course)
            }
            else {
                apply(layoutInfo: LayoutInfo.series)
            }
        }
    }

    @IBOutlet weak var imageView: MindvalleyStyledImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var imageToTitleVSpaceContraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleAndChannelStackView: UIStackView!
    @IBOutlet weak var stackLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackRightMarginConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        channelTitleLabel.text = nil
        contentView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        assert(titleAndChannelStackView.spacing == MediaCollectionCell.titleAndChanelVerticalInterspacing)
        assert(stackLeftMarginConstraint.constant == MediaCollectionCell.titleStackLeftMargin)
        assert(stackRightMarginConstraint.constant == MediaCollectionCell.titleStackRightMargin)
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
    }
    
    private func apply(layoutInfo: LayoutInfo) {
        imageHeightConstraint.constant = layoutInfo.imageHeight
        imageToTitleVSpaceContraint.constant = layoutInfo.imageToTitleVSpacing
    }
    
}

extension MediaCollectionCell {
    static func calculateHeightOfCollectionView(presentationModels: [MediaPresentationModel]) -> CGFloat {
        var height = CGFloat.zero
        presentationModels.forEach {
            let cellHeight = MediaCollectionCell.calculateHeigtOfCollectionCell(with: $0)
            height = max(height, cellHeight)
        }
        return height
    }
    
    static let sizingCell: MediaCollectionCell = {
        let nib = Bundle.main.loadNibNamed("MediaCollectionCell", owner: self)!
        return nib.first as! MediaCollectionCell
    }()
    
    // TODO: move constants into LayoutInfo
    static let titleAndChanelVerticalInterspacing = CGFloat(12)
    static let titleStackLeftMargin = CGFloat(14)
    static let titleStackRightMargin = CGFloat(10)
    
    static let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.copyLayoutRelatedAttributes(from: sizingCell.titleLabel!)
        return titleLabel
    }()
    
    static let channelLabel: UILabel = {
        let channelLabel = UILabel()
        channelLabel.copyLayoutRelatedAttributes(from: sizingCell.channelTitleLabel!)
        return channelLabel
    }()
    
    // TODO: create named constants for magical layout constants
    // TODO: move code into to separate file (class)
    // applying systemLayoutSizeFitting to the sizingCell doesn' work for some reason
    static func calculateHeigtOfCollectionCell(with presentationModel: MediaPresentationModel) -> CGFloat {
        let labelVerticalInterspacing = CGFloat(12)
        
        titleLabel.text = presentationModel.title
        titleLabel.bounds.size.width = MediaCollectionCell.LayoutInfo.cellWidth(for: presentationModel.design) -
            (titleStackLeftMargin + titleStackRightMargin)
        let titleSize = CGSize(width: titleLabel.bounds.size.width,
                               height: UIView.layoutFittingCompressedSize.height)
        let titleHeight = titleLabel.systemLayoutSizeFitting(titleSize).height
        
        var channelHeightWithInterspace = CGFloat(0.0)
        if presentationModel.channelTitle != nil {
            channelLabel.text = presentationModel.channelTitle
            channelLabel.bounds.size.width = titleLabel.bounds.size.width

            let channelSize = CGSize(width: channelLabel.bounds.size.width,
                                     height: UIView.layoutFittingCompressedSize.height)
            let channelHeight = channelLabel.systemLayoutSizeFitting(channelSize).height
            channelHeightWithInterspace = channelHeight + labelVerticalInterspacing
        }
        
        let hightOfCellWithoutLabels = presentationModel.design == .course ? CGFloat(258) : CGFloat(203)
        
        return hightOfCellWithoutLabels + titleHeight + channelHeightWithInterspace
    }
    
    struct LayoutInfo {
        let cellWidth: CGFloat
        let imageHeight: CGFloat
        let imageToTitleVSpacing: CGFloat
        
        static let leftImageMargin = CGFloat(10)
        static let rightImageMargin = leftImageMargin
        static let leftmostCellMargin = CGFloat(10)
        static let rightmostCellMargin = leftmostCellMargin

        static let course: LayoutInfo = {
            let spaceForImages = UIScreen.portraitWidth - leftmostCellMargin - 3*leftImageMargin - 2*rightImageMargin
            let width = spaceForImages / (2 + 11/152) + leftImageMargin + rightImageMargin
            return LayoutInfo(
                cellWidth: width,
                imageHeight: 228,
                imageToTitleVSpacing: 10
            )
        }()
        
        static let series: LayoutInfo = {
            let spaceForImages = UIScreen.portraitWidth - leftmostCellMargin - 2*leftImageMargin - rightImageMargin
            let width = spaceForImages / (1 + 20/320) + leftImageMargin + rightImageMargin
            return LayoutInfo(cellWidth: width,
                              imageHeight: 172,
                              imageToTitleVSpacing: 11
            )
        }()
        
        static func cellWidth(for design: ChannelViewDesign) -> CGFloat {
            switch design {
            case .course:
                return LayoutInfo.course.cellWidth
            case .series:
                return LayoutInfo.series.cellWidth
            }
        }
    }

}

