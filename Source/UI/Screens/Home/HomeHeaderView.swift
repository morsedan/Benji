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
    private let homeSearchBar = HomeSearchBar()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.label)
        self.addSubview(self.avatarView)
        self.addSubview(self.dateLabel)
        self.addSubview(self.homeSearchBar)

        self.label.set(text: "Feed")
        self.dateLabel.set(date: Date.today)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width * 0.8)
        self.label.left = Theme.contentOffset
        self.label.top = 0

        self.dateLabel.setSize(withWidth: self.width * 0.8)
        self.dateLabel.left = Theme.contentOffset
        self.dateLabel.top = self.label.bottom + 5

        self.avatarView.size = CGSize(width: 58, height: 58)
        self.avatarView.right = self.width - Theme.contentOffset
        self.avatarView.bottom = self.dateLabel.bottom

        self.homeSearchBar.size = CGSize(width: self.width, height: 40)
        self.homeSearchBar.bottom = self.height
        self.homeSearchBar.centerOnX()
    }
}
