//
//  RoutineViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 10/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RoutineViewController: FullScreenViewController {

    let backButton = Button()
    let titleLabel = Display1Label()
    let descriptionLabel = RegularSemiBoldLabel()
    let routineInputVC = RoutineInputViewController()

    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.backButton)
        self.contentContainer.addSubview(self.titleLabel)
        self.contentContainer.addSubview(self.descriptionLabel)

        self.addChild(viewController: self.routineInputVC)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backButton.size = CGSize(width:40, height: 40)
        self.backButton.left = Theme.contentOffset
        self.backButton.top = 0

        self.titleLabel.setSize(withWidth: 200)
        self.titleLabel.top = 0
        self.titleLabel.centerOnX()

        self.descriptionLabel.setSize(withWidth: self.contentContainer.width * 0.8)
        self.descriptionLabel.top = self.titleLabel.bottom + 20
        self.descriptionLabel.centerOnX()

        self.routineInputVC.view.size = CGSize(width: self.contentContainer.width, height: 300)
        self.routineInputVC.view.centerOnX()
        self.routineInputVC.view.bottom = self.contentContainer.height
    }
}
