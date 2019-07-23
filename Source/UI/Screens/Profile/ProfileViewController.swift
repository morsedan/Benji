//
//  ProfileViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ProfileViewController: FullScreenViewController {

    let avatarView = AvatarView()
    let closeButton = CloseButton()
    let displayLabel = Display2Label()
    let handleLabel = RegularSemiBoldLabel()

    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.avatarView)
        self.contentContainer.addSubview(self.closeButton)
        self.contentContainer.addSubview(self.displayLabel)
        self.contentContainer.addSubview(self.handleLabel)

        self.closeButton.onTap { [unowned self] (tap) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.closeButton.left = 18
        self.closeButton.top = self.view.safeAreaInsets.top

        self.avatarView.size = CGSize(width: 54, height: 54)
        self.avatarView.top = self.closeButton.bottom + 15
        self.avatarView.left = self.closeButton.left

        self.displayLabel.setSize(withWidth: self.contentContainer.width * 0.7)
        self.displayLabel.top = self.avatarView.top
        self.displayLabel.left = self.avatarView.right + 15

        self.handleLabel.setSize(withWidth: self.contentContainer.width * 0.7)
        self.handleLabel.bottom = self.avatarView.bottom
        self.handleLabel.left = self.displayLabel.left
    }

    func set(avatar: Avatar) {
        self.avatarView.set(avatar: avatar)
        self.displayLabel.set(text: avatar.firstName)
        self.handleLabel.set(text: avatar.handle, color: .lightPurple)
        self.view.layoutNow()
    }
}
