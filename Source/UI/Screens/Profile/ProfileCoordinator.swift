//
//  ProfileCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 10/5/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ProfileCoordinator: PresentableCoordinator<Void> {

    lazy var profileVC = ProfileViewController()

    override func toPresentable() -> DismissableVC {
        return self.profileVC
    }
}
