//
//  RoutineViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TMROLocalization

class RoutineViewController: NavigationBarViewController {

    let routineInputVC = RoutineInputViewController()

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background2)
        self.addChild(viewController: self.routineInputVC)
    }

    override func getTitle() -> Localized {
        return "DAILY ROUTINE"
    }

    override func getDescription() -> Localized {
        return "Get a daily reminder to follow up and connect with others."
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.routineInputVC.view.size = CGSize(width: self.view.width, height: RoutineInputViewController.height)
        self.routineInputVC.view.centerOnX()
        self.routineInputVC.view.bottom = self.view.height - self.view.safeAreaInsets.bottom

        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.routineInputVC.view.bottom + 20)
    }
}
