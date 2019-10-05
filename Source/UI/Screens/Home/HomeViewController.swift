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

enum HomeOptionType {
    case profile
    case search
    case add
}

protocol HomeViewControllerDelegate: class {
    func homeView(_ controller: HomeViewController, didSelect option: HomeOptionType)
}


class HomeViewController: FullScreenViewController {

    unowned let delegate: HomeViewControllerDelegate

    private let centerContainer = View()
    private let addButton = HomeAddButton()

    lazy var feedVC = FeedViewController()
    let headerView = HomeHeaderView()

    init(with delegate: HomeViewControllerDelegate) {
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

        self.contentContainer.addSubview(self.centerContainer)
        self.addChild(viewController: self.feedVC, toView: self.centerContainer)

        self.headerView.avatarView.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .profile)
        }

        self.contentContainer.addSubview(self.addButton)
        self.addButton.onTap { [unowned self] (tap) in
            self.delegate.homeView(self, didSelect: .add)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.headerView.frame = CGRect(x: 0,
                                       y: self.view.safeAreaInsets.top,
                                       width: self.view.width,
                                       height: 44)

        self.centerContainer.size = CGSize(width: self.contentContainer.width,
                                           height: self.contentContainer.height)
        self.centerContainer.top = self.headerView.bottom
        self.centerContainer.centerOnX()

        self.addButton.size = CGSize(width: 60, height: 60)
        self.addButton.centerOnX()
        self.addButton.bottom = self.contentContainer.height - 10

        self.feedVC.view.frame = self.centerContainer.bounds
    }
}
