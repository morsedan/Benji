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

    lazy var profileVC = ProfileViewController(with: self.user)
    let user: PFUser

    init(with user: PFUser, router: Router, deepLink: DeepLinkable?) {
        self.user = user
        super.init(router: router, deepLink: deepLink)
    }

    override func toPresentable() -> DismissableVC {
        return self.profileVC
    }
}
