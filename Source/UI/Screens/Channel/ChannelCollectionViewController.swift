//
//  ChannelCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCollectionViewController: ViewController {

    let loadingView = LoadingView()

    lazy var collectionView: ChannelCollectionView = {
        let flowLayout = ChannelCollectionViewFlowLayout()
        let collectionView = ChannelCollectionView(with: flowLayout)
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        //self.view.set(backgroundColor: .clear)
        self.subscribeToClient()
        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func didSelect(item: MessageType, at indexPath: IndexPath) {
//        
//    }

}
