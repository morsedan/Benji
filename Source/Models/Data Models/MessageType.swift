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
import TMROLocalization

enum MessageTypeStatus {
    case delivered
    case sent
    case read
    case unknown
    case error(ClientError)
}

enum MessageType: ManageableCellItem {

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

    var id: String {
        switch self {
        case .user(let message):
            return message.id
        case .system(let message):
            return message.id
        case .message(let message):
            return message.id
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
            return message.avatar
        case .message(let message):
            return message
        }
    }

    var author: String {
        switch self {
        case .user(_):
            return String(optional: User.current()?.objectId)
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
