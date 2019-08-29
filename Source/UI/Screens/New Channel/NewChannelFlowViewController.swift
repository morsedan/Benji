//
//  NewChannelScrolledModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelFlowViewController: ScrolledModalFlowViewController {

    let titleBar = NewChannelTitleBar()
    let collectionView = NewChannelCollectionView()
    let createButton = Button()

    lazy var manager: NewChannelCollectionViewManager = {
        let manager = NewChannelCollectionViewManager(with: self.collectionView)
        return manager
    }()

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background2)

        self.view.addSubview(self.titleBar)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.createButton)

        self.createButton.set(style: .normal(color: .purple, text: "CREATE"))
        self.createButton.onTap { [unowned self] (tap) in
            //create channel
        }

        self.collectionView.delegate = self.manager
        self.collectionView.dataSource = self.manager
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.titleBar.size = CGSize(width: self.view.width - 40, height: 80)
        self.titleBar.top = 0
        self.titleBar.centerOnX()

        self.collectionView.size = CGSize(width: self.view.width, height: self.view.height - self.titleBar.height)
        self.collectionView.top = self.titleBar.bottom

        self.createButton.size = CGSize(width: 120, height: 50)
        self.createButton.roundCorners()
        self.createButton.right = self.view.width - 20
        self.createButton.bottom = self.view.height - 25 - self.view.safeAreaInsets.bottom
    }
}
