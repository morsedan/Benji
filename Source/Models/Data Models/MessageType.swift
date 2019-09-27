//
//  MessageType.swift
//  Benji
//
//  Created by Benji Dodgson on 7/1/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import Parse

enum MessageTypeStatus {
    case delivered
    case sent
    case read
    case unknown
    case error(ClientError)
}

enum MessageType: DisplayableCellItem {

    case user(SystemMessage)
    case system(SystemMessage)
    case message(TCHMessage)

    var createdAt: Date {
        switch self {
        case .system(let message), .user(let message):
            return message.timeStampAsDate
        case .message(let message):
            return message.timestampAsDate ?? Date()
        }
    }

    var backgroundColor: Color {
        switch self {
        case .system(let message), .user(let message):
            return message.isFromCurrentUser ? .lightPurple : .purple
        case .message(let message):
            return message.isFromCurrentUser ? .lightPurple : .purple
        }
    }

    var body: Localized {
        switch self {
        case .system(let message), .user(let message):
            return message.body
        case .message(let message):
            return String(optional: message.body)
        }
    }

    var isFromCurrentUser: Bool {
        switch self {
        case .system(let message), .user(let message):
            return message.isFromCurrentUser
        case .message(let message):
            return message.isFromCurrentUser

        }
    }

    var avatar: Avatar {
        switch self {
        case .system(let message), .user(let message):
            return message.avatars.first!
        case .message(let message):
            return message

        }
    }

    func diffIdentifier() -> NSObjectProtocol {
        switch self {
        case .system(let message), .user(let message):
            return message.diffIdentifier()
        case .message(let message):
            return message.diffIdentifier()
        }
    }

    var author: String {
        switch self {
        case .user(_):
            return String(optional: PFUser.current.objectId)
        case .system(_):
            return "system"
        case .message(let message):
            return String(optional: message.author)
        }
    }

    var status: MessageTypeStatus {
        switch self {
        case .user(let message):
            return message.status
        case .system(_):
            return .unknown
        case .message(let message):
            return message.status
        }
    }
}
