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

    let createButton = NewChannelButton()

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

    override func loadView() {
        self.view = UIView()
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.scrollView)

        self.view.set(backgroundColor: .background2)
        self.addChild(viewController: self.purposeVC)

        self.view.addSubview(self.createButton)
        self.createButton.onTap { [unowned self] (tap) in
            self.createTapped()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.scrollView.expandToSuperviewSize()

        self.createButton.size = CGSize(width: 60, height: 60)
        self.createButton.right = self.view.width - 16
        self.createButton.bottom = self.view.height - self.view.safeAreaInsets.bottom - 10

        self.purposeVC.view.size = CGSize(width: self.view.width, height: 500)
        self.purposeVC.view.centerOnX()
        self.purposeVC.view.top = self.lineView.bottom + 30

        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.purposeVC.view.bottom + 20)
    }

    override func getTitle() -> Localized {
        return "NEW CONVERSATION"
    }

    override func getDescription() -> Localized {
        return "Add a name and description to help frame the conversation."
    }

    func createTapped() {
        
    }
}

