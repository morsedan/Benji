//
//  ProfileCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class ProfileCoordinator: PresentableCoordinator<Void> {

    lazy var profileVC = ProfileViewController(with: self.user, delegate: self)
    let navController: NavigationController
    let user: PFUser

    init(with user: PFUser, router: Router, deepLink: DeepLinkable?) {
        self.user = user
        let navController = NavigationController()
        let router = Router(navController: navController)
        self.navController = navController

        super.init(router: router, deepLink: deepLink)
    }

    override func toPresentable() -> DismissableVC {
        self.navController.setViewControllers([self.profileVC], animated: false)
        return self.navController
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func profileView(_ controller: ProfileViewController, didSelectRoutineFor user: PFUser) {
        let vc = RoutineViewController(delegate: self)
        self.router.push(vc, animated: true, completion: nil)
    }
}

extension ProfileCoordinator: RoutineInputViewControllerDelegate {

    func routineInputViewControllerSetRoutine(_ controller: RoutineInputViewController) {
        self.router.popModule(animated: true)
    }
}
