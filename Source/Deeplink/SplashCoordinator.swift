//
//  SplashCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SplashCoordinator: PresentableCoordinator<Void> {

    lazy var splashVC = SplashViewController(with: self)

    override func toPresentable() -> DismissableVC {
        return self.splashVC
    }

    override func start() {
        super.start()

    }

    private func runHomeFlow() {
        let homeCoordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(homeCoordinator, animated: true)
        self.addChildAndStart(homeCoordinator, finishedHandler: { _ in
            // If the home coordinator ever finishes, put handling logic here.
        })
    }
}

extension SplashCoordinator: SplashViewControllerDelegate {

}

