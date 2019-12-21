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
            self.join(channel: channel)
        case .inviteAsk:
            break
            //let contactsVC = ContactsViewController()
            //self.router.present(contactsVC, source: self.sourceViewController)
        }
    }

    private func startRoutineFlow() {
        guard let current = User.current() else { return }

        //        let routineLink = DeepLinkObject.init(target: .routine)
        //        let coordinator = ProfileCoordinator(with: current,
        //                                             router: self.router,
        //                                             deepLink: routineLink)
        //
        //        self.addChildAndStart(coordinator, finishedHandler: { (_) in
        //            self.router.dismiss(source: coordinator.toPresentable())
        //        })
        //        self.router.present(coordinator, source: self.sourceViewController, animated: true)
    }

    private func join(channel: TCHChannel) {

        let text = LocalizedString(id: "join.channel",
                                   arguments: [channel.friendlyName!],
                                   default: "You have joined @1")
        channel.joinIfNeeded()
            .withResultToast(with: text)
            .observe { (result) in
                switch result {
                case .success(let joinedChannel):
                    self.startChannelFlow(for: .channel(joinedChannel))
                case .failure(let error):
                    print(error)
                }
        }
    }

    private func startChannelFlow(for type: ChannelType) {

        //        let coordinator = ChannelCoordinator(router: self.router, channelType: type)
        //        self.addChildAndStart(coordinator, finishedHandler: { (_) in
        //            self.router.dismiss(source: coordinator.toPresentable())
        //        })
        //        self.router.present(coordinator, source: self.sourceViewController, animated: true)
    }
}
