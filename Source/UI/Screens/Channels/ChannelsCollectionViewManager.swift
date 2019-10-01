//
//  ChannelsCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class ChannelsCollectionViewManager: CollectionViewManager<ChannelCell> {

    // A cache of the all the user's current channels and system messages,
    // sorted by date updated, with newer channels at the beginning.
    lazy var channelTypeCache: [ChannelType] = []
    
    var channelFilter: String? {
        didSet {
            self.loadFilteredChannels()
        }
    }

    override func managerWillDisplay(cell: ChannelCell, for indexPath: IndexPath) -> ChannelCell {
        if let text = self.channelFilter {
            cell.highlight(filteredText: text)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 60)
    }

    func loadFilteredChannels() {
        let allChannels = self.channelTypeCache

        if let filter = self.channelFilter, !filter.isEmpty {
            let filteredChannels = allChannels.filter { (channelType) in
                return channelType.uniqueName.contains(filter)
            }

            self.set(newItems: filteredChannels)
        } else {
            // If no filter, get the first three most recently updated channels.
            let filteredChannels: [ChannelType] = Array(allChannels.prefix(3))
            self.set(newItems: filteredChannels)
        }
    }
}
