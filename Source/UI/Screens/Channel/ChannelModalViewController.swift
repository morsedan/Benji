//
//  ChannelModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelModalViewController: ScrolledModalViewController {

    let detailBar = ChannelDetailBar()

    init(with channelType: ChannelType) {
        let channelVC = ChannelViewController(channelType: channelType)
        super.init(presentable: channelVC)
        channelVC.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.tapDismissView.set(backgroundColor: .background1)
        self.view.addSubview(self.detailBar)

        self.detailBar.closeButton.onTap { [unowned self] (tap) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.detailBar.size = CGSize(width: self.view.width, height: 60)
        self.detailBar.bottom = self.modalContainerView.top 
        self.detailBar.centerOnX()
    }
}

extension ChannelModalViewController: ChannelViewControllerDelegate {
    func channelView(_ controller: ChannelViewController, didUpdate avatar: Avatar) {
        self.detailBar.set(avatar: avatar)
    }

    func channelView(_ controller: ChannelViewController, didUpdate title: Localized) {
        self.detailBar.set(text: title)
    }
}
