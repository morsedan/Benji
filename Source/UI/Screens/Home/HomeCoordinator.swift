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

    lazy var homeVC = HomeViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.homeVC
    }

    override func start() {
        super.start()

//        if PFAnonymousUtils.isLinked(with: PFUser.current()) {
//            delay(1.0) {
//                self.startLoginFlow()
//            }
//        }
    }

    func startLoginFlow() {
        let coordinator = LoginCoordinator(router: self.router, userExists: false)
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(animated: true, completion: nil)
        })
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
        let coordinator = ProfileCoordinator(router: self.router, deepLink: self.deepLink)
        self.present(coordinator: coordinator)
    }

    private func presentNewChannel() {
        let coordinator = NewChannelCoordinator(router: self.router, deepLink: self.deepLink)
        self.present(coordinator: coordinator)
    }

    private func present(coordinator: PresentableCoordinator<Void>) {
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(animated: true, completion: nil)
        })
    }
}

extension HomeCoordinator: ChannelsViewControllerDelegate {

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
