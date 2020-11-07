//
//  MindvalleyTrialTests.swift
//  MindvalleyTrialTests
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import XCTest
@testable import MindvalleyTrial
import RxSwift

// WARNING: class contains just one test for demonstration purposes
class ChannelsPresenterTests: XCTestCase {
    
    fileprivate static let maxAllowedNumberOfNewEpisodes = ChannelsPresenter.maxAllowedNumberOfItems
    
    private let disposeBag = DisposeBag()
    
    private var channelsPresenter: ChannelsPresenterIntput!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let channelsVC =
            storyboard.instantiateViewController(identifier: "ChannelsViewController") as! ChannelsViewController
        
        
        channelsPresenter = ChannelsBuilder.createModule(with: channelsVC)
        channelsPresenter.interactor.channelsDataProvider = MockChannelsDataProvider()
    }

    override func tearDownWithError() throws {
        channelsPresenter = nil
    }

    func test_presenter_setupView_numberOfNewEpisodesNotGreaterThanMaxAllowed() throws {
        // given
        let maxNum = ChannelsPresenterTests.maxAllowedNumberOfNewEpisodes
        let promise = expectation(description: "number of new episodes is \(maxNum)")
        var numberOfEpisodes = 0

        // when
        channelsPresenter.setupView()
        
        channelsPresenter.newEpisodePresentationModels
            .subscribe(onNext: { (episodes) in
                numberOfEpisodes = episodes.count
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [promise], timeout: 0.5)
        
        // then
        XCTAssertEqual(numberOfEpisodes, maxNum)
    }
    
    class MockChannelsDataProvider: ChannelsDataProvider {
        
        func fetchNewEpisodes(completion: @escaping (LoadingResult<[Episode], Error>)->Void) {
            
            let newEpisodes = (0...ChannelsPresenterTests.maxAllowedNumberOfNewEpisodes).map {
                Episode(title: "title\($0)",
                    type: .course,
                    coverAsset: CoverAsset(url: ""),
                    lightweightChannel: LightweightChannel(title: "channel\($0)"))
            }
            
            completion(LoadingResult.success(newEpisodes))
        }
        
        func fetchChannels(completion: @escaping (LoadingResult<[Channel], Error>)->Void) {}
        
        func fetchCategories(completion: @escaping (LoadingResult<[MindvalleyTrial.Category], Error>)->Void) {}
    }
}


