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

enum HomeContentType: Int {
    case feed
    case list
}

class HomeViewController: FullScreenViewController {

    typealias HomeViewControllerDelegate = ChannelPurposeViewControllerDelegate
    unowned let delegate: HomeViewControllerDelegate

    //move
    lazy var newChannelFlowViewController: NewChannelFlowViewController = {
        let controller = NewChannelFlowViewController(delegate: self.delegate)
        return controller
    }()
    lazy var scrolledModal = ScrolledModalViewController(presentable: self.newChannelFlowViewController)

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

//        self.headerView.avatarView.onTap { [unowned self] (tap) in
//            let vc = ProfileViewController()
//            self.present(vc, animated: true, completion: {
//                vc.set(avatar: PFUser.current)
//            })
//        }

        self.contentContainer.addSubview(self.addButton)

        self.addButton.onTap { [unowned self] (tap) in
            self.presentNewChannel()
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

    func presentNewChannel() {
        self.present(self.scrolledModal, animated: true, completion: nil)
    }
}
