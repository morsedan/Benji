//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsViewController: FullScreenViewController {

    lazy var manager: ChannelsCollectionViewManager = {
        return ChannelsCollectionViewManager(with: self.content.collectionView)
    }()

    let content: ChannelsContentView = UINib.loadView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.content.collectionView.dataSource = self.manager
        self.content.collectionView.delegate = self.manager

        self.view.addSubview(self.content)
        self.content.autoPinEdgesToSuperviewEdges()
    }
}
