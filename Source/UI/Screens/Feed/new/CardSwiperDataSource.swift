//
//  FeedDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/// This datasource is used for providing data to the `VerticalCardSwiper`.
protocol CardSwiperDataSource: class {

    /**
     Sets the number of cards for the `UICollectionView` inside the VerticalCardSwiperController.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` where we set the amount of cards.
     - returns: an `Int` with the amount of cards we want to show.
     */
    func numberOfCards(cardSwiperView: CardSwiperView) -> Int

    /**
     Asks your data source object for the cell that corresponds to the specified item in the `VerticalCardSwiper`.
     Your implementation of this method is responsible for creating, configuring, and returning the appropriate `CardCell` for the given item.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` that will display the `CardCell`.
     - parameter index: The that the `CardCell` should be shown at.
     - returns: A CardCell object. The default value is an empty CardCell object.
     */
    func cardForItemAt(cardSwiperView: CardSwiperView, cardForItemAt index: Int) -> CardCell
}
