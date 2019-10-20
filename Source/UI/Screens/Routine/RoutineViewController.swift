//
//  RoutineViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineViewController: NavigationBarViewController {

    let routineInputVC = RoutineInputViewController()

    override func initializeViews() {
        super.initializeViews()

        self.addChild(viewController: self.routineInputVC)
    }

    override func getTitle() -> Localized {
        return "DAILY ROUTINE"
    }

    override func getDescription() -> Localized {
        return "Get a daily reminder to follow up and and connect with people."
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.routineInputVC.view.size = CGSize(width: self.view.width, height: 300)
        self.routineInputVC.view.centerOnX()
        self.routineInputVC.view.top = self.lineView.bottom + 40

        self.scrollView.contentSize = CGSize(width: self.view.width, height: self.routineInputVC.view.bottom + 20)
    }
}
