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

    func start()
    func removeChild()
}

class Coordinator<Result>: CoordinatorType, Presentable {

    let router: Router
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

    init(router: Router, deepLink: DeepLinkable?) {
        self.router = router
        self.deepLink = deepLink
    }

    func toPresentable() -> UIViewController {
        fatalError("toPresentable not implemented in \(self)")
    }

    func start() { }

    final func start(with deepLink: DeepLinkable?) {
        self.deepLink = deepLink
        self.start()
    }

    func addChildAndStart(_ coordinator: CoordinatorType) {
        guard self.childCoordinator == nil else {
            print("WARNING!!!!! ATTEMPTING TO ADD CHILD COORDINATOR \(coordinator)"
                + " TO COORDINATOR \(self) THAT ALREADY HAS ONE \(self.childCoordinator!)")
            return
        }

        coordinator.parentCoordinator = self
        self.childCoordinator = coordinator
        coordinator.start()
    }

    func setFinishedHandler(_ handler: @escaping (Result) -> Void) {
        self.onFinishedFlow = handler
    }

    func removeChild() {
        self.childCoordinator = nil
    }

    func removeFromParent() {
        self.parentCoordinator?.removeChild()
    }

    func finishFlow(with result: Result) {
        self.removeFromParent()
        self.onFinishedFlow?(result)
    }
}
