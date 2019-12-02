//
//  FeedCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedCollectionViewManager: NSObject {

    private let collectionView: FeedCollectionView
    private lazy var emptyView: EmptyFeedView = {
        let view = EmptyFeedView()
        view.set(text: "You are all done! 🎉")
        return view
    }()

    private var items: [FeedType] = []

    var didSelect: (FeedType) -> Void = { _ in }

    init(with collectionView: FeedCollectionView) {
        self.collectionView = collectionView
        super.init()
        self.initialize()
    }

    private func initialize() {
        self.collectionView.countOfVisibleCards = 3
        self.collectionView.backgroundCardsTopMargin = 10
        self.collectionView.alphaValueOpaque = 1.0
        self.collectionView.alphaValueTransparent = 1.0
    }

    func set(items: [FeedType]) {
        if items.count == 0 {
            self.collectionView.addSubview(self.emptyView)
            self.emptyView.frame = self.collectionView.bounds
        } else {
            self.emptyView.removeFromSuperview()
            self.items = items
            self.collectionView.reloadData()
        }
    }
}

extension FeedCollectionViewManager: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.items.count
    }

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        guard let item = self.items[safe: index] else { return UIView() }
        let feedView = FeedView()
        feedView.configure(with: item)
        return feedView
    }
}

extension FeedCollectionViewManager: KolodaViewDelegate {

    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        guard let item = self.items[safe: index] else { return }
        self.didSelect(item)
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard let item = self.items[safe: index] else { return }

        switch item {
        case .channelInvite(let channel):
            if direction == .right {
                channel.joinIfNeeded().observe { (result) in
                    
                }
            } else if direction == .left {
                channel.declineInvitation { (result) in

                }
            }
            break
        default:
            break
        }
    }

    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //Show empty view
        self.collectionView.addSubview(self.emptyView)
        self.emptyView.frame = self.collectionView.bounds
    }

    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return FeedOverlayView()
    }
}
