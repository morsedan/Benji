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

class LaunchCoordinator: PresentableCoordinator<LaunchStatus> {

    private lazy var splashVC = SplashViewController()
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    init(router: Router,
         deepLink: DeepLinkable?,
         launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        self.launchOptions = launchOptions
        super.init(router: router, deepLink: deepLink)


        LaunchManager.shared.status.producer.on { [weak self] (options) in
            guard let `self` = self else { return }
            self.finishFlow(with: options)
        }
        .start()
    }

    override func toPresentable() -> DismissableVC {
        return self.splashVC
    }

    override func start() {
        super.start()

        LaunchManager.shared.launchApp(with: self.launchOptions)
    }
}

