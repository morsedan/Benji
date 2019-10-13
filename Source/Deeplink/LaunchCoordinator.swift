//
//  SplashCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

// Presents the splash view controller and tells the launch manager to start retrieving
// user data. Once the data is retrieved, it checks if the app needs to be updated, and presents the
// update flow if needed.

class LaunchCoordinator: PresentableCoordinator<DeepLinkable?> {

    private lazy var splashVC = SplashViewController()
    private var finishedAnimation: Bool = false
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    init(router: Router,
         deepLink: DeepLinkable?,
         launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        self.launchOptions = launchOptions
        super.init(router: router, deepLink: deepLink)
    }

    override func toPresentable() -> DismissableVC {
        return self.splashVC
    }

    override func start() {
        super.start()

        LaunchManager.shared.launchApp(with: self.launchOptions)
        LaunchManager.shared.delegate = self
    }
}

extension LaunchCoordinator: LaunchManagerDelegate {

    func launchManager(_ launchManager: LaunchManager, didFinishWith options: LaunchStatus) {
        switch options {
        case .success(let deepLink):
            self.deepLink = deepLink
            runMain {
                if PFAnonymousUtils.isLinked(with: PFUser.current()) {
                    self.runLoginFlow()
                } else {
                    self.runHomeFlow()
                }
            }
        default:
            break
        }
    }

    private func runHomeFlow() {
        let coordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { _ in
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

