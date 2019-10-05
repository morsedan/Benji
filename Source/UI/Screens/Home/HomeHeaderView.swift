//
//  HomeHeaderView.swift
//  Benji
//
//  Created by Benji Dodgson on 9/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class HomeHeaderView: View {

    lazy var avatarView: ProfileAvatarView = {
        let avatarView = ProfileAvatarView()
        if let current = PFUser.current() {
            avatarView.set(avatar: current)
        }
        return avatarView
    }()

    private let label = Display1Label()
    private let dateLabel = HomeHeaderDateLabel()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.label)
        self.addSubview(self.avatarView)
        self.addSubview(self.dateLabel)

        self.label.set(text: "Feed")
        self.dateLabel.set(date: Date.today)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.dateLabel.setSize(withWidth: self.width * 0.8)
        self.dateLabel.left = Theme.contentOffset
        self.dateLabel.bottom = self.height

        self.label.setSize(withWidth: self.width * 0.8)
        self.label.left = Theme.contentOffset
        self.label.bottom = self.dateLabel.top - 5

        self.avatarView.size = CGSize(width: 60, height: 60)
        self.avatarView.right = self.width - Theme.contentOffset
        self.avatarView.bottom = self.height
    }
}
