//
//  ChannelsViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelsViewController: FullScreenViewController {

    lazy var manager: ChannelsCollectionViewManager = {
        let manager = ChannelsCollectionViewManager(with: self.content.collectionView)
        manager.didSelect = { [unowned self] channel, indexPath in
            self.didSelect(channel: channel, at: indexPath)
        }
        return manager
    }()

    let content: ChannelsContentView = UINib.loadView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.content.collectionView.dataSource = self.manager
        self.content.collectionView.delegate = self.manager

        self.view.addSubview(self.content)
        self.content.autoPinEdgesToSuperviewEdges()

        self.getChannels()

        self.content.button.onTap { [unowned self] (tap) in
            self.createChannel()
        }
    }

    private func getChannels() {
        ChannelManager.shared.getChannels { (optionalChannels, error) in
            guard let channels = optionalChannels else { return }
            self.manager.items.value = channels
        }
    }

    private func didSelect(channel: TCHChannel, at indexPath: IndexPath) {
        self.present(channel: channel)
    }

    private func createChannel() {
        ChannelManager.shared.createAndJoin(channelName: "Some Channel", type: .public) { (newChannel, error) in
            guard let channel = newChannel else { return }
            self.present(channel: channel)
        }
    }

    private func present(channel: TCHChannel) {
        let channelVC = ChannelViewController(channel: channel)
        self.present(channelVC, animated: true, completion: nil)
    }
}
