//
//  ChannelPurposeViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 9/8/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures
import TMROLocalization

protocol NewChannelViewControllerDelegate: class {
    func newChannelView(_ controller: NewChannelViewController,
                        didCreate channel: ChannelType)
}

class NewChannelViewController: NavigationBarViewController {

    lazy var purposeVC = PurposeViewController()

    unowned let delegate: NewChannelViewControllerDelegate

    init(delegate: NewChannelViewControllerDelegate) {
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

        self.view.set(backgroundColor: .background2)
        self.addChild(viewController: self.purposeVC)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.purposeVC.view.size = CGSize(width: self.view.width, height: 400)
        self.purposeVC.view.centerOnX()
        self.purposeVC.view.bottom = self.view.height - self.view.safeAreaInsets.bottom

        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.purposeVC.view.bottom + 20)
    }

    override func getTitle() -> Localized {
        return "DAILY ROUTINE"
    }

    override func getDescription() -> Localized {
        return "Get a daily reminder to follow up and connect with others."
    }
}

