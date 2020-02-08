//
//  MainCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse
import TMROFutures

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
            self.handle(result: result)
        })
    }

    private func handle(result: LaunchStatus) {

        switch result {
        case .isLaunching:
            break
        case .needsOnboarding:
            runMain {
                self.runOnboardingFlow()
            }
        case .success(let object, let token):
            self.deepLink = object
            self.initializeChat(with: token)
        case .failed(_):
            break
        }
    }

    private func initializeChat(with token: String) {
        ChannelManager.initialize(token: token)
            .withResultToast()
            .observeValue(with: { (_) in
                runMain {
                    self.runHomeFlow()
                }
            })
    }

    private func runHomeFlow() {
        if User.current()?.handle == nil {
            self.createHandle()
                .observeValue(with: { (_) in
                    runMain {
                        self.runHomeFlow()
                    }
                })
        } else {
            runMain {
                let homeCoordinator = HomeCoordinator(router: self.router, deepLink: self.deepLink)
                self.router.setRootModule(homeCoordinator, animated: true)
                self.addChildAndStart(homeCoordinator, finishedHandler: { _ in
                    // If the home coordinator ever finishes, put handling logic here.
                })
            }
        }
    }

    private func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(router: self.router, deepLink: self.deepLink)
        self.router.setRootModule(coordinator, animated: true)
        self.addChildAndStart(coordinator, finishedHandler: { (_) in
            self.router.dismiss(source: coordinator.toPresentable(), animated: true) {
                self.runLaunchFlow()
            }
        })
    }

    private func createHandle() -> Future<Void> {
        let promise = Promise<Void>()

        Reservation.create()
            .observeValue(with: { (reservation) in
                User.current()?.reservation = reservation
                User.current()?.createHandle()
                User.current()?.saveToServer()
                    .observe { (userResult) in
                        switch userResult {
                        case .success(_):
                            promise.resolve(with: ())
                        case .failure(let error):
                            promise.reject(with: error)
                        }
                }
            })

        return promise
    }
}

