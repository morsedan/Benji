//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Contacts
import Parse
import ReactiveSwift

enum HomeContent: Equatable {
    case feed(FeedViewController)
    case channels(ChannelsViewController)
    case profile(ProfileViewController)
}

protocol HomeViewControllerDelegate: class {
    func homeViewDidTapAdd(_ controller: HomeViewController)
}

typealias HomeDelegate = HomeViewControllerDelegate

class HomeViewController: FullScreenViewController {

    unowned let delegate: HomeDelegate

    lazy var feedVC = FeedViewController()
    lazy var channelsVC = ChannelsViewController()
    lazy var profileVC = ProfileViewController(with: User.current()!)

    private let addButton = HomeAddButton()
    let centerContainer = View()
    let tabView = HomeTabView()

    lazy var currentContent = MutableProperty<HomeContent>(.feed(self.feedVC))
    private var currentCenterVC: UIViewController?

    init(with delegate: HomeDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.contentContainer.addSubview(self.centerContainer)

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            self.delegate.homeViewDidTapAdd(self)
        }

        self.contentContainer.addSubview(self.tabView)

        self.currentContent.producer
            .skipRepeats()
            .on { [unowned self] (contentType) in
                self.switchContent()
        }.start()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.right = self.view.width - Theme.contentOffset
        self.addButton.bottom = self.contentContainer.height - 10

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height - 40)
        self.centerContainer.top = 40
        self.centerContainer.centerOnX()

        self.tabView.size = CGSize(width: 200, height: 60)
        self.tabView.left = Theme.contentOffset
        self.tabView.bottom = self.addButton.bottom
        self.tabView.roundCorners()
    }

    private func switchContent() {

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.centerContainer.alpha = 0
        }) { (completed) in

            self.currentCenterVC?.removeFromParentSuperview()
            var newContentVC: UIViewController?

            switch self.currentContent.value {
            case .feed(let vc):
                newContentVC = vc
            case .channels(let vc):
                newContentVC = vc
            case .profile(let vc):
                newContentVC = vc
            }

            self.currentCenterVC = newContentVC

            if let contentVC = self.currentCenterVC {
                self.addChild(viewController: contentVC, toView: self.centerContainer)
            }

            self.view.setNeedsLayout()

            UIView.animate(withDuration: Theme.animationDuration) {
                self.centerContainer.alpha = 1
            }
        }
    }
}
