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

class DisplayableChannel: DisplayableCellItem, Hashable, Comparable {

    var backgroundColor: Color {
        self.channelType.backgroundColor
    }

    var highlightText = String()
    var channelType: ChannelType

    init(channelType: ChannelType) {
        self.channelType = channelType
    }

    func diffIdentifier() -> NSObjectProtocol {
        self.channelType.diffIdentifier()
    }

    static func == (lhs: DisplayableChannel, rhs: DisplayableChannel) -> Bool {
        return lhs.channelType.uniqueName == rhs.channelType.uniqueName
            && lhs.highlightText == rhs.highlightText
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.channelType.uniqueName)
    }

    static func < (lhs: DisplayableChannel, rhs: DisplayableChannel) -> Bool {
        return lhs.highlightText < rhs.highlightText
    }
}

class ChannelsCollectionViewManager: CollectionViewManager<ChannelCell> {

    // A cache of the all the user's current channels and system messages,
    // sorted by date updated, with newer channels at the beginning.
    lazy var channelCache: [DisplayableChannel] = []
    
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

        let allChannels = self.channelCache
        var filteredChannels: [DisplayableChannel] = []

        switch filter.scope {
        case .all:
            if filter.text.isEmpty {
                filteredChannels = Array(allChannels.prefix(3))
            } else {
                filteredChannels = allChannels.filter { (channel) in
                    if channel.channelType.uniqueName.contains(filter.text) {
                        return true
                    } else {
                        return false
                    }
                }
            }

        case .channels, .dms:
            filteredChannels = allChannels.filter { (channel) in

                let doesCategoryMatch = channel.channelType.scope == filter.scope

                if filter.text.isEmpty {
                    return doesCategoryMatch
                } else {
                    return doesCategoryMatch && channel.channelType.uniqueName.contains(filter.text)
                }
            }
        }

        let sortedChannels = filteredChannels.sorted()

        self.set(newItems: sortedChannels)
    }
}
