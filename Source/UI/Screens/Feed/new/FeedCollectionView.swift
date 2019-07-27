//
//  FeedCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/25/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedCollectionView: CollectionView {

    private let emptyFeedView = EmptyFeedView()
    /// A `Bool` that indicates if the `UICollectionView` is currently scrolling.
    public var isScrolling: Bool {
        return (self.isDragging || self.isTracking || self.isDecelerating)
    }

    override func initialize() {
        super.initialize()

        let text = LocalizedString(id: "", default: "🎉 You are all done!")
        self.emptyFeedView.set(text: text)
        self.backgroundView = self.emptyFeedView
    }
}
