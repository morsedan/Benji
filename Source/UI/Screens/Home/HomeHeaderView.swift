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

    let label = Display1Label()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.avatarView)
        self.addSubview(self.label)

        self.label.set(text: "Feed")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 40, height: 40)
        self.avatarView.right = self.width
        self.avatarView.centerOnY()

        self.label.setSize(withWidth: 200)
        self.label.left = 0
    }
}
