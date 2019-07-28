//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import VerticalCardSwiper

class FeedCell: CardCell {

    let textView = FeedTextView()
    let avatarView = AvatarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.intialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.intialize()
    }

    private func intialize() {
        self.addSubview(self.textView)
        self.addSubview(self.avatarView)

        self.set(backgroundColor: .background3)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }

    func configure(with item: FeedType?) {
        guard let feedItem = item else { return }

        switch feedItem {
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
