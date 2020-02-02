//
//  NewChannelCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelCoordinator: PresentableCoordinator<ChannelType?> {

    lazy var newChannelVC = NewChannelViewController(delegate: self)

    override func toPresentable() -> DismissableVC {
        return self.newChannelVC
    }
}

extension NewChannelCoordinator: NewChannelViewControllerDelegate {

    func newChannelView(_ controller: NewChannelViewController, didCreate channel: ChannelType) {
        self.finishFlow(with: channel)
    }
}
