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
        guard let filter = self.channelFilter else { return }

        let allChannels = self.channelTypeCache
        var filteredChannels: [ChannelType] = []

        switch filter.scope {
        case .all:
            if filter.text.isEmpty {
                filteredChannels = Array(allChannels.prefix(3))
            } else {
                filteredChannels = allChannels.filter { (channelType) in
                    if channelType.uniqueName.contains(filter.text) {
                        print("TEXT: \(filter.text)  UNIQUE: \(channelType.uniqueName)")
                        return true
                    } else {
                        return false
                    }
                }
            }

        case .channels, .dms:
            filteredChannels = allChannels.filter { (channelType) in

                let doesCategoryMatch = channelType.scope == filter.scope

                if filter.text.isEmpty {
                    return doesCategoryMatch
                } else {
                    return doesCategoryMatch && channelType.uniqueName.contains(filter.text)
                }
            }
        }

        self.items.value = filteredChannels
        self.collectionView.reloadData()
    }
}
