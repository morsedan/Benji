//
//  ProfileViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TwilioChatClient

struct ProfileItem: ProfileDisplayable {
    var avatar: Avatar? = nil
    var title: String
    var text: String
    var hasDetail: Bool = false
}

class ProfileViewController: FullScreenViewController {

    private let user: PFUser

    lazy var collectionView = ProfileCollectionView()
    lazy var manager = ProfileCollectionViewManager(with: self.collectionView)

    init(with user: PFUser) {
        self.user = user
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.collectionView
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.collectionView.delegate = self.manager
        self.collectionView.dataSource = self.manager

        self.createItems()
    }

    private func createItems() {

        var items: [ProfileDisplayable] = []

        let avatarItem = ProfileItem(avatar: self.user,
                                     title: String(),
                                     text: String(),
                                     hasDetail: false)
        items.append(avatarItem)

        let handleItem = ProfileItem(avatar: nil,
                                     title: "@handle",
                                     text: self.user.handle,
                                     hasDetail: false)
        items.append(handleItem)

        let routineItem = ProfileItem(avatar: nil,
                                      title: "Routine",
                                      text: "7:00 PM",
                                      hasDetail: true)
        items.append(routineItem)

        self.manager.items = items
        self.collectionView.reloadData()
    }
}
