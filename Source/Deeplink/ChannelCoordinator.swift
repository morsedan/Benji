//
//  ChannelCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 8/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCoordinator: PresentableCoordinator<Void> {

    let channelType: ChannelType

    lazy var channelController: ChannelViewController = {
        let controller = ChannelViewController(channelType: self.channelType)
        return controller
    }()

    lazy var scrolledModal = ScrolledModalViewController(presentable: self.channelController)

    init(router: Router, channelType: ChannelType) {
        self.channelType = channelType
        super.init(router: router, deepLink: nil)
    }

    override func toPresentable() -> UIViewController {
        return self.scrolledModal
    }

    override func start() {
        self.scrolledModal.didDismiss = { [unowned self] in
            self.finishFlow(with: ())
        }
    }
}
