//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelViewController: FullScreenViewController {

    lazy var collectionView: ChannelCollectionView = {
        return ChannelCollectionView()
    }()

    lazy var manager: ChannelCollectionViewManager = {
        return ChannelCollectionViewManager(with: self.collectionView, items: [])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
