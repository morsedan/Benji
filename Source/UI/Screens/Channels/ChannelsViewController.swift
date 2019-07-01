//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelsViewController: CollectionViewController<ChannelCell, ChannelsCollectionViewManager> {

    init() {
        let collectionView = ChannelsCollectionView()
        super.init(with: collectionView)
        self.view.set(backgroundColor: .clear)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadChannels()
    }

    private func loadChannels() {
        var items: [ChannelsType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        self.manager.set(newItems: items)
    }

    override func didSelect(item: ChannelsType, at indexPath: IndexPath) {
        self.present(type: item)
    }

    private func present(type: ChannelsType) {
        switch type {
        case .system(_):
            break
        case .channel(let channel):
            let channelVC = ChannelViewController(channel: channel)
            self.present(channelVC, animated: true, completion: nil)
        }

    }
}
