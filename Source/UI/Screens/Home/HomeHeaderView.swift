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

    private(set) var searchBar = UISearchBar()

    override func initializeSubviews() {
        super.initializeSubviews()

        self.searchBar.keyboardType = .twitter
        self.searchBar.barStyle = .black

        self.addSubview(self.avatarView)
        self.addSubview(self.searchBar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 40, height: 40)
        self.avatarView.left = 20
        self.avatarView.centerOnY()

        self.searchBar.size = CGSize(width: self.width - 120, height: 40)
        self.searchBar.left = self.avatarView.right + 20
    }
}
