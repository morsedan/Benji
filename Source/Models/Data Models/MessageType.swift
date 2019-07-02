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

    var backgroundColor: Color {
        switch self {
        case .system(_):
            return .blue
        case .message(_):
            return .blue
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
