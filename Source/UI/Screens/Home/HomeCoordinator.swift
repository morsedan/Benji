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

        self.router.navController.setNavigationBarHidden(false, animated: false)
        self.router.navController.navigationBar.prefersLargeTitles = true

        let attributed = AttributedString("", fontType: .display, color: .white)
        self.router.navController.navigationBar.largeTitleTextAttributes = attributed.attributes

        self.homeVC.currentContent.producer.on { [unowned self] (contentType) in
            self.removeChild()

            // Only use the deeplink once so that we don't repeatedly try
            // to deeplink whenever content changes.
            defer {
                self.deepLink = nil
            }

            switch contentType {
            case .feed(let vc):
                let coordinator = FeedCoordinator(router: self.router,
                                                  deepLink: self.deepLink,
                                                  feedVC: vc)
                self.addChildAndStart(coordinator) { (_) in }
            case .channels(let vc):
                let coordinator = ChannelsCoordinator(router: self.router,
                                                      deepLink: self.deepLink,
                                                      channelsVC: vc)
                self.addChildAndStart(coordinator) { (_) in }
            case .profile(let vc):
                let coordinator = ProfileCoordinator(router: self.router,
                                                     deepLink: self.deepLink,
                                                     profileVC: vc)
                self.addChildAndStart(coordinator) { (_) in }
            }
        }.start()
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {

    func homeViewDidTapAdd(_ controller: HomeViewController) {
        self.removeChild()
        
        let coordinator = NewChannelCoordinator(router: self.router, deepLink: self.deepLink)
        self.addChildAndStart(coordinator) { (result) in
            self.router.dismiss(source: coordinator.toPresentable(), animated: true) {
                guard let channel = result else { return }
                self.startChannelFlow(for: channel)
            }
        }
        self.router.present(coordinator, source: self.homeVC, animated: true)
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
