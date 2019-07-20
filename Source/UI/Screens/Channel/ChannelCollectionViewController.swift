//
//  ChannelCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import ReactiveSwift
import GestureRecognizerClosures

class ChannelCollectionViewController: ViewController {

    let loadingView = LoadingView()

    lazy var collectionView: ChannelCollectionView = {
        let flowLayout = ChannelCollectionViewFlowLayout()
        let collectionView = ChannelCollectionView(with: flowLayout)
        return collectionView
    }()

    lazy var manager: ChannelCollectionViewManager = {
        let manager = ChannelCollectionViewManager(with: self.collectionView)
        manager.didSelect = { [unowned self] (item, indexPath) in

        }
        manager.didLongPress = { [unowned self] (item, indexPath) in

        }
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager

        self.subscribeToClient()
        self.subscribeToUpdates()
    }
}
