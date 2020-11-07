//
//  ChannelsViewController.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import SGImageCache

// TODO: for section numbers create enum to improve readability
final class ChannelsViewController: UIViewController {
    
    var presenter: ViewToPresenterChannelsProtocol!
    
    private let newEpisodesTableCellReuseId = "newEpisodesTableCell"
    private let channelTableCellReuseId = "channelTableCell"
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    private var newEpisodesCell: NewEpisodesTableCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.setupView()
        
        navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Roboto-Medium", size: 14)!,
            NSAttributedString.Key.foregroundColor : UIColor(named: "SecondaryText")!
        ]
        
        bindPresenter()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let categoriesCellIndexPath = IndexPath(row: 0, section: 2)
        if let indeces = tableView.indexPathsForVisibleRows, indeces.contains(categoriesCellIndexPath) {
            tableView.reloadSections(IndexSet(integer: categoriesCellIndexPath.section), with: .fade)
        }
        
    }
    
    // MARK: - Helpers
    
    private func bindPresenter() {
        presenter.newEpisodePresentationModels
            .subscribe(onNext: { [unowned self] (newEpisodes) in
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            })
            .disposed(by: disposeBag)
        
        presenter.channelPresentionModels
            .subscribe(onNext: { [unowned self] (channelPresentationModels) in
                self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
            })
            .disposed(by: disposeBag)
        
        presenter.categoryNames
            .subscribe(onNext: { [unowned self] (names) in
                // animation is performed by cell itself
                self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let newEpisodesCellNib = UINib(nibName: "NewEpisodesTableCell", bundle: nil)
        tableView.register(newEpisodesCellNib, forCellReuseIdentifier: newEpisodesTableCellReuseId)
        
        let channelCellNib = UINib(nibName: "ChannelTableCell", bundle: nil)
        tableView.register(channelCellNib, forCellReuseIdentifier: channelTableCellReuseId)
        
        let categoriesCellNib = UINib(nibName: "CategoriesTableCell", bundle: nil)
        tableView.register(categoriesCellNib, forCellReuseIdentifier: CategoriesTableCell.reuseIdentifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(100)
        
        headerLabel.text = NSLocalizedString("channelsVC_header", comment: "")
    }
}

// MARK: - PresentorToViewChannelsProtocol
extension ChannelsViewController: PresentorToViewChannelsProtocol {
    
    // TODO: move reloading into corresonding presentation model
    func reloadNewEpisodes() {
        newEpisodesCell?.reloadData()
    }
}

extension ChannelsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (presenter.newEpisodePresentationModels.value.isEmpty ? 0 : 1)
        case 1:
            return presenter.channelPresentionModels.value.count
        case 2:
            return (presenter.categoryNames.value.isEmpty ? 0 : 1)
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if newEpisodesCell != nil {
                return newEpisodesCell
            }
            else {
                newEpisodesCell =
                    (tableView.dequeueReusableCell(withIdentifier: newEpisodesTableCellReuseId) as! NewEpisodesTableCell)
                
                newEpisodesCell.newEpisodePresentationModels = presenter.newEpisodePresentationModels.value
                return newEpisodesCell
            }
        }
        else if indexPath.section == 1 {
             let cell =
                (tableView.dequeueReusableCell(withIdentifier: channelTableCellReuseId) as! ChannelTableCell)

            let channelPresentationModel = presenter.channelPresentionModels.value[indexPath.row]
            cell.channelPresentationModel = channelPresentationModel
            cell.tag = indexPath.row

            cell.iconView.image = nil
            if let iconUrl = channelPresentationModel.iconUrl {
                if let image = SGImageCache.image(forURL: iconUrl) {
                    cell.iconView.image = image   // image loaded immediately from cache
                }
                else {
                    SGImageCache.getImage(url: iconUrl) { image in
                        cell.iconView.setImageWithCrossfadeAnimation(image!)
                    }
                }
            }
            return cell
        }
        else if indexPath.section == 2 {
            let categoriesCell =
                (tableView.dequeueReusableCell(withIdentifier: CategoriesTableCell.reuseIdentifier) as! CategoriesTableCell)
            categoriesCell.categoryNames = presenter.categoryNames.value
            return categoriesCell
        }
        else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let channelTableCell = cell as! ChannelTableCell
            if channelTableCell.iconView.image == nil {
                SGImageCache.moveTaskToSlowQueue(forURL: channelTableCell.channelPresentationModel.iconUrl)
            }
        }
    }
    
}


// MARK: - UITableViewDataSourcePrefetching
extension ChannelsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            SGImageCache.slowGetFile(forURL: presenter.channelPresentionModels.value[indexPath.row].iconUrl)
        }
    }
    
}
