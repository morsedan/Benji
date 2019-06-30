//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PureLayout

struct MeAvatar: Avatar {
    var initials: String {
        return "BD"
    }

    var photoUrl: URL?

    var photo: UIImage? {
        return UIImage(named: "Profile1")
    }
}

class HomeViewController: FullScreenViewController {

    lazy var channelsVC = ChannelsViewController()
    lazy var feedVC = FeedViewController()
    lazy var segmentControl = HomeSegmentControl(items: ["FEED", "LIST"])
    lazy var avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.set(avatar: MeAvatar())
        return avatarView
    }()

    let searchImageView = UIImageView(image: #imageLiteral(resourceName: "Search"))
    let addButton = HomeAddButton()

    override init() {
        super.init()
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    private func initializeViews() {

        self.addChild(viewController: self.feedVC, toView: self.contentContainer)
        self.addChild(viewController: self.channelsVC, toView: self.contentContainer)

        self.contentContainer.addSubview(self.avatarView)
        self.contentContainer.addSubview(self.searchImageView)

        self.contentContainer.addSubview(self.segmentControl)
        self.segmentControl.addTarget(self, action: #selector(updateContent), for: .valueChanged)

        self.contentContainer.addSubview(self.addButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentControl.setEnabled(true, forSegmentAt: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.avatarView.size = CGSize(width: 40, height: 40)
        self.avatarView.left = 20
        self.avatarView.top = 0

        self.segmentControl.size = CGSize(width: 120, height: 40)
        self.segmentControl.top = 0
        self.segmentControl.centerOnX()

        self.searchImageView.size = CGSize(width: 22, height: 22)
        self.searchImageView.centerY = self.segmentControl.centerY
        self.searchImageView.right = self.contentContainer.right - 20

        self.addButton.size = CGSize(width: 48, height: 48)
        self.addButton.right = self.contentContainer.width - 25
        self.addButton.bottom = self.contentContainer.height - 25

        self.feedVC.view.size = CGSize(width: self.contentContainer.width, height: self.contentContainer.height - self.segmentControl.height)
        self.feedVC.view.top = 0
        self.feedVC.view.left = 0

        self.channelsVC.view.size = self.contentContainer.size
        self.channelsVC.view.top = self.feedVC.view.top
        self.channelsVC.view.left = self.feedVC.view.right
    }

    @objc func updateContent() {
        let offset = self.segmentControl.selectedSegmentIndex == 0 ? 0 : self.contentContainer.right * -1

        guard self.feedVC.view.left != offset else { return }

        UIView.animate(withDuration: 0.25) {
            self.feedVC.view.left = offset
            self.channelsVC.view.left = self.feedVC.view.right
        }
    }
}


