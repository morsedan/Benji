//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class FeedCell: SwipeableView {

    override func initializeViews() {
        super.initializeViews()

        self.set(backgroundColor: .background3)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }
    
    func configure(with item: FeedType) {

    }
}
