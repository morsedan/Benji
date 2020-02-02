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
    lazy var searchBar = SearchBar()

    private let addButton = HomeNewChannellButton()
    let centerContainer = View()
    let tabView = HomeTabView()
    let gradientView = GradientView()
    let tabContainerView = View()

    lazy var currentContent = MutableProperty<HomeContent>(.feed(self.feedVC))
    private(set) var currentCenterVC: UIViewController?

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

        self.searchBar.isHidden = true
        self.searchBar.delegate = self.channelsVC
        self.contentContainer.addSubview(self.searchBar)

        self.view.set(backgroundColor: .background1)
        self.addButton.imageView.image = UIImage(systemName: "square.and.pencil")
        self.addButton.set(backgroundColor: .purple)

        self.contentContainer.addSubview(self.centerContainer)
        self.contentContainer.addSubview(self.gradientView)

        self.addButton.didSelect = { [unowned self] in
            self.delegate.homeViewDidTapAdd(self)
        }

        self.contentContainer.addSubview(self.tabContainerView)
        self.tabContainerView.set(backgroundColor: .background1)
        self.tabContainerView.addSubview(self.tabView)
        self.tabContainerView.addSubview(self.addButton)

        self.currentContent.producer
            .skipRepeats()
            .on { [unowned self] (contentType) in
                self.switchContent()
                self.tabView.updateTabItems(for: contentType)
        }.start()

        self.tabView.profileItem.didSelect = { [unowned self] in
            self.currentContent.value = .profile(self.profileVC)
        }

        self.tabView.feedItem.didSelect = { [unowned self] in
            self.currentContent.value = .feed(self.feedVC)
        }

        self.tabView.channelsItem.didSelect = { [unowned self] in
            self.currentContent.value = .channels(self.channelsVC)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.searchBar.size = CGSize(width: self.contentContainer.width - 12, height: 36)
        self.searchBar.centerOnX()
        self.searchBar.top = 50

        let height = 70 + self.view.safeAreaInsets.bottom
        self.tabContainerView.size = CGSize(width: self.contentContainer.width, height: height)
        self.tabContainerView.centerOnX()
        self.tabContainerView.bottom = self.contentContainer.height + self.view.safeAreaInsets.bottom

        self.gradientView.size = CGSize(width: self.view.width, height: 40)
        self.gradientView.centerOnX()
        self.gradientView.bottom = self.tabContainerView.top

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.right = self.tabContainerView.width - 16
        self.addButton.top = 0

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height - 156)
        self.centerContainer.bottom = self.tabContainerView.top
        self.centerContainer.centerOnX()

        self.currentCenterVC?.view.frame = self.centerContainer.bounds

        self.tabView.size = CGSize(width: 200, height: 60)
        self.tabView.left = Theme.contentOffset
        self.tabView.top = 0
    }

    private func switchContent() {

        UIView.animate(withDuration: Theme.animationDuration, animations: {
            self.centerContainer.alpha = 0
            self.centerContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in

            self.currentCenterVC?.removeFromParentSuperview()
            var newContentVC: UIViewController?

            switch self.currentContent.value {
            case .feed(let vc):
                newContentVC = vc
                self.searchBar.isHidden = true
            case .channels(let vc):
                newContentVC = vc
                self.searchBar.isHidden = false
            case .profile(let vc):
                newContentVC = vc
                self.searchBar.isHidden = true
            }

            self.currentCenterVC = newContentVC

            if let contentVC = self.currentCenterVC {
                self.addChild(viewController: contentVC, toView: self.centerContainer)
            }

            self.view.setNeedsLayout()

            UIView.animate(withDuration: Theme.animationDuration) {
                self.centerContainer.alpha = 1
                self.centerContainer.transform = .identity
            }
        }
    }
}
