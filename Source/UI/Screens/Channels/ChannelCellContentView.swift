//
//  ChannelCellContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 6/29/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCellContentView: View {

    private let headerView = View()
    private let contextLabel = Label()
    private let messageLabel = Label()
    private let avatarView = AvatarView()

    var contextText: Localized? {
        didSet {
            guard let text = self.contextText else { return }
            let attributed = AttributedString(text,
                                              color: .white)
            self.contextLabel.set(attributed: attributed)
        }
    }

    var messageText: Localized? {
        didSet {
            guard let text = self.messageText else { return }
            let attributed = AttributedString(text,
                                              color: .white)
            self.messageLabel.set(attributed: attributed)
        }
    }

    override func initializeViews() {
        super.initializeViews()

        self.addSubview(self.headerView)
        self.headerView.set(backgroundColor: .background2)
        self.addSubview(self.avatarView)
        self.headerView.addSubview(self.contextLabel)
        self.addSubview(self.messageLabel)
        self.roundCorners()
        self.set(backgroundColor: .background3)
    }

    func configure(with type: ChannelsType) {

        switch type {
        case .system(let message):
            self.avatarView.set(avatar: message.avatar)
            self.contextText = message.context.text
            self.messageText = message.body
            //self.localizedText = message.body
            break
        case .channel(let channel):
            //self.localizedText = channel.friendlyName
            break
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.headerView.size = CGSize(width: self.width, height: 60)
        self.headerView.centerOnX()
        self.headerView.top = 0

        self.contextLabel.size = CGSize(width: self.width - 40, height: self.headerView.height)
        self.contextLabel.left = 12
        self.contextLabel.centerOnY()

        self.avatarView.size = CGSize(width: 56, height: 56)
        self.avatarView.top = self.headerView.bottom + 16
        self.avatarView.left = 16

        if let attributedText = self.messageLabel.attributedText {
            let maxWidth = self.width - self.avatarView.right - 40
            self.messageLabel.size = attributedText.getSize(withWidth: maxWidth)
            self.messageLabel.top = self.avatarView.top
            self.messageLabel.left = self.avatarView.right + 16
        }
    }
}
