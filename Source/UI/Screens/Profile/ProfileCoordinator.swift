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
    lazy var routineVC = RoutineViewController()
    let navController: NavigationController
    let user: User

    init(with user: User,
         router: Router,
         deepLink: DeepLinkable?) {
        
        self.user = user
        let navController = NavigationController()
        let router = Router(navController: navController)
        self.navController = navController

        super.init(router: router, deepLink: deepLink)
    }

    override func toPresentable() -> DismissableVC {
        var controller: UIViewController = self.profileVC

        if let link = self.deepLink, let target = link.deepLinkTarget, target == .routine {
            controller = self.routineVC
        }

        self.navController.setViewControllers([controller], animated: false)
        return self.navController
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func profileView(_ controller: ProfileViewController, didSelectRoutineFor user: PFUser) {
        let vc = RoutineViewController()
        self.router.push(vc, animated: true, completion: nil)
    }
}
