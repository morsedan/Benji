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
        collectionView.channelDataSource = self.manager
        return collectionView
    }()

    lazy var manager: ChannelCollectionViewManager = {
        let manager = ChannelCollectionViewManager()
        manager.didSelect = { [unowned self] (item, indexPath) in

        }
        manager.didLongPress = { [unowned self] (item, indexPath) in

        }
        return manager
    }()

    override func loadView() {
        self.view = self.collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.manager.collectionView = self.collectionView
        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager

        self.subscribeToClient()
        self.subscribeToUpdates()
    }
}
