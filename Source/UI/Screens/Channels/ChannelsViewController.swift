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

        self.getChannels()
    }

    private func getChannels() {
//        ChannelManager.shared.getChannels { (optionalChannels, error) in
//            guard let channels = optionalChannels else { return }
//            self.manager.items.value = channels
//        }
    }

    private func didSelect(channel: TCHChannel, at indexPath: IndexPath) {
        self.present(channel: channel)
    }

    private func createChannel() {
//        ChannelManager.shared.createAndJoin(channelName: "Some Channel", type: .public) { (newChannel, error) in
//            guard let channel = newChannel else { return }
//            self.present(channel: channel)
//        }
    }

    private func present(channel: TCHChannel) {
        let channelVC = ChannelViewController(channel: channel)
        self.present(channelVC, animated: true, completion: nil)
    }
}
