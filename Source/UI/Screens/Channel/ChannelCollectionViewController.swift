//
//  ChannelCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewController: CollectionViewController<MessageCell, ChannelCollectionViewManager> {

    init() {
        let collectionView = ChannelCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .clear)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadMessages() {
        self.manager.set(newItems: Lorem.systemMessageTypes())
    }

    override func didSelect(item: MessageType, at indexPath: IndexPath) {
        
    }

}
