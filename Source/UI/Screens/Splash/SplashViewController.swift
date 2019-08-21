//
//  SplashViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol SplashViewControllerDelegate: class {
}

class SplashViewController: FullScreenViewController {

    let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)

    unowned let delegate: SplashViewControllerDelegate

    init(with delegate: SplashViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(withObject object: DeepLinkable) {
        fatalError("init(withObject:) has not been implemented")
    }
    
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
