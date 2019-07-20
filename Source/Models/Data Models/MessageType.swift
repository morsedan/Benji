//
//  MessageType.swift
//  Benji
//
//  Created by Benji Dodgson on 7/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

enum MessageType: DisplayableCellItem {

    case system(SystemMessage)
    case message(TCHMessage)

    var createdAt: Date {
        switch self {
        case .system(let message):
            return message.timeStampAsDate
        case .message(let message):
            return message.timestampAsDate ?? Date()
        }
    }

    var backgroundColor: Color {
        switch self {
        case .system(let message):
            return message.isFromCurrentUser ? .lightPurple : .purple
        case .message(let message):
            return message.isFromCurrentUser ? .lightPurple : .purple
        }
    }

    var body: Localized {
        switch self {
        case .system(let message):
            return message.body
        case .message(let message):
            return String(optional: message.body)
        }
    }

    var isFromCurrentUser: Bool {
        switch self {
        case .system(let message):
            return message.isFromCurrentUser
        case .message(let message):
            return message.isFromCurrentUser

        }
    }

    var avatar: Avatar {
        switch self {
        case .system(let message):
            return message.avatar
        case .message(let message):
            return message

        }
    }

    func diffIdentifier() -> NSObjectProtocol {
        switch self {
        case .system(let message):
            return message.diffIdentifier()
        case .message(let message):
            return message.diffIdentifier()
        }
    }
}
