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

    static let height: CGFloat = 120
    static let searchBarCollapsedHeight: CGFloat = 40

    lazy var avatarView: ProfileAvatarView = {
        let avatarView = ProfileAvatarView()
        if let current = User.current() {
            avatarView.set(avatar: current)
        }
        return avatarView
    }()

    private let label = Display1Label()
    private let dateLabel = HomeHeaderDateLabel()
    private(set) var searchBar = HomeSearchBar()
    private var searchBarOffset: CGFloat?
    private var searchBarHeight: CGFloat?

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.label)
        self.addSubview(self.avatarView)
        self.addSubview(self.dateLabel)
        self.addSubview(self.searchBar)

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

        self.avatarView.size = CGSize(width: 40, height: 40)
        self.avatarView.right = self.width - Theme.contentOffset
        self.avatarView.centerY = self.label.centerY

        let offset = self.searchBarOffset ?? HomeHeaderView.height - HomeHeaderView.searchBarCollapsedHeight
        let height = self.searchBarHeight ?? HomeHeaderView.searchBarCollapsedHeight
        self.searchBar.size = CGSize(width: self.width, height: height)
        self.searchBar.top = offset
        self.searchBar.centerOnX()
    }

    func updateContent(for type: HomeContentType) {

        let showScope = type == .channels
        let showCanel = type == .channels
        self.searchBarHeight = type == .channels ? HomeHeaderView.height : HomeHeaderView.searchBarCollapsedHeight
        self.searchBarOffset = type == .channels ? 0 : HomeHeaderView.height - self.searchBarHeight!
        let alpha: CGFloat = type == .channels ? 0 : 1.0

        self.searchBar.setShowsScope(showScope, animated: true)
        self.searchBar.setShowsCancelButton(showCanel, animated: true)

        UIView.animate(withDuration: Theme.animationDuration) {
            self.avatarView.alpha = alpha
            self.label.alpha = alpha
            self.dateLabel.alpha = alpha
            self.layoutNow()
        }
    }
}

