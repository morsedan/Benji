//
//  MainCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class MainCoordinator: Coordinator<Void> {

    var launchOptions: [UIApplication.LaunchOptionsKey : Any]?

    override init(router: Router, deepLink: DeepLinkable?) {
        super.init(router: router, deepLink: deepLink)
        self.initializeLogoutHandler()
    }

    private func initializeLogoutHandler() {
        // If the user ever logs out, restart the whole flow from the beginning
        LaunchManager.shared.onLoggedOut = { [unowned self] in
            self.removeChild()
            self.runLaunchFlow()
        }
    }

    override func start() {
        super.start()

        self.runLaunchFlow()
    }

    private func runLaunchFlow() {
        let launchCoordinator = LaunchCoordinator(router: self.router,
                                                  deepLink: self.deepLink,
                                                  launchOptions: self.launchOptions)

        self.router.setRootModule(launchCoordinator, animated: true)
        self.addChildAndStart(launchCoordinator, finishedHandler: { [unowned self] (result) in
            ChannelManager.initialize(token: result.token)

            self.handle(result: result)
        })
    }

    private func handle(result: LaunchResult) {
        runMain {
            if PFAnonymousUtils.isLinked(with: PFUser.current()) {
                self.runLoginFlow()
            } else {
                self.runHomeFlow()
            }
        }
    }

    private func runHomeFlow() {
        let homeCoordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(homeCoordinator, animated: true)
        self.addChildAndStart(homeCoordinator, finishedHandler: { _ in
            // If the home coordinator ever finishes, put handling logic here.
        })
    }

    private func runLoginFlow() {
        let coordinator = LoginCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(source: coordinator.toPresentable(), animated: true) {
                self.runHomeFlow()
            }
        })
    }
}

