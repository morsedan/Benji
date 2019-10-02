//
//  ChannelsViewController+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 10/2/19.
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
                // Do nothing. We only want to show channels that are being searched for.
                break
            case .changed:
                self.manager.update(item: .channel(channelsUpdate.channel))
            case .deleted:
                self.manager.delete(item: .channel(channelsUpdate.channel))
            }

            // Reload the cache because changes to the channel list have occurred.
            self.manager.channelTypeCache = self.getChannelsSortedByUpdateDate()
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
                self.manager.channelTypeCache = self.getChannelsSortedByUpdateDate()
                self.manager.loadFilteredChannels()
            case .failed:
                break
            @unknown default:
                break
            }
            }.start()
    }

    private func getChannelsSortedByUpdateDate() -> [ChannelType] {
        let channelTypes = ChannelManager.shared.channelTypes
        return channelTypes.sorted { (channel1, channel2) -> Bool in
            channel1.dateUpdated > channel2.dateUpdated
        }
    }
}
