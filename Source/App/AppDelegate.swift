//
//  AppDelegate.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let rootNavController = RootNavigationController()
        self.initializeKeyWindow(with: rootNavController)
        self.initializeMainCoordinator(with: rootNavController, withOptions: launchOptions)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard !ChannelManager.shared.isSynced else { return }

        switch LaunchManager.shared.status {
        case .isLaunching, .failed(_):
            break
        case .success(_):
            if let identity = User.current.objectId {
                LaunchManager.shared.authenticateChatClient(with: identity)
            } else {
                LaunchManager.shared.createAnonymousUser()
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let currentID = User.current.objectId else { return }
        let token = self.createToken(fromDeviceToken: deviceToken)
        UserNotificationManager.shared.registerDevice(currentID, deviceToken: token)
    }

    private func createToken(fromDeviceToken deviceToken: Data) -> String {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        return token
    }
}

