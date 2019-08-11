//
//  HomeCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class HomeCoordinator: PresentableCoordinator<Void> {

    lazy var homeVC = HomeViewController()

    override func toPresentable() -> UIViewController {
        return self.homeVC
    }

    override func start() {
        super.start()

        if PFAnonymousUtils.isLinked(with: PFUser.current()) {
            self.startLoginFlow()
        }
    }

    func startLoginFlow() {
        let coordinator = LoginCoordinator(router: self.router, userExists: false)
        coordinator.setFinishedHandler { (_) in
            self.router.dismiss(animated: true, completion: nil)
        }
        self.router.present(coordinator, animated: true)
        self.addChildAndStart(coordinator)
    }
}
