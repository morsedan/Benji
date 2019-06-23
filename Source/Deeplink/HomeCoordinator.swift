//
//  HomeCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class HomeCoordinator: Coordinator<Void> {

    lazy var homeVC = HomeViewController()

    override func start(with deepLink: DeepLinkable? = nil) {

        super.start(with: deepLink)

        // Don't create a new home view controller if there's already one on the nav stack
        if let currentHomeVC = self.navController.viewControllers.first(where: { (viewController) in
            return viewController is HomeViewController
        }) as? HomeViewController {
            self.homeVC = currentHomeVC
        }

        self.navController.setViewControllers([self.homeVC], animated: true)
    }
}
