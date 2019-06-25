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
        self.view.set(backgroundColor: .red)
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
        let system1 = SystemMessage(body: "This is a system messgae", id: "system.1")
        let system2 = SystemMessage(body: "This is a system messgae", id: "system.2")
        let system3 = SystemMessage(body: "This is a system messgae", id: "system.3")
        let system4 = SystemMessage(body: "This is a system messgae", id: "system.4")
        let system5 = SystemMessage(body: "This is a system messgae", id: "system.5")
        items.append(contentsOf: [.system(system1), .system(system2), .system(system3), .system(system4), .system(system5)])
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
