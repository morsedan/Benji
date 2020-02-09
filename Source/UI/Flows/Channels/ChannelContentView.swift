//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelContentView: View {

    private(set) var titleLabel = RegularBoldLabel()
    private let purposeLabel = SmallLabel()
    private let stackedAvatarView = StackedAvatarView()

    override func initializeSubviews() {
        super.initializeSubviews()
        
        self.addSubview(self.stackedAvatarView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.purposeLabel)
        self.set(backgroundColor: .clear)
    }

    func configure(with type: ChannelType) {

        switch type {
        case .system(let channel):
            self.stackedAvatarView.set(items: channel.avatars)
        case .channel(let channel):
            channel.getMembersAsUsers()
                .observeValue(with: { (users) in
                    let notMeUsers = users.filter { (user) -> Bool in
                        return user.objectId != User.current()?.objectId
                    }

                    self.stackedAvatarView.set(items: notMeUsers)
                })
        }

        self.titleLabel.set(text: type.displayName)
        self.purposeLabel.set(text: type.purpose, color: .background4)
        self.layoutNow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.stackedAvatarView.setSize()
        self.stackedAvatarView.left = Theme.contentOffset
        self.stackedAvatarView.centerOnY()

        self.titleLabel.setSize(withWidth: self.width * 0.7)
        self.titleLabel.left = self.stackedAvatarView.right + 10
        self.titleLabel.top = self.stackedAvatarView.top

        self.purposeLabel.setSize(withWidth: self.width * 0.7)
        self.purposeLabel.left = self.titleLabel.left
        self.purposeLabel.top = self.titleLabel.bottom + 4
    }

    func reset() {
        self.titleLabel.text = nil
        self.purposeLabel.text = nil
        self.stackedAvatarView.set(items: [])
    }
}
