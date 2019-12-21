//
//  ProfileCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class ProfileCoordinator: Coordinator<Void> {

    let profileVC: ProfileViewController
    let navController: NavigationController

    init(router: Router,
         deepLink: DeepLinkable?,
         profileVC: ProfileViewController) {

        self.profileVC = profileVC
        let navController = NavigationController()
        let router = Router(navController: navController)
        self.navController = navController

        super.init(router: router, deepLink: deepLink)
    }

    override func start() {
        var controllers: [UIViewController] = [self.profileVC]

        if let link = self.deepLink, let target = link.deepLinkTarget, target == .routine {
            controllers.append(RoutineViewController())
        }

        self.navController.setViewControllers(controllers, animated: false)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func profileView(_ controller: ProfileViewController, didSelectRoutineFor user: PFUser) {
        let vc = RoutineViewController()
        self.router.push(vc, animated: true, completion: nil)
    }
}
