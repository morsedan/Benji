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
    private let titleLabel = RegularBoldLabel()
    private let messageLabel = RegularSemiBoldLabel()
    private let avatarView = AvatarView()

    override func initialize() {

        self.addSubview(self.headerView)
        self.headerView.set(backgroundColor: .background2)
        self.headerView.addSubview(self.avatarView)
        self.headerView.addSubview(self.titleLabel)
        self.addSubview(self.messageLabel)
        self.roundCorners()
        self.set(backgroundColor: .background2)
    }

    func configure(with type: ChannelType) {

        switch type {
        case .system(let message):
            self.avatarView.set(avatar: message.avatar)
            self.titleLabel.set(text: message.context.text)
            self.messageLabel.set(text: message.body)
        case .channel(let channel):
            
            guard let channelMessages = channel.messages else { return }
            channelMessages.getLastWithCount(1, completion: { (result, messages) in
                guard let msgs = messages, let last = msgs.last, let body = last.body else { return }

                self.messageLabel.set(text: body)
                self.layoutNow()
            })

            if let name = channel.friendlyName {
                self.titleLabel.set(text: name)
            }

            channel.getAuthorAsUser().observe(with: { (result) in
                switch result {
                case .success(let user):
                    self.avatarView.set(avatar: user)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.headerView.size = CGSize(width: self.width, height: 60)
        self.headerView.centerOnX()
        self.headerView.top = 0

        self.avatarView.size = CGSize(width: 30, height: 30)
        self.avatarView.left = 16
        self.avatarView.centerOnY()

        self.titleLabel.size = CGSize(width: 200, height: self.headerView.height)
        self.titleLabel.left = self.avatarView.right + Theme.contentOffset
        self.titleLabel.centerOnY()
        
        if let attributedText = self.messageLabel.attributedText {
            let maxWidth = self.width - self.avatarView.right - 40
            self.messageLabel.size = attributedText.getSize(withWidth: maxWidth)
            self.messageLabel.left = 16
            self.messageLabel.top = self.headerView.bottom + 10
        }
    }
}
