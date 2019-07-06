//
//  ChannelCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelCollectionViewController: CollectionViewController<MessageCell, ChannelCollectionViewManager> {

    let loadingView = LoadingView()

    init() {
        let collectionView = ChannelCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .clear)
        self.subscribeToClient()
        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didSelect(item: MessageType, at indexPath: IndexPath) {
        
    }

}
