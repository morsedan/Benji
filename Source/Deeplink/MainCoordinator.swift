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

    override init(navController: UINavigationController) {
        super.init(navController: navController)
        self.initializeLogoutHandler()
    }

    private func initializeLogoutHandler() {
        // If the user ever logs out, restart the whole flow from the beginning

    }

    override func start(with deepLink: DeepLinkable? = nil) {
        super.start(with: deepLink)

        self.handle(deepLink: deepLink)
    }

    private func handle(deepLink: DeepLinkable?) {
        // NOTE: Deep links can interrupt other flows. Because of this we need to deallocate whatever flow
        // is currently being run.
        self.removeChild()
        self.runHomeFlow()
    }

    private func runHomeFlow() {
        let homeCoordinator = HomeCoordinator(navController: self.navController)
        self.addChildAndStart(homeCoordinator, with: self.deepLink)
    }
}

