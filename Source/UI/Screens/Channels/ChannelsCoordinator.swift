//
//  ChannelsCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsCoordinator: PresentableCoordinator<Void> {

    lazy var channelsVC = ChannelsViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.channelsVC
    }

    override func start() {
        self.channelsVC.didDismiss = { [unowned self] in
            self.finishFlow(with: ())
        }
    }
}

extension ChannelsCoordinator: ChannelsViewControllerDelegate {

    func channelsView(_ controller: ChannelsViewController, didSelect channelType: ChannelType) {
        self.startChannelFlow(for: channelType)
    }

    func startChannelFlow(for type: ChannelType) {

        let coordinator = ChannelCoordinator(router: self.router, channelType: type)
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(animated: true, completion: nil)
        })
    }
}
