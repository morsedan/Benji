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

    case intro
    case system(SystemMessage)
    case unreadMessages(TCHChannel, Int)
    case channelInvite(TCHChannel)
    case inviteAsk

    var backgroundColor: Color {
        return .blue
    }

    var id: String {
        switch self {
        case .system(let message):
            return message.id
        case .unreadMessages(let channel, _):
            return channel.sid!
        case .channelInvite(let channel):
            return channel.sid!
        case .inviteAsk:
            return "inviteAsk"
        case .intro:
            return "intro"
        }
    }
}
