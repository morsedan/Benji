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

    private let kolodaView: KolodaView

    private var items: [FeedType] = []

    init(with kolodaView: KolodaView) {
        self.kolodaView = kolodaView
        super.init()
        self.initialize()
    }

    private func initialize() {
        self.kolodaView.countOfVisibleCards = 3
        self.kolodaView.backgroundCardsTopMargin = 10
    }

    func set(items: [FeedType]) {
        self.items = items
        self.kolodaView.reloadData()
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

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {

    }

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //Show empty view
    }

    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return FeedOverlayView()
    }

}
