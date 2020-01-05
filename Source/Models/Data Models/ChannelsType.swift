//
//  ChannelType.swift
//  Benji
//
//  Created by Benji Dodgson on 6/24/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import TMROLocalization

enum ChannelType: ManageableCellItem {

    case system(SystemChannel)
    case channel(TCHChannel)

    var uniqueName: String {
        switch self {
        case .system(let channel):
            return channel.uniqueName
        case .channel(let channel):
            return String(optional: channel.friendlyName)
        }
    }

    var displayName: String {
        switch self {
        case .system(let channel):
            return channel.displayName
        case .channel(let channel):
            return String(optional: channel.friendlyName)
        }
    }

    var purpose: String {
        switch self {
        case .system(let channel):
            return localized(channel.context.text)
        case .channel(let channel):
            return String(optional: channel.channelDescription)
        }
    }

    var dateUpdated: Date {
        switch self {
        case .system(let systemMessage):
            return systemMessage.timeStampAsDate
        case .channel(let channel):
            return channel.dateUpdatedAsDate ?? Date.distantPast
        }
    }

    var id: String {
        switch self {
        case .system(let systemMessage):
            return systemMessage.id
        case .channel(let channel):
            return channel.id
        }
    }
}
