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

    let textView = FeedTextView()
    let avatarView = AvatarView()

    override func initialize() {

        self.addSubview(self.textView)
        self.addSubview(self.avatarView)

        self.set(backgroundColor: .background3)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }
    
    func configure(with item: FeedType) {
        switch item {
        case .system(let systemMessage):
            self.textView.set(localizedText: systemMessage.body)
            self.avatarView.set(avatar: systemMessage.avatar)
        case .message(_):
            break
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.size = CGSize(width: self.width * 0.85, height: self.height * 0.5)
        self.textView.top = 40
        self.textView.centerOnX()

        self.avatarView.size = CGSize(width: 24, height: 24)
        self.avatarView.bottom = self.height - 100
        self.avatarView.centerOnX()
    }
}
