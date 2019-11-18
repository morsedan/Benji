//
//  FeedCell.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedView: View {

    let textView = FeedTextView()
    let avatarView = AvatarView()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.textView)
        self.addSubview(self.avatarView)

        self.set(backgroundColor: .background2)
        self.roundCorners()
        self.addShadow(withOffset: 20)
    }

    func configure(with item: FeedType?) {
        guard let feedItem = item else { return }

        switch feedItem {
        case .intro:
            self.textView.set(localizedText: "This is an intro card.")
        case .system(let systemMessage):
            self.textView.set(localizedText: systemMessage.text)
            //self.avatarView.set(avatar: systemMessage.avatar)
        case .message(_):
            break
        case .channelInvite(_):
            self.textView.set(localizedText: "You have a new channel to join")
            self.avatarView.set(avatar: Lorem.avatar())
        case .inviteAsk:
            self.textView.set(localizedText: "You should invite someone")
            self.avatarView.set(avatar: Lorem.avatar())
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textView.size = CGSize(width: self.proportionalWidth, height: self.height * 0.5)
        self.textView.top = 40
        self.textView.centerOnX()

        self.avatarView.size = CGSize(width: 24, height: 24)
        self.avatarView.bottom = self.height - 100
        self.avatarView.centerOnX()
    }
}
