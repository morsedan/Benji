//
//  AppDelegate+Initialization.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension AppDelegate {

    func initializeKeyWindow(with rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

    func initializeMainCoordinator(with rootNavController: RootNavigationController,
                                   withOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.mainCoordinator = MainCoordinator(navController: rootNavController)
        self.mainCoordinator?.launchOptions = launchOptions
        self.mainCoordinator?.start()
    }
}
