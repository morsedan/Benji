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
    private(set) var searchBar = HomeSearchBar()
    private(set) var searchButton = SearchButton()
    private var searchButtonOffset: CGFloat?

    override func initializeSubviews() {
        super.initializeSubviews()

        self.addSubview(self.label)
        self.addSubview(self.avatarView)
        self.addSubview(self.searchButton)

        self.label.set(text: "Feed")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarView.size = CGSize(width: 44, height: 44)
        self.avatarView.left = Theme.contentOffset
        self.avatarView.top = 0

        self.label.setSize(withWidth: self.width * 0.8)
        self.label.left = self.avatarView.right + Theme.contentOffset
        self.label.top = self.avatarView.top

        self.searchButton.size = CGSize(width: 36, height: 36)
        let offset = self.searchButtonOffset ?? self.width - Theme.contentOffset - 36
        self.searchButton.left = offset
        self.searchButton.centerY = self.avatarView.centerY
    }

    func updateContent(for type: HomeContent) {

//        let showScope = type == .channels
//        let showCanel = type == .channels
//
//        let alpha: CGFloat = type == .channels ? 0 : 1.0
//
//        self.searchButtonOffset = type == .channels ? Theme.contentOffset : self.width - Theme.contentOffset - self.searchButton.width
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.avatarView.alpha = alpha
//            self.label.alpha = alpha
//            self.layoutNow()
//        }) { (completed) in
//            self.addSubview(self.searchBar)
//            self.searchButton.frame = CGRect(x: Theme.contentOffset,
//                                             y: 0,
//                                             width: self.width - (Theme.contentOffset * 2),
//                                             height: 120)
//            self.searchBar.alpha = 0
//            UIView.animate(withDuration: 0.2, animations: {
//                self.searchBar.alpha = 1
//                self.searchButton.alpha = 0 
//            }) { (completed) in
//                self.searchBar.becomeFirstResponder()
//            }
//            self.searchBar.setShowsScope(showScope, animated: true)
//            self.searchBar.setShowsCancelButton(showCanel, animated: true)
//        }
    }
}

