//
//  SplashViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SplashViewController: FullScreenViewController {

    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let label = RegularSemiBoldLabel()
    
    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background1)

        self.contentContainer.addSubview(self.loadingIndicator)
        self.contentContainer.addSubview(self.label)

        self.subscribeToUpdates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.loadingIndicator.centerOnXAndY()
        self.label.setSize(withWidth: self.view.proportionalWidth)
        self.label.top = self.loadingIndicator.bottom + 10
        self.label.centerOnX()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.loadingIndicator.stopAnimating()
    }

    private func subscribeToUpdates() {

        self.loadingIndicator.startAnimating()
        self.label.set(text: "Loading...",
                       alignment: .center,
                       stringCasing: .uppercase)
    }
}
