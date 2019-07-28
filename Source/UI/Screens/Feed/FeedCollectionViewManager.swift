//
//  FeedCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import VerticalCardSwiper

class FeedCollectionViewManager: NSObject {

    private let cardSwiper: VerticalCardSwiper

    init(with cardSwiper: VerticalCardSwiper) {
        self.cardSwiper = cardSwiper
        super.init()
    }

    private func initialize() {
        self.cardSwiper.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        self.cardSwiper.isStackOnBottom = true
        self.cardSwiper.isStackingEnabled = true
        self.cardSwiper.isSideSwipingEnabled = true
        self.cardSwiper.stackedCardsCount = 3
    }
}

extension FeedCollectionViewManager: VerticalCardSwiperDatasource {

    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 0
    }

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: index) as? FeedCell else { return CardCell() }

        cell.configure(with: nil)
        return cell
    }
}

extension FeedCollectionViewManager: VerticalCardSwiperDelegate {

    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {

    }

    func didDragCard(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
    }

    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {

    }

    func didHoldCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int, state: UIGestureRecognizer.State) {

    }

    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {

    }

    func didEndScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        
    }

    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return .zero
    }
}
