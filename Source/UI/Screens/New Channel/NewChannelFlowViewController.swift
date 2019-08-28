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

    lazy var manager: NewChannelCollectionViewManager = {
        let manager = NewChannelCollectionViewManager(with: self.collectionView)
        return manager
    }()

    override func initializeViews() {
        super.initializeViews()

        self.view.set(backgroundColor: .background2)

        self.view.addSubview(self.titleBar)
        self.view.addSubview(self.collectionView)

        self.collectionView.delegate = self.manager
        self.collectionView.dataSource = self.manager
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.titleBar.size = CGSize(width: self.view.width, height: 44)
        self.titleBar.top = 0
        self.titleBar.centerOnX()

        self.collectionView.size = CGSize(width: self.view.width, height: self.view.height - self.titleBar.height)
        self.collectionView.top = self.titleBar.bottom
    }
}
