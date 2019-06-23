//
//  Coordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol CoordinatorType: class {
    var parentCoordinator: CoordinatorType? { set get }
    var furthestChild: CoordinatorType { get }

    func start(with deepLink: DeepLinkable?)
    func addChildAndStart(_ coordinator: CoordinatorType, with deepLink: DeepLinkable?)
    func removeChild()
}

class Coordinator<Result>: CoordinatorType {

    let navController: UINavigationController
    var deepLink: DeepLinkable?

    private var onFinishedFlow: ((Result) -> Void)?

    weak var parentCoordinator: CoordinatorType?
    private(set) var childCoordinator: CoordinatorType?
    var furthestChild: CoordinatorType {
        if let child = self.childCoordinator {
            return child.furthestChild
        }
        return self
    }

    init(navController: UINavigationController) {
        self.navController = navController
    }

    func start(with deepLink: DeepLinkable? = nil) {
        self.deepLink = deepLink
    }

    func addChildAndStart(_ coordinator: CoordinatorType, with deepLink: DeepLinkable? = nil) {
        guard self.childCoordinator == nil else {
            print("WARNING!!!!! ATTEMPTING TO ADD CHILD COORDINATOR \(coordinator)"
                + " TO COORDINATOR \(self) THAT ALREADY HAS ONE \(self.childCoordinator!)")
            return
        }
        coordinator.parentCoordinator = self
        self.childCoordinator = coordinator
        coordinator.start(with: deepLink)
    }

    func removeChild() {
        self.childCoordinator = nil
    }

    func removeFromParent() {
        self.parentCoordinator?.removeChild()
    }

    func setFinishedHandler(_ handler: @escaping (Result) -> Void) {
        self.onFinishedFlow = handler
    }

    func finishFlow(with result: Result) {
        self.removeFromParent()
        self.onFinishedFlow?(result)
    }
}
