//
//  NewChannelCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelCoordinator: PresentableCoordinator<Void> {

    lazy var newChannelVC = NewChannelFlowViewController(delegate: self)

    override func toPresentable() -> DismissableVC {
        return self.newChannelVC
    }

    func startLoginFlow() {
        let coordinator = LoginCoordinator(router: self.router, userExists: false)
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(animated: true, completion: nil)
        })
    }
}

extension NewChannelCoordinator: ChannelPurposeViewControllerDelegate {

    func channelPurposeView(_ controller: ChannelPurposeViewController, didCreate channel: ChannelType) {
        let coordinator = ChannelCoordinator(router: self.router, channelType: channel)
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(animated: true, completion: nil)
        })
    }
}
