//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class FeedCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = FeedType

    func configure(with item: FeedType?) {
        guard let _ = item else { return }
    }
}
