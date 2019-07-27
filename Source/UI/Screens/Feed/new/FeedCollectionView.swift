//
//  FeedCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/25/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedCollectionView: CollectionView {
    /// A `Bool` that indicates if the `UICollectionView` is currently scrolling.
    public var isScrolling: Bool {
        return (self.isDragging || self.isTracking || self.isDecelerating)
    }
}
