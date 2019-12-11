//
//  HomeCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class HomeCoordinator: PresentableCoordinator<Void> {

    private lazy var homeVC = HomeViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.homeVC
    }

    override func start() {
        super.start()

        ToastScheduler.shared.delegate = self
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {

    func homeView(_ controller: HomeViewController, didSelect option: HomeOptionType) {
        switch option {
        case .profile:
            self.presentProfile()
        case .add:
            self.presentNewChannel()
        }
    }

    private func presentProfile() {
        guard let current = User.current() else { return }
        let coordinator = ProfileCoordinator(with: current, router: self.router, deepLink: self.deepLink)
        self.present(coordinator: coordinator)
    }

    private func presentNewChannel() {
        let coordinator = NewChannelCoordinator(router: self.router, deepLink: self.deepLink)
        self.addChildAndStart(coordinator) { (result) in
            self.router.dismiss(source: coordinator.toPresentable(), animated: true) {
                guard let channel = result else { return }
                self.startChannelFlow(for: channel)
            }
        }
        self.router.present(coordinator, source: self.homeVC, animated: true)
    }

    private func present(coordinator: PresentableCoordinator<Void>) {
        self.addChildAndStart(coordinator, finishedHandler: { _ in
            self.router.dismiss(source: coordinator.toPresentable())
        })
        self.router.present(coordinator, source: self.homeVC, animated: true)
    }
}

extension HomeCoordinator: ChannelsViewControllerDelegate {

    func channelsView(_ controller: ChannelsViewController, didSelect channelType: ChannelType) {
        self.startChannelFlow(for: channelType)
    }

    func startChannelFlow(for type: ChannelType) {

        let coordinator = ChannelCoordinator(router: self.router, channelType: type)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(source: coordinator.toPresentable(), animated: true) {
                self.finishFlow(with: ())
            }
        })
        self.router.present(coordinator, source: self.homeVC, animated: true)
    }
}

extension HomeCoordinator: FeedViewControllerDelegate {

    func feedView(_ controller: FeedViewController, didSelect item: FeedType) {

        let coordinator = FeedCoordinator(with: self.homeVC,
                                          item: item,
                                          router: self.router,
                                          deepLink: self.deepLink)

        self.addChildAndStart(coordinator) { (result) in
            self.finishFlow(with: ())
        }
    }
}

extension HomeCoordinator: ToastSchedulerDelegate {

    func didInteractWith(type: ToastType) {
        switch type {
        case .systemMessage(_):
            break
        case .message(_, let channel), .channel(let channel):
            self.startChannelFlow(for: .channel(channel))
        case .error(_):
            break
        case .success(_):
            break 
        }
    }
}
