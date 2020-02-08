//
//  FeedCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 12/7/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import TMROLocalization

class FeedCoordinator: Coordinator<Void> {

    private let feedVC: FeedViewController

    init(router: Router,
         deepLink: DeepLinkable?,
         feedVC: FeedViewController) {

        self.feedVC = feedVC

        super.init(router: router, deepLink: deepLink)
    }

    override func start() {
        self.feedVC.delegate = self
    }
}

extension FeedCoordinator: FeedViewControllerDelegate {

    func feedView(_ controller: FeedViewController, didSelect item: FeedType) {
        self.handle(item: item)
    }

    private func handle(item: FeedType) {

        switch item {
        case .intro, .system(_):
            break
        case .rountine:
            self.startRoutineFlow()
        case .unreadMessages(let channel, _):
            self.startChannelFlow(for: .channel(channel))
        case .channelInvite(let channel):
            self.startChannelFlow(for: .channel(channel))
        case .inviteAsk:
            self.startContactSelectionFlow()
        case .notificationPermissions:
            break
        case .connecitonRequest(_):
            break 
        }
    }

    private func startContactSelectionFlow() {
        let coordinator = InvitesCoordinator(router: self.router, deepLink: self.deepLink)
        self.addChildAndStart(coordinator) { (_) in
            self.router.dismiss(source: coordinator.toPresentable())
        }
        self.router.present(coordinator, source: self.feedVC)
    }

    private func startRoutineFlow() {
        let vc = RoutineViewController()
        self.router.present(vc, source: self.feedVC)
    }

    private func startChannelFlow(for type: ChannelType) {
        let coordinator = ChannelCoordinator(router: self.router, channelType: type)
        self.addChildAndStart(coordinator) { (_) in
            self.router.dismiss(source: coordinator.toPresentable())
        }
        self.router.present(coordinator, source: self.feedVC)
    }
}
