//
//  ChannelModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelModalViewController: ScrolledModalViewController<ChannelViewController> {

    let detailBar = ChannelDetailBar()

    init(with channelType: ChannelType) {
        super.init(presentable: ChannelViewController(channelType: channelType))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()
        
        self.presentable.delegate = self

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
    func channelView(_ controller: ChannelViewController, didLoad channelType: ChannelType) {

        switch channelType {
        case .system(let message):
            self.detailBar.set(avatar: message.avatar)
        case .channel(let channel):
            if let name = channel.friendlyName {
                self.detailBar.set(text: name)
            }
        }
    }
}
