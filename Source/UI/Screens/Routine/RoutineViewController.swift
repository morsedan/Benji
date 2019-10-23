//
//  RoutineViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineViewController: NavigationBarViewController {

    private static let inputVCHeight: CGFloat = 500

    private let routineInputVC: RoutineInputViewController

    init(delegate: RoutineInputViewControllerDelegate) {
        self.routineInputVC = RoutineInputViewController(delegate: delegate)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        self.routineInputVC.view.size = CGSize(width: self.view.width,
                                               height: RoutineViewController.inputVCHeight)
        self.routineInputVC.view.centerOnX()
        self.routineInputVC.view.bottom = self.view.height - self.view.safeAreaInsets.bottom

        self.scrollView.contentSize = CGSize(width: self.view.width,
                                             height: self.routineInputVC.view.bottom + 20)
    }
}
