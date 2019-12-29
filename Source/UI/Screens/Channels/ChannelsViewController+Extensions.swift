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
        ChannelManager.shared.channelsUpdate.producer.on { [weak self] (update) in
            guard let `self` = self else { return }

            guard let channelsUpdate = update else { return }

            switch channelsUpdate.status {
            case .added:
                // Do nothing. We only want to show channels that are being searched for.
                break
            case .changed:
                let displayable = DisplayableChannel(channelType: .channel(channelsUpdate.channel))
                self.collectionViewManager.update(item: displayable)
            case .deleted:
                let displayable = DisplayableChannel(channelType: .channel(channelsUpdate.channel))
                self.collectionViewManager.delete(item: displayable)
            }

            // Reload the cache because changes to the channel list have occurred.
            self.collectionViewManager.channelCache = self.getChannelsSortedByUpdateDate()
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
                self.collectionViewManager.channelCache = self.getChannelsSortedByUpdateDate()
                self.collectionViewManager.loadAllChannels()
            case .failed:
                break
            @unknown default:
                break
            }
            }.start()
    }

    private func getChannelsSortedByUpdateDate() -> [DisplayableChannel] {
        let channelTypes = ChannelManager.shared.subscribedChannels
        return channelTypes.sorted { (channel1, channel2) -> Bool in
            channel1.channelType.dateUpdated > channel2.channelType.dateUpdated
        }
    }
}
