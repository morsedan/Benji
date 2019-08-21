//
//  SplashViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SplashViewController: FullScreenViewController {

    let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func initializeViews() {
        super.initializeViews()

        self.contentContainer.addSubview(self.loadingIndicator)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.loadingIndicator.centerOnXAndY()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadingIndicator.startAnimating()
    }
}
