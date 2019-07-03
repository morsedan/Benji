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

    private func loadMessages() {
        var items: [MessageType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        self.manager.set(newItems: items)
    }

    override func didSelect(item: MessageType, at indexPath: IndexPath) {
        
    }

}
