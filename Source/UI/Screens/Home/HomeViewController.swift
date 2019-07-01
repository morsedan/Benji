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

enum HomeContentType: Int {
    case feed
    case list
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

    let headerContainer = View()
    let searchImageView = UIImageView(image: #imageLiteral(resourceName: "Search"))
    let addButton = HomeAddButton()

    var currentType: HomeContentType {
        return HomeContentType(rawValue: self.segmentControl.selectedSegmentIndex) ?? .feed
    }

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
        self.addChild(self.channelsVC)

        self.contentContainer.addSubview(self.headerContainer)

        self.headerContainer.addSubview(self.avatarView)
        self.headerContainer.addSubview(self.searchImageView)

        self.headerContainer.addSubview(self.segmentControl)
        self.segmentControl.addTarget(self, action: #selector(updateContent), for: .valueChanged)

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            let vc = ContactsScrolledModalController()
            self.present(vc, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentControl.setEnabled(true, forSegmentAt: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerContainer.size = CGSize(width: self.contentContainer.width, height: 40)
        self.headerContainer.top = Theme.contentOffset
        self.headerContainer.centerOnX()

        self.segmentControl.size = CGSize(width: 120, height: 40)
        self.segmentControl.centerOnXAndY()

        self.avatarView.size = CGSize(width: 30, height: 30)
        self.avatarView.left = 20
        self.avatarView.centerY = self.segmentControl.centerY

        self.searchImageView.size = CGSize(width: 22, height: 22)
        self.searchImageView.centerY = self.segmentControl.centerY
        self.searchImageView.right = self.headerContainer.width - 20

        self.addButton.size = CGSize(width: 48, height: 48)
        self.addButton.right = self.contentContainer.width - 25
        self.addButton.bottom = self.contentContainer.height - 25

        let feedHeight = (self.contentContainer.height * 0.8) - self.segmentControl.height - 30
        self.feedVC.view.size = CGSize(width: self.contentContainer.width * 0.85, height: feedHeight)
        self.feedVC.view.top = self.segmentControl.bottom + 30
        self.feedVC.view.left = self.contentContainer.width * 0.075

        self.channelsVC.view.size = self.contentContainer.size
        self.channelsVC.view.top = 0
        self.channelsVC.view.centerOnX()
    }

    @objc func updateContent() {
        guard let type = HomeContentType(rawValue: self.segmentControl.selectedSegmentIndex) else { return }

        var newView: UIView
        var currentView: UIView

        switch type {
        case .feed:
            newView = self.feedVC.view
            currentView = self.channelsVC.view
        case .list:
            newView = self.channelsVC.view
            currentView = self.feedVC.view
        }

        guard !self.contentContainer.contains(newView) else { return }

        UIView.animate(withDuration: Theme.animationDuration,
                       animations: {
                        currentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        currentView.alpha = 0
                        currentView.setNeedsLayout()
        }) { (completed) in
            if completed {
                currentView.removeFromSuperview()
                self.contentContainer.insertSubview(newView, belowSubview: self.headerContainer)
                self.contentContainer.layoutNow()
                newView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                newView.alpha = 0
                UIView.animate(withDuration: Theme.animationDuration,
                               animations: {
                                newView.transform = CGAffineTransform.identity
                                newView.alpha = 1
                })
            }
        }
    }
}


