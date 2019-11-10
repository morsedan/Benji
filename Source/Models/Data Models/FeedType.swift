//
//  FeedType.swift
//  Benji
//
//  Created by Benji Dodgson on 6/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum FeedType {

    case system(SystemMessage)
    case message(TCHMessage)
    case channelInvite(TCHChannel)

    var backgroundColor: Color {
        switch self {
        case .system(_):
            return .blue
        case .message(_):
            return .blue
        case .channelInvite(_):
            return .blue
        }
    }

    var id: String {
        switch self {
        case .system(let message):
            return message.id
        case .message(let message):
            return message.sid!
        case .channelInvite(let channel):
            return channel.sid!
        }
    }
}
