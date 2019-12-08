//
//  FeedCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 12/7/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FeedCoordinator: Coordinator<Void> {

    private let sourceViewController: UIViewController
    private let feedItem: FeedType

    init(with source: UIViewController,
         item: FeedType,
         router: Router,
         deepLink: DeepLinkable?) {

        self.sourceViewController = source
        self.feedItem = item

        super.init(router: router, deepLink: deepLink)
    }

    override func start() {
        self.handle(item: self.feedItem)
    }

    private func handle(item: FeedType) {

        switch item {
        case .intro:
            break
        case .rountine:
            break
        case .system(_):
            break
        case .unreadMessages(let channel, _):
            self.startChannelFlow(for: .channel(channel))
        case .channelInvite(_):
            break
        case .inviteAsk:
            let contactsVC = ContactsViewController()
            self.router.present(contactsVC, source: self.sourceViewController)
        }
    }

    func startChannelFlow(for type: ChannelType) {

        let coordinator = ChannelCoordinator(router: self.router, channelType: type)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(source: coordinator.toPresentable())
        })
        self.router.present(coordinator, source: self.sourceViewController, animated: true)
    }
}
