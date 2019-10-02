//
//  ChannelType.swift
//  Benji
//
//  Created by Benji Dodgson on 6/24/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum ChannelVisibilityType: String {
    case directMessage = "@"
    case group = "#"
}

enum ChannelType: DisplayableCellItem {

    case system(SystemChannel)
    case channel(TCHChannel)

    var backgroundColor: Color {
        switch self {
        case .system(_):
            return .blue
        case .channel(_):
            return .blue
        }
    }

    var scope: SearchScope {
        //Update to show channels and dms
        return .dms
    }

    var uniqueName: String {
        switch self {
        case .system(let channel):
            return channel.uniqueName
        case .channel(let channel):
            return String(optional: channel.uniqueName)
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

    var dateUpdated: Date {
        switch self {
        case .system(let systemMessage):
            return systemMessage.timeStampAsDate
        case .channel(let channel):
            return channel.dateUpdatedAsDate ?? Date.distantPast
        }
    }

    func diffIdentifier() -> NSObjectProtocol {
        switch self {
        case .system(let message):
            return message.diffIdentifier()
        case .channel(let message):
            return message.diffIdentifier()
        }
    }
}
