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

class ProfileViewController: FullScreenViewController {

    private let avatarView = AvatarView()
    private let displayLabel = RegularSemiBoldLabel()
    private let handleLabel = SmallSemiBoldLabel()
    private let routineInputVC = RoutineInputViewController()
    private let user: PFUser

    init(with user: PFUser) {
        self.user = user
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.avatarView)
        self.contentContainer.addSubview(self.displayLabel)
        self.contentContainer.addSubview(self.handleLabel)

        //self.addChild(viewController: self.routineInputVC, toView: self.contentContainer)

        self.set(avatar: self.user)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let avatarWidth = self.view.width
        self.avatarView.size = CGSize(width: avatarWidth, height: avatarWidth)
        self.avatarView.top = 0
        self.avatarView.centerOnX()

        self.handleLabel.setSize(withWidth: self.contentContainer.width * 0.7)
        self.handleLabel.bottom = self.avatarView.bottom - 10
        self.handleLabel.left = Theme.contentOffset

        self.displayLabel.setSize(withWidth: self.contentContainer.width * 0.7)
        self.displayLabel.bottom = self.handleLabel.top - 10
        self.displayLabel.left = Theme.contentOffset

//        self.routineInputVC.view.frame = CGRect(x: 0,
//                                                y: self.avatarView.bottom + 20,
//                                                width: self.view.width,
//                                                height: self.view.height - self.avatarView.bottom + 20)
    }

    private func set(avatar: Avatar) {

        self.avatarView.setBorder(color: .clear)
        self.avatarView.showLargeImage = true 
        self.avatarView.set(avatar: avatar)
        self.displayLabel.set(text: avatar.fullName)
        self.handleLabel.set(text: avatar.handle, color: .lightPurple)
        self.view.setNeedsLayout()
    }
}
