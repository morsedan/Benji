//
//  MainCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

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

        if !LaunchManager.shared.finishedInitialFetch {
            self.runLaunchFlow()
        } else {
            self.runHomeFlow()
        }
    }

    private func runLaunchFlow() {
        let launchCoordinator = LaunchCoordinator(router: self.router,
                                                  deepLink: self.deepLink,
                                                  launchOptions: self.launchOptions)

        self.router.setRootModule(launchCoordinator, animated: true)
        self.addChildAndStart(launchCoordinator, finishedHandler: { [unowned self] (deepLink) in
            // Listen for any future deep links
            LaunchManager.shared.delegate = self

            self.start(with: deepLink)
        })
    }

    private func runHomeFlow() {
        let homeCoordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(homeCoordinator, animated: true)
        self.addChildAndStart(homeCoordinator, finishedHandler: { _ in
            // If the home coordinator ever finishes, put handling logic here.
        })
    }
}

extension MainCoordinator: LaunchManagerDelegate {
    func launchManager(_ launchManager: LaunchManager, didFinishWith options: LaunchOptions) {
        switch options {
        case .success(let object):
            guard let deepLink = object else { break }
            self.start(with: deepLink)
        case .failed:
            break
        }
    }
}

