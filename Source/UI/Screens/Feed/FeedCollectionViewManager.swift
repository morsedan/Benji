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
        self.cardSwiper.datasource = self
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
