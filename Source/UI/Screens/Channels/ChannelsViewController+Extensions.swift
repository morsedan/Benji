//
//  ChannelsViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 8/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension ChannelsViewController {

    func subscribeToUpdates() {
        ChannelManager.shared.channelUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelsUpdate = update else { return }

            switch channelsUpdate.status {
            case .added:
                self.manager.append(item: .channel(channelsUpdate.channel))
            case .changed:
                self.manager.update(item: .channel(channelsUpdate.channel))
            case .deleted:
                self.manager.delete(item: .channel(channelsUpdate.channel))
            }
        }.start()

        ChannelManager.shared.clientSyncUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let clientUpdate = update else { return }

            switch clientUpdate {
            case .started:
                break
            case .channelsListCompleted:
                break
            case .completed:
                self.loadTestChannels()
                //self.loadChannels()
            case .failed:
                break
            @unknown default:
                break
            }
            }.start()
    }

    private func loadChannels() {
        self.manager.set(newItems: ChannelManager.shared.channelTypes)
    }

    private func loadTestChannels() {
        var items: [ChannelType] = []
        for _ in 0...10 {
            items.append(.system(Lorem.systemMessage()))
        }
        self.manager.set(newItems: items)
    }
}
