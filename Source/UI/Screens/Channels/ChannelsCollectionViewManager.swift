//
//  ChannelsCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

struct SearchFilter {
    var text: String
    var scope: SearchScope
}

class ChannelsCollectionViewManager: CollectionViewManager<ChannelCell> {

    // A cache of the all the user's current channels and system messages,
    // sorted by date updated, with newer channels at the beginning.
    lazy var channelTypeCache: [ChannelType] = []
    
    var channelFilter: SearchFilter? {
        didSet {
            self.loadFilteredChannels()
        }
    }

    override func managerWillDisplay(cell: ChannelCell, for indexPath: IndexPath) -> ChannelCell {
        if let filter = self.channelFilter {
            cell.highlight(filteredText: filter.text)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 60)
    }

    func loadFilteredChannels() {
        let allChannels = self.channelTypeCache





        if let filter = self.channelFilter, !filter.text.isEmpty, filter.scope != .recents {
            let filteredChannels = allChannels.filter { (channelType) in
                let doesCategoryMatch = (filter.scope == .all) || (channelType.scope == filter.scope)
                return doesCategoryMatch && channelType.uniqueName.contains(filter.text)
            }

            self.items.value = filteredChannels
            self.collectionView.reloadData()
        } else {
            // If no filter, get the first three most recently updated channels.
            let filteredChannels: [ChannelType] = Array(allChannels.prefix(3))
            self.items.value = filteredChannels
            self.collectionView.reloadData()
        }
    }
}
