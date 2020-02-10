//
//  InviteableContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/8/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class InviteableContentView: View {

    private let avatarView = AvatarView()
    private let nameLabel = RegularLabel()
    private(set) var button = Button()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.avatarView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.button)
    }

    func configure(with inviteable: Inviteable) {

        self.nameLabel.set(text: inviteable.fullName, stringCasing: .capitalized)
        self.avatarView.set(avatar: inviteable)

        self.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 44, height: 60)
        self.avatarView.left = Theme.contentOffset
        self.avatarView.centerOnY()

        let nameWidth = self.width - self.avatarView.right - (Theme.contentOffset * 2)
        self.nameLabel.size = CGSize(width: nameWidth, height: 40)
        self.nameLabel.centerY = self.avatarView.centerY
        self.nameLabel.left = self.avatarView.right + Theme.contentOffset

        self.button.size = CGSize(width: 80, height: 40)
        self.button.centerOnY()
        self.button.right = self.right - Theme.contentOffset
    }
}
