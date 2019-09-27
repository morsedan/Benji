//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCellContentView: View {

    private let titleLabel = RegularBoldLabel()
    private let stackedAvatarView = StackedAvatarView()

    override func initialize() {

        self.addSubview(self.stackedAvatarView)
        self.addSubview(self.titleLabel)
        self.roundCorners()
        self.set(backgroundColor: .background2)
    }

    func configure(with type: ChannelType) {

        switch type {
        case .system(let message):
            self.stackedAvatarView.set(items: [message.avatar])
            self.titleLabel.set(text: message.context.text)
        case .channel(let channel):

            if let name = channel.friendlyName {
                self.titleLabel.set(text: name)
            }

            channel.getMembersAsUsers().observe { (result) in
                switch result {
                case .success(let users):
                    self.stackedAvatarView.set(items: users)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.stackedAvatarView.height = 40
        self.stackedAvatarView.right = self.width - 16
        self.stackedAvatarView.centerOnY()

        self.titleLabel.setSize(withWidth: 200)
        self.titleLabel.left = Theme.contentOffset
        self.titleLabel.centerOnY()
    }
}
