//
//  FullScreenViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

// Base class for all full screen view controllers pushed onto a UINavigationController stack.
// Contains a custom navigation bar that replaces the standard navigation bar. View content is
// placed in the space below the nav bar.
class FullScreenViewController: ViewController {

    // A view to insert content. Takes up the space below the custom nav bar
    let contentContainer = View()
    let topBar = View()

    var showTopBar: Bool = true {
        didSet {
            self.view.layoutNow()
        }
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background2)
        self.view.addSubview(self.contentContainer)
        self.view.addSubview(self.topBar)
        self.topBar.set(backgroundColor: .background3)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.contentContainer.top = self.view.safeAreaInsets.top
        self.contentContainer.width = self.view.width
        let height = self.view.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        self.contentContainer.height = height
        self.contentContainer.centerOnX()

        self.topBar.size = CGSize(width: 30, height: 4)
        self.topBar.top = 8
        self.topBar.centerOnX()
        self.topBar.layer.cornerRadius = 2
        self.topBar.isHidden = !self.showTopBar
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Force hide keyboard so it dimisses at the same time as view controller
        self.view.endEditing(true)
    }
}

