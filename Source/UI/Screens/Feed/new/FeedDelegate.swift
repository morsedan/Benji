//
//  FeedDelegate.swift
//  Benji
//
//  Created by Benji Dodgson on 7/25/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/// This delegate is used for delegating `CardCell` actions.
protocol FeedDelegate: class {

    /**
     Called right before a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func willSwipeAway(cell: CardCell, swipeDirection: SwipeDirection)

    /**
     Called when a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func didSwipeAway(cell: CardCell, swipeDirection: SwipeDirection)

    /**
     Called while the user is dragging a card to a side.

     You can use this to add some custom features to a card when it enters a certain `swipeDirection` (like overlays).
     - parameter card: The CardCell that the user is currently dragging.
     - parameter swipeDirection: The direction in which the card is being dragged.
     */
    func didDragCard(cell: CardCell, swipeDirection: SwipeDirection)
}
