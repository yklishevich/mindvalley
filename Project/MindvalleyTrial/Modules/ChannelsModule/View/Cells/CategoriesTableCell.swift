//
//  NewEpisodeTableCell.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 24.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import SGImageCache

class CategoriesTableCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    static let reuseIdentifier = "CategoriesTableCell"
    
    let lineSpacing = CGFloat(16.0)
    let minItemsInLineSpacing = CGFloat(15.0)
    let collectionViewHorMargin = CGFloat(20.0)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewLeftSpacingConstraint: NSLayoutConstraint!
    
    enum Section: CaseIterable {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    var categoryNames: [String]! {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            snapshot.appendSections([.main])
            snapshot.appendItems(categoryNames, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
            
            recalculateAndSetCollectionViewHeight()
        }
    }
    
    private func recalculateAndSetCollectionViewHeight() {
        let numOfButtonsInLine = numberOfButtonsInLine()
        let numOfLines =
            CGFloat((categoryNames.count / numOfButtonsInLine) + categoryNames.count % numOfButtonsInLine)
        let collectionViewHeight =
            numOfLines * CategoryCollectionCell.cellHeight + (numOfLines - 1) * lineSpacing
        collectionViewHeightConstraint.constant = CGFloat(collectionViewHeight)
        setNeedsUpdateConstraints()
    }
    
    private func numberOfButtonsInLine() -> Int {
        // TODO: remove warning
        return UIWindow.isLandscape ? 3 : 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionCell.reuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, name: String) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseIdentifier,
                                                          for: indexPath) as! CategoryCollectionCell
            cell.button.setTitle(name, for: .normal)
            return cell
        }
        
        self.collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        
        assert(collectionViewLeftSpacingConstraint.constant == collectionViewHorMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: remove warning
        let window = UIApplication.shared.keyWindowOfAppWithoutScenesSupport
        let leftPadding = window!.safeAreaInsets.left
        let rightPadding = window!.safeAreaInsets.right
        
        let numOfItemsInLine = CGFloat(numberOfButtonsInLine())
        let widthOfCollectionView = UIScreen.main.bounds.size.width - leftPadding - rightPadding
        
        var space = widthOfCollectionView - CGFloat(numOfItemsInLine - 1) * minItemsInLineSpacing
        space -= 2 * collectionViewHorMargin
        
        let itemWidth = space / numOfItemsInLine
        
        return CGSize(width: itemWidth, height: CategoryCollectionCell.cellHeight)
    }
    
}


