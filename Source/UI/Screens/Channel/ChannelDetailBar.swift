//
//  ChannelDetailBar.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelDetailBar: View {

    let closeButton = CloseButton()
    let titleLabel = Display1Label()
    let avatarView = AvatarView()

    override func initialize() {
        super.initialize()

        self.addSubview(self.closeButton)
        self.addSubview(self.titleLabel)
        self.addSubview(self.avatarView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.closeButton.size = CGSize(width: 25, height: 25)
        self.closeButton.left = 18
        self.closeButton.centerOnY()

        self.titleLabel.setSize(withWidth: self.width * 0.7)
        self.titleLabel.left = self.closeButton.right + 25
        self.titleLabel.centerOnY()

        self.avatarView.size = CGSize(width: 32, height: 32)
        self.avatarView.right = self.width - 18
        self.avatarView.centerOnY()
    }

    func set(avatar: Avatar) {
        self.avatarView.set(avatar: avatar)
        self.titleLabel.set(text: avatar.firstName)
        self.layoutNow()
    }
}
