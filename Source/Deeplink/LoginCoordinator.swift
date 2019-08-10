//
//  LoginCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 8/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class LoginCoordinator: PresentableCoordinator<Void> {

    var userExists: Bool

    lazy var loginFlowController = LoginFlowViewController(introVC: nil,
                                                           endingVC: nil,
                                                           userExists: self.userExists)

    lazy var scrolledModal = ScrolledModalController(presentable: self.loginFlowController)

    init(router: Router, userExists: Bool) {
        self.userExists = userExists

        super.init(router: router, deepLink: nil)
    }

    override func toPresentable() -> UIViewController {
        return self.scrolledModal
    }

    override func start() {
        self.scrolledModal.didDismiss = { [unowned self] in
            self.finishFlow(with: ())
        }

        let identifier = TomorrowAnalytics.identifier(for: self.router.navController.topmostViewController())
        TomorrowAnalytics.reportEvent(eventName: "\(identifier).presentUserLoginFlow")
    }
}
