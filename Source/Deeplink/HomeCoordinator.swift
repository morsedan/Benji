//
//  HomeCoordinator.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Parse

class HomeCoordinator: Coordinator<Void> {

    lazy var homeVC = HomeViewController()

    override func toPresentable() -> UIViewController {
        return self.homeVC
    }

    override func start() {
        super.start()

    }
}
